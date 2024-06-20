import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_action.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_state.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class SuppressionCompteViewModel extends Equatable {
  final List<String> warningSuppressionFeatures;
  final bool isPoleEmploiLogin;
  final DisplayState? displayState;
  final Function() onDeleteUser;

  SuppressionCompteViewModel({
    required this.warningSuppressionFeatures,
    required this.isPoleEmploiLogin,
    required this.displayState,
    required this.onDeleteUser,
  });

  factory SuppressionCompteViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final isPoleEmploiLogin = loginState is LoginSuccessState && loginState.user.loginMode.isPe();
    final suppessionState = store.state.suppressionCompteState;
    return SuppressionCompteViewModel(
      warningSuppressionFeatures: isPoleEmploiLogin ? Strings.warningPointsPoleEmploi : Strings.warningPointsMilo,
      isPoleEmploiLogin: isPoleEmploiLogin,
      onDeleteUser: () => store.dispatch(SuppressionCompteRequestAction()),
      displayState: _displayState(suppessionState),
    );
  }

  @override
  List<Object?> get props => [warningSuppressionFeatures, isPoleEmploiLogin, displayState];
}

DisplayState? _displayState(SuppressionCompteState state) {
  if (state is SuppressionCompteFailureState) return DisplayState.FAILURE;
  if (state is SuppressionCompteSuccessState) return DisplayState.CONTENT;
  if (state is SuppressionCompteLoadingState) return DisplayState.LOADING;
  return null;
}
