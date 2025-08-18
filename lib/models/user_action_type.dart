import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
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
  faireMonCv(Strings.faireMonCV, Strings.hintFaireMonCV, false),
  rechercheDEmploi(Strings.rechercheEmploi, Strings.hintRechercheEmploi, true),
  candidature(Strings.candidature, Strings.hintCandidature, false),
  entretienDEmbauche(Strings.entretienEmbauche, Strings.hintEntretienEmbauche, true),
  lettreDeMotivationEmploi(Strings.lettreMotivationEmploi, Strings.hintLettreMotivationEmploi, false),
  rechercheDeStageEmploi(Strings.rechercheStageEmploi, Strings.hintRechercheStageEmploi, true),

  // Projet Professionnel
  rechercheDeStageProjetPro(Strings.rechercheStageProjetPro, Strings.hintRechercheStageProjetPro, true),
  formationProjetPro(Strings.formationProjetPro, Strings.hintFormationProjetPro, false),
  revisions(Strings.revisions, Strings.hintRevisions, false),
  rechercheDAlternance(Strings.rechercheAlternance, Strings.hintRechercheAlternance, true),
  enqueteMetier(Strings.enqueteMetier, Strings.hintEnqueteMetier, false),
  lettreDeMotivationProjetPro(Strings.lettreMotivationProjetPro, Strings.hintLettreMotivationProjetPro, false),

  // Citoyenneté
  examenPermisCode(Strings.examenPermis, Strings.hintExamenPermis, false),
  codeDeLaRoute(Strings.codeRoute, Strings.hintCodeRoute, true),
  conduite(Strings.conduite, Strings.hintConduite, true),
  demarchesAdministratives(Strings.demarchesAdministratives, Strings.hintDemarchesAdministratives, false),
  demandeDAllocations(Strings.demandeAllocations, Strings.hintDemandeAllocations, false),
  benevolat(Strings.benevolat, Strings.hintBenevolat, true),

  // Santé
  rendezVousMedical(Strings.rendezVousMedical, Strings.hintRendezVousMedical, false),
  bilanDeSante(Strings.bilanSante, Strings.hintBilanSante, false),
  carteVitale(Strings.carteVitale, Strings.hintCarteVitale, false),
  demarchesDeSante(Strings.demarchesSante, Strings.hintDemarchesSante, false),
  hospitalisation(Strings.hospitalisation, Strings.hintHospitalisation, false),
  reeducation(Strings.reeducation, Strings.hintReeducation, false),

  // Logement
  rechercheDeLogement(Strings.rechercheLogement, Strings.hintRechercheLogement, true),
  constitutionDunDossier(Strings.constitutionDossier, Strings.hintConstitutionDossier, false),
  visiteDeLogement(Strings.visiteLogement, Strings.hintVisiteLogement, false),
  achatImmobilier(Strings.achatImmobilier, Strings.hintAchatImmobilier, false),
  demandeDAideLogement(Strings.demandeAideLogement, Strings.hintDemandeAideLogement, false),

  // Formation
  rechercheDeFormation(Strings.rechercheFormation, Strings.hintRechercheFormation, true),
  rechercheDApprentissage(Strings.rechercheApprentissage, Strings.hintRechercheApprentissage, true),
  atelier(Strings.atelier, Strings.hintAtelier, false),
  rechercheDeSubvention(Strings.rechercheSubvention, Strings.hintRechercheSubvention, true),

  // Loisirs, Sport, Culture
  sport(Strings.sport, Strings.hintSport, true),
  cinema(Strings.cinema, Strings.hintCinema, false),
  expositionMusee(Strings.expositionMusee, Strings.hintExpositionMusee, false),
  spectacleConcert(Strings.spectacleConcert, Strings.hintSpectacleConcert, false),
  dessinMusiqueLecture(Strings.dessinMusiqueLecture, Strings.hintDessinMusiqueLecture, false);

  final String value;
  final String hint;
  final bool allowBatchCreate;

  const UserActionCategory(this.value, this.hint, this.allowBatchCreate);
}

extension UserActionReferentielTypePresentation on UserActionReferentielType {
  static List<UserActionReferentielType> get all => [
        UserActionReferentielType.emploi,
        UserActionReferentielType.projetProfessionnel,
        UserActionReferentielType.cultureSportLoisirs,
        UserActionReferentielType.citoyennete,
        UserActionReferentielType.formation,
        UserActionReferentielType.logement,
        UserActionReferentielType.sante,
      ];

  String get label => switch (this) {
        UserActionReferentielType.emploi => Strings.userActionEmploiLabel,
        UserActionReferentielType.projetProfessionnel => Strings.userActionProjetProfessionnelLabel,
        UserActionReferentielType.cultureSportLoisirs => Strings.userActionCultureSportLoisirsLabel,
        UserActionReferentielType.citoyennete => Strings.userActionCitoyenneteLabel,
        UserActionReferentielType.formation => Strings.userActionFormationLabel,
        UserActionReferentielType.logement => Strings.userActionLogementLabel,
        UserActionReferentielType.sante => Strings.userActionSanteLabel,
      };

  String get description => switch (this) {
        UserActionReferentielType.emploi => Strings.userActionEmploiDescription,
        UserActionReferentielType.projetProfessionnel => Strings.userActionProjetProfessionnelDescription,
        UserActionReferentielType.cultureSportLoisirs => Strings.userActionCultureSportLoisirsDescription,
        UserActionReferentielType.citoyennete => Strings.userActionCitoyenneteDescription,
        UserActionReferentielType.formation => Strings.userActionFormationDescription,
        UserActionReferentielType.logement => Strings.userActionLogementDescription,
        UserActionReferentielType.sante => Strings.userActionSanteDescription,
      };

  IconData get icon => switch (this) {
        UserActionReferentielType.emploi => AppIcons.work_outline_rounded,
        UserActionReferentielType.projetProfessionnel => AppIcons.ads_click_rounded,
        UserActionReferentielType.cultureSportLoisirs => AppIcons.sports_football_outlined,
        UserActionReferentielType.citoyennete => AppIcons.attach_file,
        UserActionReferentielType.formation => AppIcons.school_outlined,
        UserActionReferentielType.logement => AppIcons.door_front_door_outlined,
        UserActionReferentielType.sante => AppIcons.local_hospital_outlined,
      };
}
