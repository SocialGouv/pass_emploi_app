import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/ft_ia_tutorial/ft_ia_tutorial_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class FtIaTutorialViewModel extends Equatable {
  final bool isVisible;
  final void Function() onSeen;

  FtIaTutorialViewModel({required this.isVisible, required this.onSeen});

  factory FtIaTutorialViewModel.create(Store<AppState> store) {
    final monSuiviState = store.state.monSuiviState;
    if (monSuiviState is! MonSuiviSuccessState) return FtIaTutorialViewModel(isVisible: false, onSeen: () {});

    if (!monSuiviState.monSuivi.eligibleDemarchesIA) return FtIaTutorialViewModel(isVisible: false, onSeen: () {});

    if (store.state.onboardingState.showActionOnboarding) return FtIaTutorialViewModel(isVisible: false, onSeen: () {});

    final ftIaTutorialState = store.state.ftIaTutorialState;

    return FtIaTutorialViewModel(
      isVisible: ftIaTutorialState.shouldShow,
      onSeen: () => store.dispatch(FtIaTutorialSeenAction()),
    );
  }

  @override
  List<Object?> get props => [isVisible];
}
