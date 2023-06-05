import 'package:clock/clock.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/accueil/accueil.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/cv_pole_emploi.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/models/diagoriente_urls.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_details.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_modalite.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/models/partage_activite.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/requests/contact_immersion_request.dart';
import 'package:pass_emploi_app/models/saved_search/evenement_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/models/version.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_contact_form_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../utils/test_datetime.dart';

User mockUser({String id = "", LoginMode loginMode = LoginMode.MILO}) => User(
      id: id,
      firstName: "",
      lastName: "",
      email: "",
      loginMode: loginMode,
    );

LoginState successMiloUserState({User? user}) => LoginSuccessState(user ?? mockedMiloUser());

User mockedMiloUser() {
  return User(
    id: "id",
    firstName: "F",
    lastName: "L",
    email: "first.last@milo.fr",
    loginMode: LoginMode.MILO,
  );
}

LoginState successPoleEmploiUserState() => LoginSuccessState(mockedPoleEmploiUser());

User mockedPoleEmploiUser() {
  return User(
    id: "id",
    firstName: "F",
    lastName: "L",
    email: "first.last@pole-emploi.fr",
    loginMode: LoginMode.POLE_EMPLOI,
  );
}

LoginState successPassEmploiUserState() => LoginSuccessState(User(
      id: "id",
      firstName: "F",
      lastName: "L",
      email: null,
      loginMode: LoginMode.PASS_EMPLOI,
    ));

AppState loggedInState() => AppState.initialState().copyWith(loginState: successMiloUserState());

AppState loggedInMiloState() => AppState.initialState().copyWith(loginState: successMiloUserState());

AppState loggedInPoleEmploiState() => AppState.initialState().copyWith(loginState: successPoleEmploiUserState());

Response invalidHttpResponse({String message = ""}) => Response(message, 500);

HttpExceptionWithStatus deletedOfferHttpResponse() => throw HttpExceptionWithStatus(404, "Offer was delete");

OffreEmploiDetails mockOffreEmploiDetails() => OffreEmploiDetails(
      id: "123TZKB",
      title: "Technicien / Technicienne d'installation de réseaux câblés  (H/F)",
      urlRedirectPourPostulation: "https://candidat.pole-emploi.fr/offres/recherche/detail/123TZKB",
      description: "Vos Missions :\n\nRéaliser du tirage de câbles,\n"
          "Effectuer des raccordements en fibre optique et câble coaxial,\n\n"
          "Le permis B est requis pour ce poste car vous vous déplacerez à bord "
          "d'un véhicule de service mis à votre disposition.",
      contractType: "Contrat à durée indéterminée",
      duration: "35H Horaires normaux",
      location: "59 - Nord",
      salary: "Mensuel de 1590 Euros sur 12 mois",
      companyName: "LTD INTERNATIONAL",
      companyDescription: "LTD international est à la fois un cabinet de recrutement et une agence de travail "
          "temporaire spécialisé dans le tertiaire haut de gamme et le luxe.",
      companyUrl: "http://www.ltd-international.com/",
      companyAdapted: false,
      companyAccessibility: false,
      experience: "Débutant accepté - Expérience électricité/VRD appréciée",
      requiredExperience: "D",
      educations: [
        Education(level: "Bac+5 et plus ou équivalents", field: "conduite projet industriel", requirement: "E")
      ],
      languages: [Language(type: "Anglais", requirement: "E"), Language(type: "Espagnol", requirement: "S")],
      driverLicences: [
        DriverLicence(category: "B - Véhicule léger", requirement: "E"),
      ],
      skills: [
        Skill(description: "Chiffrage/calcul de coût", requirement: "S"),
        Skill(
            description: "Installer l'équipement sur le site et le connecter aux réseaux extérieurs", requirement: "E"),
        Skill(description: "Identifier les matériels à intégrer", requirement: "E"),
        Skill(description: "Assembler les éléments de l'équipement", requirement: "E"),
        Skill(description: "Connecter une boîte de raccordements", requirement: "E")
      ],
      softSkills: ["Autonomie", "Capacité de décision", "Persévérance"],
      lastUpdate: parseDateTimeUtcWithCurrentTimeZone("2021-11-22T14:47:29.000Z"),
      isAlternance: false,
    );

OffreEmploi mockOffreEmploi({String id = "123DXPM", bool isAlternance = false, String contractType = 'MIS'}) {
  return OffreEmploi(
    id: id,
    title: "Technicien / Technicienne en froid et climatisation",
    companyName: "RH TT INTERIM",
    contractType: contractType,
    isAlternance: isAlternance,
    location: "77 - LOGNES",
    duration: "Temps plein",
  );
}

List<OffreEmploi> mockOffresEmploi10() => List.generate(10, (index) => mockOffreEmploi());

OffreEmploiItemViewModel mockOffreEmploiItemViewModel({String id = '123DXPM'}) {
  return OffreEmploiItemViewModel(
    id: id,
    title: 'Technicien / Technicienne en froid et climatisation',
    companyName: 'RH TT INTERIM',
    contractType: 'MIS',
    duration: 'Temps plein',
    location: '77 - LOGNES',
  );
}

AuthTokenResponse authTokenResponse() => AuthTokenResponse(
      accessToken: 'accessToken',
      idToken: 'idToken',
      refreshToken: 'refreshToken',
    );

Configuration configuration(
    {Version version = const Version(1, 0, 0), Flavor flavor = Flavor.STAGING, Brand brand = Brand.cej}) {
  return Configuration(
    version,
    flavor,
    brand,
    'serverBaseUrl',
    'matomoBaseUrl',
    'matomoSiteId',
    'matomoDimensionProduitId',
    'authClientId',
    'authLoginRedirectUrl',
    'authLogoutRedirectUrl',
    'authIssuer',
    ['scope1', 'scope2', 'scope3'],
    'authClientSecret',
    'someKey',
    'actualisationPoleEmploiUrl',
    'Europe/Paris',
  );
}

Configuration brsaConfiguration() => configuration(brand: Brand.brsa);

Location mockLocationParis() => Location(
      libelle: "Paris",
      code: "75",
      type: LocationType.DEPARTMENT,
      latitude: 1,
      longitude: 2,
    );

Location mockLocation({double? lat, double? lon}) => Location(
      libelle: "",
      code: "",
      type: LocationType.DEPARTMENT,
      latitude: lat,
      longitude: lon,
    );

Location mockCommuneLocation({double? lat, double? lon, String label = ""}) => Location(
      libelle: label,
      code: "code",
      codePostal: "codePostal",
      type: LocationType.COMMUNE,
      latitude: lat,
      longitude: lon,
    );

Immersion mockImmersion({String id = "", bool fromEntrepriseAccueillante = false}) {
  return Immersion(
    id: id,
    metier: "",
    nomEtablissement: "",
    secteurActivite: "",
    ville: "",
    fromEntrepriseAccueillante: fromEntrepriseAccueillante,
  );
}

List<Immersion> mockOffresImmersion10() => List.generate(10, (index) => mockImmersion());

ImmersionDetails mockImmersionDetails() {
  return ImmersionDetails(
    id: 'id',
    metier: 'metier',
    companyName: 'companyName',
    secteurActivite: 'secteurActivite',
    ville: 'ville',
    address: 'address',
    codeRome: 'codeRome',
    siret: 'siret',
    fromEntrepriseAccueillante: true,
    contact: ImmersionContact(
      firstName: '',
      lastName: '',
      phone: '',
      mail: '',
      role: '',
      mode: ImmersionContactMode.INCONNU,
    ),
  );
}

ImmersionContactUserInput mockImmersionContactUserInput() {
  return ImmersionContactUserInput(
    firstName: "Philippe",
    lastName: "Flopflip",
    email: "philippe.flopflip@magiciens.com",
    message: "Bonjour, j'aimerai faire une immersion dans votre salon de magie.",
  );
}

ContactImmersionRequest mockContactImmersionRequest() {
  return ContactImmersionRequest(mockImmersionDetails(), mockImmersionContactUserInput());
}

ServiceCivique mockServiceCivique({String id = "123DXPM"}) => ServiceCivique(
      id: id,
      startDate: '17/02/2022',
      title: "Technicien / Technicienne en froid et climatisation",
      companyName: "RH TT INTERIM",
      domain: 'Informatique',
      location: "77 - LOGNES",
    );

List<ServiceCivique> mockOffresServiceCivique10() => List.generate(10, (index) => mockServiceCivique());

ServiceCiviqueDetail mockServiceCiviqueDetail() => ServiceCiviqueDetail(
      id: "123DXPM",
      dateDeDebut: '17/02/2022',
      dateDeFin: '17/02/2022',
      titre: "Technicien / Technicienne en froid et climatisation",
      organisation: "RH TT INTERIM",
      domaine: 'Informatique',
      ville: "LOGNES",
      urlOrganisation: "url de l'organisation",
      adresseMission: "je suis une addresse",
      adresseOrganisation: "je suis une addresse",
      codeDepartement: "77",
      description: "C'est toi la description",
      descriptionOrganisation: "Bon ça va là les description, ça suffit",
      lienAnnonce: "Bonjour, moi c'est le lien (social ?) mwahaha",
      codePostal: "75002",
    );

Rendezvous mockAnimationCollective() {
  return Rendezvous(
    id: '2d663392-b9ff-4b20-81ca-70a3c779e299',
    source: RendezvousSource.passEmploi,
    date: parseDateTimeUtcWithCurrentTimeZone('2021-11-28T13:34:00.000Z'),
    modality: 'en présentiel : Misson locale / Permanence',
    isInVisio: false,
    duration: 23,
    withConseiller: true,
    isAnnule: false,
    type: RendezvousType(RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER, 'Entretien individuel conseiller'),
    title: "super entretien",
    comment: 'Amener votre CV',
    conseiller: Conseiller(id: '1', firstName: 'Nils', lastName: 'Tavernier'),
    createur: Conseiller(id: '2', firstName: 'Joe', lastName: 'Pesci'),
    estInscrit: true,
  );
}

Rendezvous rendezvousStub({String? id, DateTime? date}) {
  return Rendezvous(
    id: id ?? "id-1",
    source: RendezvousSource.passEmploi,
    date: date ?? DateTime(2021, 07, 21),
    isInVisio: false,
    isAnnule: false,
    type: RendezvousType(RendezvousTypeCode.VISITE, "Visite"),
    withConseiller: true,
    duration: 120,
    conseiller: Conseiller(id: "1", firstName: "Nils", lastName: "Tavernier"),
    modality: "par visio",
  );
}

Rendezvous mockRendezvous({
  String id = '',
  RendezvousSource source = RendezvousSource.passEmploi,
  bool isInVisio = false,
  bool isAnnule = false,
  bool isInscrit = false,
  RendezvousType type = const RendezvousType(RendezvousTypeCode.AUTRE, ''),
  String? title,
  bool? withConseiller,
  DateTime? date,
  String? modality,
  int? duration,
  String? comment,
  String? organism,
  String? address,
  String? phone,
  String? visioRedirectUrl,
  String? theme,
  String? description,
  String? precision,
  Conseiller? conseiller = const Conseiller(id: 'id', firstName: 'F', lastName: 'L'),
  Conseiller? createur,
}) {
  return Rendezvous(
    id: id,
    source: source,
    title: title,
    date: date ?? DateTime.now(),
    duration: duration,
    modality: modality,
    isInVisio: isInVisio,
    estInscrit: isInscrit,
    isAnnule: isAnnule,
    type: type,
    withConseiller: withConseiller,
    comment: comment,
    organism: organism,
    address: address,
    phone: phone,
    visioRedirectUrl: visioRedirectUrl,
    theme: theme,
    description: description,
    precision: precision,
    conseiller: conseiller,
    createur: createur,
  );
}

Rendezvous mockRendezvousMiloCV() {
  return Rendezvous(
    id: '2d663392-b9ff-4b20-81ca-70a3c779e299',
    source: RendezvousSource.milo,
    date: parseDateTimeUtcWithCurrentTimeZone('2021-11-28T13:34:00.000Z'),
    modality: 'en présentiel : Misson locale / Permanence',
    isInVisio: false,
    duration: 23,
    withConseiller: true,
    isAnnule: false,
    type: RendezvousType(RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER, 'Entretien individuel conseiller'),
    title: 'super entretien',
    comment: 'Amener votre CV',
    conseiller: Conseiller(id: '1', firstName: 'Nils', lastName: 'Tavernier'),
    createur: Conseiller(id: '2', firstName: 'Joe', lastName: 'Pesci'),
  );
}

Rendezvous mockRendezvousPoleEmploi() {
  return Rendezvous(
    id: '4995ea8a-4f6a-48be-925e-f45593c481f6',
    source: RendezvousSource.passEmploi,
    date: parseDateTimeUtcWithCurrentTimeZone('2021-11-28T13:34:00.000Z'),
    title: 'Super titre',
    modality: 'par visio',
    withConseiller: null,
    isAnnule: true,
    isInVisio: true,
    type: RendezvousType(RendezvousTypeCode.PRESTATION, 'Prestation'),
    duration: null,
    address: '11 RUE Paul Vimereu  80142 ABBEVILLE',
    organism: 'Agence Pôle Emploi',
    phone: '01.02.03.04.05',
    theme: 'Activ\'Projet',
    description: 'J\'explore des pistes professionnelles.',
    visioRedirectUrl: 'http://www.visio.fr',
  );
}

EvenementEmploi mockEvenementEmploi() {
  return EvenementEmploi(
    id: 'id',
    type: 'type',
    titre: 'titre',
    ville: 'ville',
    codePostal: 'codePostal',
    dateDebut: DateTime(2023, 1, 1, 10, 0, 0),
    dateFin: DateTime(2023, 1, 1, 13, 0, 0),
    modalites: [EvenementEmploiModalite.enPhysique],
  );
}

List<EvenementEmploi> mockEvenementsEmploi() => [mockEvenementEmploi()];

EvenementEmploiDetails mockEvenementEmploiDetails() {
  return EvenementEmploiDetails(
    id: "106757",
    ville: "Ermont",
    codePostal: "95120",
    description: "Information collective pour découvrir les métiers de pôle emploi en vu d'un recrutement...",
    titre: "Devenir conseiller à Pôle emploi",
    typeEvenement: "Réunion d'information",
    dateEvenement: parseDateTimeUtcWithCurrentTimeZone("2023-06-15T12:00:00.000+00:00"),
    heureDebut: DateTime(1970, 1, 1, 12, 0, 0),
    heureFin: DateTime(1970, 1, 1, 15, 0, 0),
    url: "https://mesevenementsemploi-t.pe-qvr.fr/mes-evenements-emploi/mes-evenements-emploi/evenement/106757",
  );
}

DetailsJeune detailsJeune() {
  return DetailsJeune(
    conseiller: DetailsJeuneConseiller(firstname: "Perceval", lastname: "de Galles", sinceDate: DateTime(2005, 1, 3)),
  );
}

DetailsJeune detailsJeuneSinceOneMonth() {
  return DetailsJeune(
    conseiller: DetailsJeuneConseiller(
      firstname: "Perceval",
      lastname: "de Galles",
      sinceDate: clock.now().subtract(Duration(days: 31)),
    ),
  );
}

DetailsJeune detailsJeuneSinceLessOneMonth() {
  return DetailsJeune(
    conseiller: DetailsJeuneConseiller(
      firstname: "Perceval",
      lastname: "de Galles",
      sinceDate: clock.now().subtract(Duration(days: 29)),
    ),
  );
}

Campagne campagne([String? id]) {
  return Campagne(
    id: id ?? '7',
    titre: 'Questionnaire',
    description: 'Super test',
    questions: [],
  );
}

DemarcheDuReferentiel mockDemarcheDuReferentiel([String? id, List<Comment>? comments]) {
  return DemarcheDuReferentiel(
    id: id ?? '1',
    quoi: 'quoi',
    pourquoi: 'pourquoi',
    codeQuoi: 'codeQuoi',
    codePourquoi: 'codePourquoi',
    comments: comments ??
        [
          Comment(label: 'label1', code: 'code1'),
          Comment(label: 'label2', code: 'code2'),
        ],
    isCommentMandatory: true,
  );
}

UserAction userActionStub({String? id, DateTime? dateEcheance}) {
  return UserAction(
    id: id ?? "id-1",
    content: "content",
    comment: "comment",
    status: UserActionStatus.IN_PROGRESS,
    dateEcheance: dateEcheance ?? parseDateTimeUtcWithCurrentTimeZone("2007-07-07T01:01:07.000Z"),
    creator: JeuneActionCreator(),
  );
}

Demarche demarcheStub({String? id, DateTime? dateEcheance}) {
  return Demarche(
    id: id ?? "1",
    content: "Identification de ses compétences avec pole-emploi.fr",
    status: DemarcheStatus.IN_PROGRESS,
    endDate: dateEcheance ?? parseDateTimeUtcWithCurrentTimeZone('2021-12-21T09:00:00.000Z'),
    deletionDate: null,
    createdByAdvisor: true,
    label: "Mon (nouveau) métier",
    possibleStatus: [
      DemarcheStatus.CANCELLED,
      DemarcheStatus.DONE,
      DemarcheStatus.NOT_STARTED,
      DemarcheStatus.IN_PROGRESS
    ],
    creationDate: parseDateTimeUtcWithCurrentTimeZone('2022-05-11T09:04:00.000Z'),
    modifiedByAdvisor: false,
    sousTitre: "Par un autre moyen",
    titre: "Identification de ses points forts et de ses compétences",
    modificationDate: null,
    attributs: [
      DemarcheAttribut(key: "metier", value: "Agriculture"),
    ],
  );
}

UserAction mockUserAction({
  String? id,
  String? content,
  String? comment,
  UserActionStatus? status,
  DateTime? lastUpdate,
  DateTime? dateEcheance,
  UserActionCreator? creator,
}) {
  return UserAction(
    id: id ?? '',
    content: content ?? '',
    comment: comment ?? '',
    status: status ?? UserActionStatus.IN_PROGRESS,
    dateEcheance: dateEcheance ?? DateTime.now(),
    creator: creator ?? JeuneActionCreator(),
  );
}

Demarche mockDemarche({
  String id = 'id',
  DemarcheStatus status = DemarcheStatus.NOT_STARTED,
  DateTime? endDate,
  DateTime? deletionDate,
  List<DemarcheAttribut>? attributs,
}) {
  return Demarche(
    id: id,
    content: null,
    status: status,
    endDate: endDate,
    deletionDate: deletionDate,
    createdByAdvisor: true,
    label: null,
    possibleStatus: [],
    creationDate: null,
    modifiedByAdvisor: false,
    sousTitre: null,
    titre: null,
    modificationDate: null,
    attributs: attributs ?? [],
  );
}

UserAction mockNotStartedAction({required String actionId}) {
  return UserAction(
    id: actionId,
    content: "content",
    comment: "comment",
    status: UserActionStatus.NOT_STARTED,
    dateEcheance: DateTime(2042),
    creator: JeuneActionCreator(),
  );
}

PartageActivite mockPartageActivite({required bool favoriShared}) => PartageActivite(partageFavoris: favoriShared);

List<Commentaire> mockCommentaires() => [
      Commentaire(
        id: "8392839",
        content: "Premier commentaire",
        creationDate: parseDateTimeUtcWithCurrentTimeZone("2022-07-23T12:08:10.000"),
        createdByAdvisor: true,
        creatorName: "Nils Tavernier",
      ),
      Commentaire(
        id: "8802034",
        content: "Deuxieme commentaire",
        creationDate: parseDateTimeUtcWithCurrentTimeZone("2022-07-23T17:08:10.000"),
        createdByAdvisor: false,
        creatorName: null,
      )
    ];

List<Demarche> mockDemarches() {
  return [
    Demarche(
      id: "demarcheId",
      content: null,
      status: DemarcheStatus.NOT_STARTED,
      endDate: DateTime.now(),
      deletionDate: null,
      createdByAdvisor: true,
      label: null,
      possibleStatus: [],
      creationDate: DateTime.now(),
      modifiedByAdvisor: false,
      sousTitre: null,
      titre: null,
      modificationDate: null,
      attributs: [],
    )
  ];
}

SuggestionRecherche suggestionCariste() => SuggestionRecherche(
      id: "1",
      titre: "Cariste",
      type: OffreType.emploi,
      source: SuggestionSource.poleEmploi,
      metier: "Conduite d'engins de déplacement des charges",
      localisation: "Nord",
      dateCreation: parseDateTimeUtcWithCurrentTimeZone("2022-09-22T12:00:00.000Z"),
      dateRafraichissement: parseDateTimeUtcWithCurrentTimeZone("2022-09-26T13:00:00.000Z"),
    );

SuggestionRecherche suggestionBoulanger() => SuggestionRecherche(
      id: "2",
      titre: "Boulanger",
      type: OffreType.immersion,
      source: SuggestionSource.conseiller,
      metier: "Chef boulanger",
      localisation: "Valence",
      dateCreation: parseDateTimeUtcWithCurrentTimeZone("2022-10-12T22:00:00.000Z"),
      dateRafraichissement: parseDateTimeUtcWithCurrentTimeZone("2022-10-16T23:00:00.000Z"),
    );

SuggestionRecherche suggestionPlombier() => SuggestionRecherche(
      id: "3",
      titre: "Plombier",
      type: OffreType.immersion,
      source: null,
      metier: "Plombier",
      localisation: "Valence",
      dateCreation: parseDateTimeUtcWithCurrentTimeZone("2022-10-12T22:00:00.000Z"),
      dateRafraichissement: parseDateTimeUtcWithCurrentTimeZone("2022-10-16T23:00:00.000Z"),
    );

List<SuggestionRecherche> mockSuggestionsRecherche() => [suggestionCariste(), suggestionBoulanger()];

OffreEmploiSavedSearch offreEmploiSavedSearch() => OffreEmploiSavedSearch(
      id: "id",
      title: "Maître-chien / Maîtresse-chien d'avalanche",
      metier: "Sécurité civile et secours",
      location: Location(type: LocationType.DEPARTMENT, libelle: "Gironde", code: "33"),
      keyword: "Maître-chien / Maîtresse-chien d'avalanche",
      onlyAlternance: false,
      filters: EmploiFiltresRecherche.withFiltres(distance: 0),
    );

Metier mockMetier() => Metier(codeRome: "A1410", libelle: "Chevrier / Chevrière");

List<Metier> mockAutocompleteMetiers() {
  return [
    Metier(codeRome: "A1410", libelle: "Chevrier / Chevrière"),
    Metier(codeRome: "A1416", libelle: "Céréalier / Céréalière"),
    Metier(codeRome: "L1401", libelle: "Cavalier dresseur / Cavalière dresseuse de chevaux"),
  ];
}

SavedSearch mockOffreEmploiSavedSearch({String? keyword = 'keyword', Location? location}) => OffreEmploiSavedSearch(
      id: 'id',
      title: 'title',
      metier: 'metier',
      location: location,
      keyword: keyword,
      onlyAlternance: false,
      filters: EmploiFiltresRecherche.noFiltre(),
    );

SavedSearch mockImmersionSavedSearch({String metier = 'metier', String codeRome = 'codeRome'}) => ImmersionSavedSearch(
      id: 'id',
      title: 'title',
      metier: metier,
      codeRome: codeRome,
      filtres: ImmersionFiltresRecherche.noFiltre(),
      location: mockLocation(),
      ville: '',
    );

OffreEmploiSavedSearch rechercheEmploiSauvegardeeChevalierValenceCDI() => OffreEmploiSavedSearch(
      id: "recherche-recente-id",
      title: "chevalier - Valence",
      metier: null,
      keyword: "chevalier",
      location: Location(type: LocationType.COMMUNE, libelle: "Valence", code: "26000"),
      onlyAlternance: false,
      filters: EmploiFiltresRecherche.withFiltres(contrat: [ContratFiltre.cdi]),
    );

RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> rechercheEmploiChevalierValenceCDI() {
  return RechercheRequest(
    EmploiCriteresRecherche(
      keyword: "chevalier",
      location: Location(type: LocationType.COMMUNE, libelle: "Valence", code: "26000"),
      rechercheType: RechercheType.offreEmploiAndAlternance,
    ),
    EmploiFiltresRecherche.withFiltres(contrat: [ContratFiltre.cdi]),
    1,
  );
}

RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> initialRechercheEmploiRequest() {
  return RechercheRequest(
    EmploiCriteresRecherche(
      keyword: "chevalier",
      location: null,
      rechercheType: RechercheType.offreEmploiAndAlternance,
    ),
    EmploiFiltresRecherche.noFiltre(),
    1,
  );
}

RechercheRequest<ImmersionCriteresRecherche, ImmersionFiltresRecherche> initialRechercheImmersionRequest() {
  return RechercheRequest(
    ImmersionCriteresRecherche(location: mockLocation(), metier: mockMetier()),
    ImmersionFiltresRecherche.noFiltre(),
    1,
  );
}

RechercheRequest<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche>
    initialRechercheServiceCiviqueRequest() {
  return RechercheRequest(
    ServiceCiviqueCriteresRecherche(location: null),
    ServiceCiviqueFiltresRecherche.noFiltre(),
    1,
  );
}

RechercheRequest<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche>
    initialRechercheEvenementEmploiRequest() {
  return RechercheRequest(
    EvenementEmploiCriteresRecherche(location: mockLocation(), secteurActivite: null),
    EvenementEmploiFiltresRecherche.noFiltre(),
    1,
  );
}

RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> secondRechercheEmploiRequest() {
  return initialRechercheEmploiRequest().copyWith(page: 2);
}

RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> rechercheEmploiRequestWithZeroDistanceFiltre() {
  return initialRechercheEmploiRequest().copyWith(filtres: mockEmploiFiltreZeroDistance());
}

EmploiFiltresRecherche mockEmploiFiltreZeroDistance() => EmploiFiltresRecherche.withFiltres(distance: 0);

DiagorienteUrls mockDiagorienteUrls() {
  return DiagorienteUrls(
    chatBotUrl: 'chatBotUrl',
    metiersFavorisUrl: 'metiersFavorisUrl',
    metiersRecommandesUrl: 'metiersRecommandesUrl',
  );
}

Favori mockFavori([String id = 'id', OffreType type = OffreType.immersion]) {
  return Favori(id: id, type: type, titre: 't', organisation: null, localisation: null);
}

List<Favori> mock3Favoris() {
  return [
    Favori(
      id: "1",
      titre: "titre-1",
      type: OffreType.emploi,
      organisation: "organisation-1",
      localisation: "localisation-1",
    ),
    Favori(
      id: "2",
      titre: "titre-2",
      type: OffreType.alternance,
      organisation: "organisation-2",
      localisation: "localisation-2",
    ),
    Favori(
      id: "3",
      titre: "titre-3",
      type: OffreType.immersion,
      organisation: null,
      localisation: "localisation-3",
    ),
  ];
}

EvenementEmploiSavedSearch mockEvenementEmploiSavedSearch() {
  return EvenementEmploiSavedSearch(id: "id-117", titre: "Ermont", location: mockLocation());
}

List<SavedSearch> getMockedSavedSearch() {
  return [
    OffreEmploiSavedSearch(
      id: "9ea85cc4-c92f-4f91-b5a3-b600f364faf1",
      title: "Boulangerie",
      metier: "Boulangerie",
      location: null,
      keyword: "Boulangerie",
      onlyAlternance: false,
      filters: EmploiFiltresRecherche.withFiltres(
        distance: null,
        debutantOnly: true,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
    OffreEmploiSavedSearch(
      id: "25f317c7-f28a-4f50-a629-013bb960484d",
      title: "Boulangerie - NANTES",
      metier: "Boulangerie",
      location: Location(libelle: "NANTES", code: "44109", type: LocationType.COMMUNE),
      keyword: "Boulangerie",
      onlyAlternance: false,
      filters: EmploiFiltresRecherche.withFiltres(
        distance: null,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
    OffreEmploiSavedSearch(
      id: "6b51e128-000b-4125-a09a-c38a32a8b886",
      title: "Flutter",
      metier: "Flutter",
      location: null,
      keyword: "Flutter",
      onlyAlternance: true,
      filters: EmploiFiltresRecherche.withFiltres(
        distance: null,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
    ImmersionSavedSearch(
      id: "670c413e-b669-4228-850a-9a7307fe79ea",
      title: "Boulangerie - viennoiserie - PARIS-14",
      metier: "Boulangerie - viennoiserie",
      ville: "PARIS-14",
      codeRome: "D1102",
      location: Location(
        libelle: "PARIS-14",
        code: "",
        codePostal: null,
        latitude: 48.830108,
        longitude: 2.323026,
        type: LocationType.COMMUNE,
      ),
      filtres: ImmersionFiltresRecherche.noFiltre(),
    ),
  ];
}

Accueil mockAccueilMilo() {
  return Accueil(
    dateDerniereMiseAJour: parseDateTimeUtcWithCurrentTimeZone('2023-01-01T00:00:00.000Z'),
    cetteSemaine: AccueilCetteSemaine(
      nombreRendezVous: 3,
      nombreActionsDemarchesEnRetard: 2,
      nombreActionsDemarchesARealiser: 1,
    ),
    prochainRendezVous: mockRendezvousMiloCV(),
    evenements: [mockAnimationCollective()],
    alertes: getMockedSavedSearch(),
    favoris: mock3Favoris(),
  );
}

Accueil mockAccueilPoleEmploi() {
  return Accueil(
    dateDerniereMiseAJour: parseDateTimeUtcWithCurrentTimeZone('2023-01-01T00:00:00.000Z'),
    cetteSemaine: AccueilCetteSemaine(
      nombreRendezVous: 3,
      nombreActionsDemarchesEnRetard: 2,
      nombreActionsDemarchesARealiser: 1,
    ),
    prochainRendezVous: mockRendezvousPoleEmploi(),
    alertes: getMockedSavedSearch(),
    favoris: mock3Favoris(),
  );
}

CvPoleEmploi mockCvPoleEmploi() {
  return CvPoleEmploi(
    titre: "Pâtissier-2023",
    url: "https://pole-emploi/users/cv/id-user/patissier",
    nomFichier: "patissier-2023.pdf",
  );
}

List<CvPoleEmploi> mockCvPoleEmploiList() {
  return [
    mockCvPoleEmploi(),
    CvPoleEmploi(
      titre: "Boulanger-2023",
      url: "https://pole-emploi/users/cv/id-user/boulanger",
      nomFichier: "boulanger-2023.pdf",
    ),
  ];
}
