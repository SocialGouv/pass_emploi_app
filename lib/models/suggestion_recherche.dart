import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/user_action.dart';

class SuggestionRecherche extends Equatable {
  SuggestionRecherche();

  factory SuggestionRecherche.fromJson(dynamic json) {
    return SuggestionRecherche();
  }

  SuggestionRecherche copyWith() {
    return SuggestionRecherche();
  }

  @override
  List<Object?> get props => [];
}