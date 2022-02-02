import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class LoginViewModel extends Equatable {
  final DisplayState displayState;
  final List<LoginButtonViewModel> loginButtons;

  LoginViewModel({
    required this.displayState,
    required this.loginButtons,
  });

  factory LoginViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    return LoginViewModel(
      displayState: state is UserNotLoggedInState ? DisplayState.CONTENT : displayStateFromState(state),
      loginButtons: _loginButtons(store, store.state.configurationState.getFlavor()),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

List<LoginButtonViewModel> _loginButtons(Store<AppState> store, Flavor flavor) {
  return [
    LoginButtonViewModel(
      label: Strings.loginPoleEmploi,
      backgroundColor: AppColors.poleEmploi,
      action: () => store.dispatch(RequestLoginAction(RequestLoginMode.POLE_EMPLOI)),
    ),
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
