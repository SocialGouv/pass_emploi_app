import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';

sealed class MonSuiviState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MonSuiviNotInitializedState extends MonSuiviState {}

class MonSuiviLoadingState extends MonSuiviState {}

class MonSuiviFailureState extends MonSuiviState {}

class MonSuiviSuccessState extends MonSuiviState {
  final MonSuivi monSuivi;

  MonSuiviSuccessState(this.monSuivi);

  @override
  List<Object?> get props => [monSuivi];
}
