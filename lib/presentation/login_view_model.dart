import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class LoginViewModel extends Equatable {
  final DisplayState displayState;
  final String suiviText;
  final List<LoginButtonViewModel> loginButtons;
  final bool withAskAccountButton;

  LoginViewModel({
    required this.displayState,
    required this.suiviText,
    required this.loginButtons,
    required this.withAskAccountButton,
  });

  factory LoginViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final flavor = store.state.configurationState.getFlavor();
    final brand = store.state.configurationState.getBrand();
    return LoginViewModel(
      displayState: _displayState(loginState),
      suiviText: brand.isCej ? Strings.suiviParConseillerCEJ : Strings.suiviParConseillerBRSA,
      loginButtons: _loginButtons(store, flavor, brand),
      withAskAccountButton: brand.isCej,
    );
  }

  @override
  List<Object?> get props => [displayState, suiviText];
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

DisplayState _displayState(LoginState state) {
  if (state is UserNotLoggedInState) return DisplayState.contenu;
  if (state is LoginLoadingState) return DisplayState.chargement;
  if (state is LoginSuccessState) return DisplayState.contenu;
  return DisplayState.erreur;
}

class LoginButtonViewModel extends Equatable {
  final String label;
  final Color backgroundColor;
  final Function() action;

  LoginButtonViewModel({required this.label, required this.backgroundColor, required this.action});

  @override
  List<Object?> get props => [label];
}
