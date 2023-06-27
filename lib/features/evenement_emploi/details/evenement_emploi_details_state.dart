import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_details.dart';

sealed class EvenementEmploiDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EvenementEmploiDetailsNotInitializedState extends EvenementEmploiDetailsState {}

class EvenementEmploiDetailsLoadingState extends EvenementEmploiDetailsState {}

class EvenementEmploiDetailsFailureState extends EvenementEmploiDetailsState {}

class EvenementEmploiDetailsSuccessState extends EvenementEmploiDetailsState {
  final EvenementEmploiDetails details;

  EvenementEmploiDetailsSuccessState(this.details);

  @override
  List<Object?> get props => [details];
}
