import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';

class ParametersProfilePageViewModel extends Equatable {
  final String? userId;
  final List<String>? warningSuppressionFeatures;
  final bool? isPoleEmploiLogin;
  final bool error;
  final bool withLoading;
  final Function() onDeleteUser;

  ParametersProfilePageViewModel({
    this.userId,
    this.warningSuppressionFeatures,
    this.isPoleEmploiLogin,
    this.error = false,
    this.withLoading = false,
    required this.onDeleteUser,
  });

  factory ParametersProfilePageViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState) {
      final id = loginState.user.id;
      final loginMode = loginState.user.loginMode;
      return ParametersProfilePageViewModel(
        userId: id,
        warningSuppressionFeatures:
            loginMode == LoginMode.POLE_EMPLOI ? Strings.warningPointsPoleEmploi : Strings.warningPointsMILO,
        isPoleEmploiLogin: loginMode == LoginMode.POLE_EMPLOI ? true : false,
        error: false,
        onDeleteUser: () => store.dispatch(SuppressionCompteRequestAction()),
      );
    }
    return ParametersProfilePageViewModel(
      userId: null,
      warningSuppressionFeatures: null,
      isPoleEmploiLogin: null,
      error: true,
      onDeleteUser: () => {},
    );
  }

  @override
  List<Object?> get props => [userId, warningSuppressionFeatures, isPoleEmploiLogin, error];
}
