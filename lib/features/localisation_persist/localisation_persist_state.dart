import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

sealed class LocalisationPersistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocalisationPersistNotInitializedState extends LocalisationPersistState {}

class LocalisationPersistSuccessState extends LocalisationPersistState {
  final Location? result;

  LocalisationPersistSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}

extension AppStateLocationPersistExt on Store<AppState> {
  Location? getLastLocationSelected({bool allowDepartment = false}) {
    final state = this.state.localisationPersistState;
    if (state is LocalisationPersistSuccessState) {
      final location = state.result;
      if (location?.type == LocationType.DEPARTMENT && !allowDepartment) {
        return null;
      }
      return location;
    }
    return null;
  }
}
