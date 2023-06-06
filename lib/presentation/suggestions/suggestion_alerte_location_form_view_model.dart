import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestion_recherche_card_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class SuggestionAlerteLocationFormViewModel extends Equatable {
  SuggestionAlerteLocationFormViewModel({
    required this.hint,
    required this.villesOnly,
  });

  final String hint;
  final bool villesOnly;

  factory SuggestionAlerteLocationFormViewModel.create(SuggestionRechercheCardViewModel baseViewModel) {
    final type = baseViewModel.type;
    return SuggestionAlerteLocationFormViewModel(
      hint: _hint(type),
      villesOnly: _villesOnly(type),
    );
  }

  @override
  List<Object?> get props => [hint, villesOnly];
}

String _hint(OffreType type) {
  return switch (type) {
    OffreType.emploi => Strings.localisationFormEmploiSubtitle,
    OffreType.immersion => Strings.localisationFormImmersionSubtitle,
    _ => throw Exception("Forbidden type $type"),
  };
}

bool _villesOnly(OffreType type) {
  return switch (type) {
    OffreType.emploi => false,
    OffreType.immersion => true,
    _ => throw Exception("Forbidden type $type"),
  };
}
