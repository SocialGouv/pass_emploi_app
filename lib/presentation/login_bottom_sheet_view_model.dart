import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class LoginBottomSheetViewModel extends Equatable {
  final List<LoginButtonViewModel> loginButtons;

  LoginBottomSheetViewModel({
    required this.loginButtons,
  });

  @override
  List<Object?> get props => [loginButtons];

  factory LoginBottomSheetViewModel.create(Store<AppState> store) {
    final flavor = store.state.configurationState.getFlavor();
    final brand = store.state.configurationState.getBrand();
    return LoginBottomSheetViewModel(
      loginButtons: _loginButtons(store, flavor, brand),
    );
  }
}

List<LoginButtonViewModel> _loginButtons(Store<AppState> store, Flavor flavor, Brand brand) {
  return [
    LoginButtonViewModelPoleEmploi(store),
    if (brand == Brand.cej) LoginButtonViewModelMissionLocale(store),
    if (flavor == Flavor.STAGING) LoginButtonViewModelPassEmploi(store),
  ];
}

sealed class LoginButtonViewModel extends Equatable {
  final Function() action;

  LoginButtonViewModel({required this.action});

  @override
  List<Object?> get props => [];

  bool get isPoleEmploi => this is LoginButtonViewModelPoleEmploi;
}

class LoginButtonViewModelPoleEmploi extends LoginButtonViewModel {
  LoginButtonViewModelPoleEmploi(Store<AppState> store)
      : super(action: () => store.dispatch(RequestLoginAction(RequestLoginMode.POLE_EMPLOI)));
}

class LoginButtonViewModelMissionLocale extends LoginButtonViewModel {
  LoginButtonViewModelMissionLocale(Store<AppState> store)
      : super(action: () => store.dispatch(RequestLoginAction(RequestLoginMode.SIMILO)));
}

class LoginButtonViewModelPassEmploi extends LoginButtonViewModel {
  LoginButtonViewModelPassEmploi(Store<AppState> store)
      : super(action: () => store.dispatch(RequestLoginAction(RequestLoginMode.PASS_EMPLOI)));
}
