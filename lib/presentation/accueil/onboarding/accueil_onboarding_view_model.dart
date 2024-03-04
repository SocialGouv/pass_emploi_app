import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/notifications_permissions/notifications_permissions_actions.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AccueilOnboardingViewModel extends Equatable {
  final String userName;
  final Function() onOnboardingCompleted;
  final Function() onRequestiNotificationsPermission;

  AccueilOnboardingViewModel({
    required this.userName,
    required this.onOnboardingCompleted,
    required this.onRequestiNotificationsPermission,
  });

  factory AccueilOnboardingViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    final user = state is LoginSuccessState ? state.user : null;
    return AccueilOnboardingViewModel(
      userName: user != null ? user.firstName : "",
      onOnboardingCompleted: () => store.dispatch(OnboardingAccueilSaveAction()),
      onRequestiNotificationsPermission: () => store.dispatch(NotificationsPermissionsRequestAction()),
    );
  }

  @override
  List<Object?> get props => [userName, onOnboardingCompleted];
}
