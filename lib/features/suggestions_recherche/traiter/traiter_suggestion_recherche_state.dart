import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';

abstract class TraiterSuggestionRechercheState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TraiterSuggestionRechercheNotInitializedState extends TraiterSuggestionRechercheState {}

class TraiterSuggestionRechercheLoadingState extends TraiterSuggestionRechercheState {}

class TraiterSuggestionRechercheFailureState extends TraiterSuggestionRechercheState {}

class AccepterSuggestionRechercheSuccessState extends TraiterSuggestionRechercheState {
  final Alerte alerte;

  AccepterSuggestionRechercheSuccessState(this.alerte);

  @override
  List<Object?> get props => [alerte];
}

class RefuserSuggestionRechercheSuccessState extends TraiterSuggestionRechercheState {}
