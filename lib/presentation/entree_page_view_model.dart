import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class EntreePageViewModel extends Equatable {
  final bool withRequestAccountButton;
  final bool withLoading;
  final bool withWrongDeviceClockMessage;
  final String? technicalErrorMessage;
  final PreferredLoginModeViewModel? preferredLoginMode;
  final void Function()? onLogin;

  EntreePageViewModel({
    required this.withRequestAccountButton,
    required this.withLoading,
    required this.withWrongDeviceClockMessage,
    required this.technicalErrorMessage,
    required this.preferredLoginMode,
    required this.onLogin,
  });

  factory EntreePageViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final brand = store.state.configurationState.getBrand();
    return EntreePageViewModel(
      withRequestAccountButton: brand.isCej,
      withLoading: loginState is LoginLoadingState,
      withWrongDeviceClockMessage: loginState is LoginWrongDeviceClockState,
      technicalErrorMessage: loginState is LoginGenericFailureState ? loginState.message : null,
      preferredLoginMode: PreferredLoginModeViewModel.create(store),
      onLogin: _onLogin(store),
    );
  }

  @override
  List<Object?> get props => [
        withRequestAccountButton,
        withLoading,
        withWrongDeviceClockMessage,
        technicalErrorMessage,
      ];
}

void Function()? _onLogin(Store<AppState> store) {
  if (Brand.isBrsa()) return () => store.dispatch(RequestLoginAction(LoginMode.POLE_EMPLOI));
  final state = store.state.preferredLoginModeState;
  if (state is! PreferredLoginModeSuccessState) return null;
  return switch (state.loginMode) {
    LoginMode.POLE_EMPLOI => () => store.dispatch(RequestLoginAction(LoginMode.POLE_EMPLOI)),
    LoginMode.MILO => () => store.dispatch(RequestLoginAction(LoginMode.MILO)),
    LoginMode.PASS_EMPLOI => () => store.dispatch(RequestLoginAction(LoginMode.PASS_EMPLOI)),
    _ => null,
  };
}

class PreferredLoginModeViewModel extends Equatable {
  final String title;
  final String logo;

  PreferredLoginModeViewModel({
    required this.title,
    required this.logo,
  });

  static PreferredLoginModeViewModel? create(Store<AppState> store) {
    if (store.state.configurationState.getBrand().isBrsa) return null;
    final state = store.state.preferredLoginModeState;
    if (state is! PreferredLoginModeSuccessState) return null;
    return switch (state.loginMode) {
      LoginMode.POLE_EMPLOI => PreferredLoginModeViewModel(
          title: Strings.loginBottomSeetFranceTravailButton,
          logo: Drawables.poleEmploiLogo,
        ),
      LoginMode.MILO => PreferredLoginModeViewModel(
          title: Strings.loginBottomSeetMissionLocaleButton,
          logo: Drawables.missionLocaleLogo,
        ),
      LoginMode.PASS_EMPLOI => PreferredLoginModeViewModel(
          title: Strings.loginBottomSeetPassEmploiButton,
          logo: Drawables.passEmploiLogo,
        ),
      _ => null,
    };
  }

  @override
  List<Object?> get props => [title, logo];
}
