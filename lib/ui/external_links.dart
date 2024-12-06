import 'package:pass_emploi_app/models/brand.dart';

class ExternalLinks {
  static final String campagneRecrutement = Brand.isCej()
      ? "https://framaforms.org/participez-a-la-conception-de-lapplication-du-contrat-dengagement-jeune-1707239593"
      : "https://tally.so/r/wbxAy1";
  static const String unJeuneUneSolution = "https://www.1jeune1solution.gouv.fr/contrat-engagement-jeune";
  static const String espaceCandidats = "https://candidat.pole-emploi.fr/espacepersonnel/";
  static const String boiteAOutilsDiagoriente = "https://app.diagoriente.beta.gouv.fr/register";
  static const String boiteAOutilsMesAidesFt =
      "https://mes-aides.francetravail.fr/?at_medium=CMP&at_campaign=DEUDMA&at_cmp_indicateur1=CEJ&at_cmp_indicateur2=APP&at_cmp_indicateur3=jeunes&at_cmp_indicateur4=BRSA0824";
  static const String boiteAOutilsMesAides1J1S =
      "https://mes-aides.1jeune1solution.beta.gouv.fr/simulation/individu/demandeur/date_naissance";
  static const String boiteAOutilsMentor = "https://www.1jeune1mentor.fr/formulaire?1jeune1solution";
  static final String boiteAOutilsBenevolat = Brand.isCej()
      ? "http://api.api-engagement.beta.gouv.fr/r/campaign/64ddc9185331346074141cb1"
      : "http://api.api-engagement.beta.gouv.fr/r/campaign/64ddca09533134607414370b";
  static const String laBonneAlternance =
      "https://labonnealternance.apprentissage.beta.gouv.fr/?utm_source=cej&utm_medium=appli-cej&utm_campaign=cej_candidats_boite-a-outils-appli-du-cej";
  static const String boiteAOutilsFormation = "https://www.1jeune1solution.gouv.fr/formations";
  static const String boiteAOutilsEvenementRecrutement = "https://www.1jeune1solution.gouv.fr/evenements";
  static const String boiteAOutilsEmploiStore = "https://www.emploi-store.fr/portail/accueil";
  static const String boiteAOutilsEmploiSolidaire = "https://emplois.inclusion.beta.gouv.fr/";
  static const String boiteAOutilsLaBonneBoite = "https://labonneboite.pole-emploi.fr/";
  static const String boiteAOutilsAlternance = "https://www.1jeune1solution.gouv.fr/apprentissage";
}
