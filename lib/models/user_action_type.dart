import 'package:pass_emploi_app/ui/strings.dart';

enum UserActionReferentielType {
  emploi("EMPLOI", Strings.userActionEmploiSuggestions),
  projetProfessionnel("PROJET_PROFESSIONNEL", Strings.userActionProjetProSuggestions),
  cultureSportLoisirs("CULTURE_SPORT_LOISIRS", Strings.userActionLoisirsSportCultureSuggestions),
  citoyennete("CITOYENNETE", Strings.userActionCitoyenneteSuggestions),
  formation("FORMATION", Strings.userActionFormationSuggestions),
  logement("LOGEMENT", Strings.userActionLogementSuggestions),
  sante("SANTE", Strings.userActionSanteSuggestions);

  final String code;
  final List<String> suggestionList;

  const UserActionReferentielType(this.code, this.suggestionList);

  static UserActionReferentielType fromCode(String? value) => values.firstWhere(
        (element) => element.code == value,
        orElse: () => emploi,
      );
}
