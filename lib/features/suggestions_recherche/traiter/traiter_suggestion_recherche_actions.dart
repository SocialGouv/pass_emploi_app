import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';

enum TraiterSuggestionType { accepter, refuser }

class TraiterSuggestionRechercheRequestAction extends Equatable {
  final SuggestionRecherche suggestion;
  final TraiterSuggestionType type;
  final Location? location;
  final double? rayon;

  TraiterSuggestionRechercheRequestAction(this.suggestion, this.type, {this.location, this.rayon});

  @override
  List<Object?> get props => [suggestion, type, location, rayon];
}

class TraiterSuggestionRechercheLoadingAction {}

class TraiterSuggestionRechercheFailureAction {}

class AccepterSuggestionRechercheSuccessAction {
  final String suggestionId;
  final Alerte alerte;

  AccepterSuggestionRechercheSuccessAction(this.suggestionId, this.alerte);
}

class RefuserSuggestionRechercheSuccessAction {
  final String suggestionId;

  RefuserSuggestionRechercheSuccessAction(this.suggestionId);
}

class TraiterSuggestionRechercheResetAction {}
