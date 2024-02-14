import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class LoginViewModel extends Equatable {
  final String suiviText;
  final List<LoginButtonViewModel> loginButtons;
  final bool withAskAccountButton;
  final bool withLoading;
  final bool withWrongDeviceClockMessage;
  final String? technicalErrorMessage;

  LoginViewModel({
    required this.suiviText,
    required this.loginButtons,
    required this.withAskAccountButton,
    required this.withLoading,
    required this.withWrongDeviceClockMessage,
    required this.technicalErrorMessage,
  });

  factory LoginViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final flavor = store.state.configurationState.getFlavor();
    final brand = store.state.configurationState.getBrand();
    return LoginViewModel(
      suiviText: brand.isCej ? Strings.suiviParConseillerCEJ : Strings.suiviParConseillerBRSA,
      loginButtons: _loginButtons(store, flavor, brand),
      withAskAccountButton: brand.isCej,
      withLoading: loginState is LoginLoadingState,
      withWrongDeviceClockMessage: loginState is LoginWrongDeviceClockState,
      technicalErrorMessage: loginState is LoginGenericFailureState ? loginState.message : null,
    );
  }

  @override
  List<Object?> get props => [
        suiviText,
        loginButtons,
        withAskAccountButton,
        withLoading,
        withWrongDeviceClockMessage,
        technicalErrorMessage,
      ];
}

List<LoginButtonViewModel> _loginButtons(Store<AppState> store, Flavor flavor, Brand brand) {
  return [
    LoginButtonViewModel(
      label: Strings.loginPoleEmploi,
      backgroundColor: AppColors.poleEmploi,
      action: () => store.dispatch(RequestLoginAction(RequestLoginMode.POLE_EMPLOI)),
    ),
    if (brand == Brand.cej)
      LoginButtonViewModel(
        label: Strings.loginMissionLocale,
        backgroundColor: AppColors.missionLocale,
        action: () => store.dispatch(RequestLoginAction(RequestLoginMode.SIMILO)),
      ),
    if (flavor == Flavor.STAGING)
      LoginButtonViewModel(
        label: Strings.loginPassEmploi,
        backgroundColor: AppColors.primary,
        action: () => store.dispatch(RequestLoginAction(RequestLoginMode.PASS_EMPLOI)),
      ),
  ];
}

class LoginButtonViewModel extends Equatable {
  final String label;
  final Color backgroundColor;
  final Function() action;

  LoginButtonViewModel({required this.label, required this.backgroundColor, required this.action});

  @override
  List<Object?> get props => [label];
}
