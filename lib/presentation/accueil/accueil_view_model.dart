import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AccueilViewModel extends Equatable {
  AccueilViewModel();

  factory AccueilViewModel.create(Store<AppState> store) {
    return AccueilViewModel();
  }

  @override
  List<Object?> get props => [];
}
