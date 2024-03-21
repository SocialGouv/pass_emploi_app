import 'package:pass_emploi_app/models/brand.dart';

class ExternalLinks {
  static final String campagneRecrutement = Brand.isCej() ? campagneRecrutementCej : campagneRecrutementBrsa;
  static const String campagneRecrutementCej =
      "https://framaforms.org/participez-a-la-conception-de-lapplication-du-contrat-dengagement-jeune-1707239593";
  static const String campagneRecrutementBrsa = "https://tally.so/r/wbxAy1";

  static const String unJeuneUneSolution = "https://www.1jeune1solution.gouv.fr/contrat-engagement-jeune";
  static const String espaceCandidats = "https://candidat.pole-emploi.fr/espacepersonnel/";
  static const String boiteAOutilsDiagoriente = "https://app.diagoriente.beta.gouv.fr/register";
  static const String boiteAOutilsAides =
      "https://mes-aides.1jeune1solution.beta.gouv.fr/simulation/individu/demandeur/date_naissance";
  static const String boiteAOutilsMentor = "https://www.1jeune1mentor.fr/formulaire?1jeune1solution";
  static const String boiteAOutilsBenevolatCej =
      "http://api.api-engagement.beta.gouv.fr/r/campaign/64ddc9185331346074141cb1";
  static const String boiteAOutilsBenevolatBrsa =
      "http://api.api-engagement.beta.gouv.fr/r/campaign/64ddca09533134607414370b";
  static const String boiteAOutilsFormation = "https://www.1jeune1solution.gouv.fr/formations";
  static const String boiteAOutilsEvenementRecrutement = "https://www.1jeune1solution.gouv.fr/evenements";
  static const String boiteAOutilsEmploiStore = "https://www.emploi-store.fr/portail/accueil";
  static const String boiteAOutilsEmploiSolidaire = "https://emplois.inclusion.beta.gouv.fr/";
  static const String boiteAOutilsLaBonneBoite = "https://labonneboite.pole-emploi.fr/";
  static const String boiteAOutilsAlternance = "https://www.1jeune1solution.gouv.fr/apprentissage";
}
