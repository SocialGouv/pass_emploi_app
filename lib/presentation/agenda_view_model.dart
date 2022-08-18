import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AgendaPageViewModel extends Equatable {
  AgendaPageViewModel();

  factory AgendaPageViewModel.create(Store<AppState> store) {
    return AgendaPageViewModel();
  }

  @override
  List<Object?> get props => [];
}
