import 'package:http/http.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../utils/test_datetime.dart';

User mockUser({String id = ""}) => User(
      id: id,
      firstName: "",
      lastName: "",
      email: "",
      loginMode: LoginMode.MILO,
    );

LoginState successMiloUserState() => LoginSuccessState(User(
      id: "id",
      firstName: "F",
      lastName: "L",
      email: "first.last@milo.fr",
      loginMode: LoginMode.MILO,
    ));

LoginState successPoleEmploiUserState() => LoginSuccessState(User(
      id: "id",
      firstName: "F",
      lastName: "L",
      email: "first.last@pole-emploi.fr",
      loginMode: LoginMode.POLE_EMPLOI,
    ));

LoginState successPassEmploiUserState() => LoginSuccessState(User(
      id: "id",
      firstName: "F",
      lastName: "L",
      email: null,
      loginMode: LoginMode.PASS_EMPLOI,
    ));

AppState loggedInState() => AppState.initialState().copyWith(loginState: successMiloUserState());

Response invalidHttpResponse({String message = ""}) => Response(message, 500);

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

Configuration configuration({Flavor flavor = Flavor.STAGING}) => Configuration(
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

Location mockLocation({double? lat, double? lon}) => Location(
      libelle: "",
      code: "",
      type: LocationType.DEPARTMENT,
      latitude: lat,
      longitude: lon,
    );

Location mockCommuneLocation({String label = ""}) => Location(libelle: label, code: "", type: LocationType.COMMUNE);

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
