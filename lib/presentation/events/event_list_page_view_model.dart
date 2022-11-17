import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class EventListPageViewModel extends Equatable {
  EventListPageViewModel();

  factory EventListPageViewModel.create(Store<AppState> store) {
    return EventListPageViewModel();
  }

  @override
  List<Object?> get props => [];
}
