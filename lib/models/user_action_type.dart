import 'package:pass_emploi_app/ui/strings.dart';

enum UserActionReferentielType {
  emploi("EMPLOI"),
  projetProfessionnel("PROJET_PROFESSIONNEL"),
  cultureSportLoisirs("CULTURE_SPORT_LOISIRS"),
  citoyennete("CITOYENNETE"),
  formation("FORMATION"),
  logement("LOGEMENT"),
  sante("SANTE");

  final String code;

  const UserActionReferentielType(this.code);

  static UserActionReferentielType fromCode(String? value) => values.firstWhere(
        (element) => element.code == value,
        orElse: () => emploi,
      );

  List<String> get suggestionList => switch (this) {
        UserActionReferentielType.emploi => Strings.userActionEmploiSuggestions,
        UserActionReferentielType.projetProfessionnel => Strings.userActionProjetProSuggestions,
        UserActionReferentielType.cultureSportLoisirs => Strings.userActionLoisirsSportCultureSuggestions,
        UserActionReferentielType.citoyennete => Strings.userActionCitoyenneteSuggestions,
        UserActionReferentielType.formation => Strings.userActionFormationSuggestions,
        UserActionReferentielType.logement => Strings.userActionLogementSuggestions,
        UserActionReferentielType.sante => Strings.userActionSanteSuggestions,
      };
}
