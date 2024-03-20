import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class AccueilOnboardingViewModel extends Equatable {
  final String userName;
  final String body;
  final bool shouldDismiss;
  final Function() onOnboardingCompleted;
  final Function() onRequestNotificationsPermission;

  AccueilOnboardingViewModel({
    required this.userName,
    required this.body,
    required this.shouldDismiss,
    required this.onOnboardingCompleted,
    required this.onRequestNotificationsPermission,
  });

  factory AccueilOnboardingViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    final user = state is LoginSuccessState ? state.user : null;
    final isPe = state is LoginSuccessState && state.user.loginMode.isPe();
    return AccueilOnboardingViewModel(
      userName: user != null ? "${user.firstName} " : "",
      body: isPe ? Strings.accueilOnboardingBody1Pe : Strings.accueilOnboardingBody1Milo,
      shouldDismiss: !store.state.onboardingState.showAccueilOnboarding,
      onOnboardingCompleted: () => store.dispatch(OnboardingAccueilSaveAction()),
      onRequestNotificationsPermission: () => store.dispatch(OnboardingPushNotificationPermissionRequestAction()),
    );
  }

  @override
  List<Object?> get props => [userName, body, shouldDismiss];
}
