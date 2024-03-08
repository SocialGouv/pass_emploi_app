import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum EventTab { maMissionLocale, rechercheExternes }

class EventsTabPageViewModel extends Equatable {
  final List<EventTab> tabs;
  final bool shouldShowOnboarding;

  EventsTabPageViewModel._({
    required this.tabs,
    required this.shouldShowOnboarding,
  });

  factory EventsTabPageViewModel.create(Store<AppState> store) {
    return EventsTabPageViewModel._(
      tabs: [
        EventTab.maMissionLocale,
        EventTab.rechercheExternes,
      ],
      shouldShowOnboarding: _shouldShowOnboarding(store),
    );
  }

  @override
  List<Object?> get props => [tabs, shouldShowOnboarding];
}

bool _shouldShowOnboarding(Store<AppState> store) {
  final onboarding = store.state.onboardingState;
  if (onboarding is OnboardingSuccessState) return onboarding.result.showEvenementsOnboarding == true;
  return false;
}
