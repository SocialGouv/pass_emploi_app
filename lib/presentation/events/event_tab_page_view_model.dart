import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum EventTab { maMissionLocale, rechercheExternes }

class EventsTabPageViewModel extends Equatable {
  final List<EventTab> tabs;

  EventsTabPageViewModel._({
    required this.tabs,
  });

  factory EventsTabPageViewModel.create(Store<AppState> store) {
    return EventsTabPageViewModel._(tabs: [
      EventTab.maMissionLocale,
      EventTab.rechercheExternes,
    ]);
  }

  @override
  List<Object?> get props => [tabs];
}
