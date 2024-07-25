import 'package:pass_emploi_app/ui/strings.dart';

enum UserActionReferentielType {
  emploi("EMPLOI", [
    UserActionCategory.faireMonCv,
    UserActionCategory.rechercheDEmploi,
    UserActionCategory.candidature,
    UserActionCategory.entretienDEmbauche,
    UserActionCategory.lettreDeMotivationEmploi,
    UserActionCategory.rechercheDeStageEmploi,
  ]),
  projetProfessionnel("PROJET_PROFESSIONNEL", [
    UserActionCategory.rechercheDeStageProjetPro,
    UserActionCategory.formationProjetPro,
    UserActionCategory.revisions,
    UserActionCategory.rechercheDAlternance,
    UserActionCategory.enqueteMetier,
    UserActionCategory.lettreDeMotivationProjetPro,
  ]),
  cultureSportLoisirs("CULTURE_SPORT_LOISIRS", [
    UserActionCategory.sport,
    UserActionCategory.cinema,
    UserActionCategory.expositionMusee,
    UserActionCategory.spectacleConcert,
    UserActionCategory.dessinMusiqueLecture,
  ]),
  citoyennete("CITOYENNETE", [
    UserActionCategory.examenPermisCode,
    UserActionCategory.codeDeLaRoute,
    UserActionCategory.conduite,
    UserActionCategory.demarchesAdministratives,
    UserActionCategory.demandeDAllocations,
    UserActionCategory.benevolat,
  ]),
  formation("FORMATION", [
    UserActionCategory.rechercheDeFormation,
    UserActionCategory.rechercheDApprentissage,
    UserActionCategory.atelier,
    UserActionCategory.rechercheDeSubvention,
  ]),
  logement("LOGEMENT", [
    UserActionCategory.rechercheDeLogement,
    UserActionCategory.constitutionDunDossier,
    UserActionCategory.visiteDeLogement,
    UserActionCategory.achatImmobilier,
    UserActionCategory.demandeDAideLogement,
  ]),
  sante("SANTE", [
    UserActionCategory.rendezVousMedical,
    UserActionCategory.bilanDeSante,
    UserActionCategory.carteVitale,
    UserActionCategory.demarchesDeSante,
    UserActionCategory.hospitalisation,
    UserActionCategory.reeducation,
  ]);

  final String code;
  final List<UserActionCategory> suggestionList;

  const UserActionReferentielType(this.code, this.suggestionList);

  static UserActionReferentielType fromCode(String? value) => values.firstWhere(
        (element) => element.code == value,
        orElse: () => emploi,
      );
}

enum UserActionCategory {
  // Emploi
  faireMonCv(Strings.faireMonCV, Strings.hintFaireMonCV),
  rechercheDEmploi(Strings.rechercheEmploi, Strings.hintRechercheEmploi),
  candidature(Strings.candidature, Strings.hintCandidature),
  entretienDEmbauche(Strings.entretienEmbauche, Strings.hintEntretienEmbauche),
  lettreDeMotivationEmploi(Strings.lettreMotivationEmploi, Strings.hintLettreMotivationEmploi),
  rechercheDeStageEmploi(Strings.rechercheStageEmploi, Strings.hintRechercheStageEmploi),

  // Projet Professionnel
  rechercheDeStageProjetPro(Strings.rechercheStageProjetPro, Strings.hintRechercheStageProjetPro),
  formationProjetPro(Strings.formationProjetPro, Strings.hintFormationProjetPro),
  revisions(Strings.revisions, Strings.hintRevisions),
  rechercheDAlternance(Strings.rechercheAlternance, Strings.hintRechercheAlternance),
  enqueteMetier(Strings.enqueteMetier, Strings.hintEnqueteMetier),
  lettreDeMotivationProjetPro(Strings.lettreMotivationProjetPro, Strings.hintLettreMotivationProjetPro),

  // Citoyenneté
  examenPermisCode(Strings.examenPermis, Strings.hintExamenPermis),
  codeDeLaRoute(Strings.codeRoute, Strings.hintCodeRoute),
  conduite(Strings.conduite, Strings.hintConduite),
  demarchesAdministratives(Strings.demarchesAdministratives, Strings.hintDemarchesAdministratives),
  demandeDAllocations(Strings.demandeAllocations, Strings.hintDemandeAllocations),
  benevolat(Strings.benevolat, Strings.hintBenevolat),

  // Santé
  rendezVousMedical(Strings.rendezVousMedical, Strings.hintRendezVousMedical),
  bilanDeSante(Strings.bilanSante, Strings.hintBilanSante),
  carteVitale(Strings.carteVitale, Strings.hintCarteVitale),
  demarchesDeSante(Strings.demarchesSante, Strings.hintDemarchesSante),
  hospitalisation(Strings.hospitalisation, Strings.hintHospitalisation),
  reeducation(Strings.reeducation, Strings.hintReeducation),

  // Logement
  rechercheDeLogement(Strings.rechercheLogement, Strings.hintRechercheLogement),
  constitutionDunDossier(Strings.constitutionDossier, Strings.hintConstitutionDossier),
  visiteDeLogement(Strings.visiteLogement, Strings.hintVisiteLogement),
  achatImmobilier(Strings.achatImmobilier, Strings.hintAchatImmobilier),
  demandeDAideLogement(Strings.demandeAideLogement, Strings.hintDemandeAideLogement),

  // Formation
  rechercheDeFormation(Strings.rechercheFormation, Strings.hintRechercheFormation),
  rechercheDApprentissage(Strings.rechercheApprentissage, Strings.hintRechercheApprentissage),
  atelier(Strings.atelier, Strings.hintAtelier),
  rechercheDeSubvention(Strings.rechercheSubvention, Strings.hintRechercheSubvention),

  // Loisirs, Sport, Culture
  sport(Strings.sport, Strings.hintSport),
  cinema(Strings.cinema, Strings.hintCinema),
  expositionMusee(Strings.expositionMusee, Strings.hintExpositionMusee),
  spectacleConcert(Strings.spectacleConcert, Strings.hintSpectacleConcert),
  dessinMusiqueLecture(Strings.dessinMusiqueLecture, Strings.hintDessinMusiqueLecture);

  final String value;
  final String hint;

  const UserActionCategory(this.value, this.hint);
}
