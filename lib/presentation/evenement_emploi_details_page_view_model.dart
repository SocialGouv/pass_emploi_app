import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class EvenementEmploiDetailsPageViewModel extends Equatable {
  EvenementEmploiDetailsPageViewModel();

  factory EvenementEmploiDetailsPageViewModel.create(Store<AppState> store) {
    return EvenementEmploiDetailsPageViewModel();
  }

  @override
  List<Object?> get props => [];
}
