import 'package:clock/clock.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/partage_activite.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/models/version.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';

import '../utils/test_datetime.dart';

User mockUser({String id = "", LoginMode loginMode = LoginMode.MILO}) => User(
      id: id,
      firstName: "",
      lastName: "",
      email: "",
      loginMode: loginMode,
    );

LoginState successMiloUserState() => LoginSuccessState(mockedMiloUser());

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
    );

OffreEmploi mockOffreEmploi({String id = "123DXPM", bool isAlternance = false}) => OffreEmploi(
      id: id,
      title: "Technicien / Technicienne en froid et climatisation",
      companyName: "RH TT INTERIM",
      contractType: "MIS",
      isAlternance: isAlternance,
      location: "77 - LOGNES",
      duration: "Temps plein",
    );

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

Configuration configuration({Version version = const Version(1, 0, 0), Flavor flavor = Flavor.STAGING}) {
  return Configuration(
    version,
    flavor,
    'serverBaseUrl',
    'matomoBaseUrl',
    'matomoSiteId',
    'authClientId',
    'authLoginRedirectUrl',
    'authLogoutRedirectUrl',
    'authIssuer',
    ['scope1', 'scope2', 'scope3'],
    'authClientSecret',
    'someKey',
  );
}

Location mockLocation({double? lat, double? lon}) => Location(
      libelle: "",
      code: "",
      type: LocationType.DEPARTMENT,
      latitude: lat,
      longitude: lon,
    );

Location mockCommuneLocation({double? lat, double? lon, String label = ""}) => Location(
      libelle: label,
      code: "",
      type: LocationType.COMMUNE,
      latitude: lat,
      longitude: lon,
    );

Immersion mockImmersion({String id = ""}) {
  return Immersion(id: id, metier: "", nomEtablissement: "", secteurActivite: "", ville: "");
}

ServiceCivique mockServiceCivique({String id = "123DXPM"}) => ServiceCivique(
      id: id,
      startDate: '17/02/2022',
      title: "Technicien / Technicienne en froid et climatisation",
      companyName: "RH TT INTERIM",
      domain: 'Informatique',
      location: "77 - LOGNES",
    );

SearchServiceCiviqueRequest mockServiceCiviqueRequest({String id = "123DXPM"}) => SearchServiceCiviqueRequest(
      location: mockLocation(),
      endDate: '17/05/2022',
      page: 1,
      distance: null,
      startDate: '17/02/2022',
      domain: 'Informatique',
    );

ServiceCiviqueDetail mockServiceCiviqueDetail() => ServiceCiviqueDetail(
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

Rendezvous rendezvousStub({String? id, DateTime? date}) {
  return Rendezvous(
    id: id ?? "id-1",
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
  bool isInVisio = false,
  bool isAnnule = false,
  RendezvousType type = const RendezvousType(RendezvousTypeCode.AUTRE, ''),
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
    date: date ?? DateTime.now(),
    duration: duration,
    modality: modality,
    isInVisio: isInVisio,
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
    attributs: [],
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
  return [Demarche(
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
  )];
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
