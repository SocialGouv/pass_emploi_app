import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
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

  ParametersProfilePageViewModel({
    this.userId,
    this.warningSuppressionFeatures,
    this.isPoleEmploiLogin,
    this.error = false,
    this.withLoading = false,
  });

  factory ParametersProfilePageViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState) {
      final id = loginState.user.id;
      final loginMode = loginState.user.loginMode;
      return ParametersProfilePageViewModel(
        userId: id,
        warningSuppressionFeatures: loginMode == LoginMode.POLE_EMPLOI ? Strings.warningPointsPoleEmploi : Strings.warningPointsMILO,
        isPoleEmploiLogin: loginMode == LoginMode.POLE_EMPLOI ? true : false,
        error: false,
      );
    }
    return ParametersProfilePageViewModel(
      userId: null,
      warningSuppressionFeatures: null,
      isPoleEmploiLogin: null,
      error: true,
    );
  }

  @override
  List<Object?> get props => [userId, warningSuppressionFeatures, isPoleEmploiLogin, error];
}
