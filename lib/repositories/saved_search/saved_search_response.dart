import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';
import 'package:pass_emploi_app/network/filtres_request.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class SavedSearchResponse {
  final String id;
  final String titre;
  final String type;
  final String? metier;
  final String? locationLabel;
  final Location? location;
  final SavedSearchResponseCriteres criteres;

  SavedSearchResponse({
    required this.id,
    required this.titre,
    required this.type,
    this.metier,
    this.locationLabel,
    this.location,
    required this.criteres,
  });

  factory SavedSearchResponse.fromJson(dynamic json) {
    return SavedSearchResponse(
      id: json["id"] as String,
      titre: json["titre"] as String,
      type: json["type"] as String,
      metier: json["metier"] as String?,
      locationLabel: json["localisation"] as String?,
      location: json["realLocation"] != null ? Location.fromJson(json["realLocation"]) : null,
      criteres: SavedSearchResponseCriteres.fromJson(json["criteres"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "titre": titre,
      "type": type,
      "metier": metier,
      "localisation": locationLabel,
      if (location != null) "realLocation": location!.toJson(),
      "criteres": criteres.toJson(),
    };
  }
}

class SavedSearchResponseCriteres {
  final String? q;
  final String? departement;
  final bool? alternance;
  final bool? debutantAccepte;
  final List<String>? experience;
  final List<String>? contrat;
  final List<String>? duree;
  final String? commune;
  final int? rayon;
  final double? lon;
  final double? lat;
  final String? rome;
  final String? domaine;
  final int? distance;
  final String? dateDeDebutMinimum;

  SavedSearchResponseCriteres({
    this.q,
    this.departement,
    this.alternance,
    this.debutantAccepte,
    this.experience,
    this.contrat,
    this.duree,
    this.commune,
    this.rayon,
    this.lon,
    this.lat,
    this.rome,
    this.domaine,
    this.distance,
    this.dateDeDebutMinimum,
  });

  factory SavedSearchResponseCriteres.fromJson(dynamic json) {
    return SavedSearchResponseCriteres(
      q: json["q"] as String?,
      departement: json["departement"] as String?,
      alternance: json["alternance"] as bool?,
      debutantAccepte: json["debutantAccepte"] as bool?,
      experience: (json["experience"] as List?)?.map((e) => e as String).toList(),
      contrat: (json["contrat"] as List?)?.map((e) => e as String).toList(),
      duree: (json["duree"] as List?)?.map((e) => e as String).toList(),
      commune: json["commune"] as String?,
      rayon: (json["rayon"] as num?)?.toInt() ?? (json["distance"] as num?)?.toInt(),
      lat: (json["lat"] as num?)?.toDouble(),
      lon: (json["lon"] as num?)?.toDouble(),
      rome: json["rome"] as String?,
      domaine: json["domaine"] as String?,
      distance: (json["distance"] as num?)?.toInt(),
      dateDeDebutMinimum: json["dateDeDebutMinimum"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "q": q,
      "departement": departement,
      "alternance": alternance,
      "debutantAccepte": debutantAccepte,
      "experience": experience,
      "contrat": contrat,
      "duree": duree,
      "commune": commune,
      "rayon": rayon,
      "lat": lat,
      "lon": lon,
      "rome": rome,
      "domaine": domaine,
      "distance": distance,
      "dateDeDebutMinimum": dateDeDebutMinimum,
    };
  }
}

class SavedSearchEmploiExtractor {
  OffreEmploiSavedSearch extract(SavedSearchResponse savedSearch) {
    return OffreEmploiSavedSearch(
      id: savedSearch.id,
      title: savedSearch.titre,
      metier: savedSearch.metier,
      location: _getLocation(savedSearch),
      keyword: savedSearch.criteres.q,
      onlyAlternance: savedSearch.criteres.alternance ?? (savedSearch.type == "OFFRES_ALTERNANCE"),
      filters: _getFilters(savedSearch.criteres),
    );
  }

  Location? _getLocation(SavedSearchResponse savedSearch) {
    if (savedSearch.location != null) {
      return savedSearch.location;
    } else if (savedSearch.locationLabel != null) {
      final type = savedSearch.criteres.commune == null ? LocationType.DEPARTMENT : LocationType.COMMUNE;
      return Location(
        type: type,
        code: savedSearch.criteres.commune ?? savedSearch.criteres.departement!,
        libelle: savedSearch.locationLabel ?? "",
        codePostal: null,
        longitude: null,
        latitude: null,
      );
    } else {
      return null;
    }
  }

  EmploiFiltresRecherche _getFilters(SavedSearchResponseCriteres criteres) {
    return EmploiFiltresRecherche.withFiltres(
      distance: criteres.rayon,
      debutantOnly: criteres.debutantAccepte,
      experience: criteres.experience?.map((e) => FiltresRequest.experienceFromUrlParameter(e)).whereNotNull().toList(),
      contrat: criteres.contrat?.map((e) => FiltresRequest.contratFromUrlParameter(e)).whereNotNull().toList(),
      duree: criteres.duree?.map((e) => FiltresRequest.dureeFromUrlParameter(e)).whereNotNull().toList(),
    );
  }
}

class SavedSearchImmersionExtractor {
  ImmersionSavedSearch extract(SavedSearchResponse savedSearch) {
    return ImmersionSavedSearch(
      id: savedSearch.id,
      title: savedSearch.titre,
      metier: savedSearch.metier ?? "",
      location: _getLocation(savedSearch),
      filtres: _getFiltres(savedSearch.criteres),
      ville: savedSearch.locationLabel ?? "",
      codeRome: savedSearch.criteres.rome!,
    );
  }

  ImmersionFiltresRecherche _getFiltres(SavedSearchResponseCriteres criteres) {
    return ImmersionFiltresRecherche.distance(criteres.rayon);
  }

  Location _getLocation(SavedSearchResponse savedSearch) {
    if (savedSearch.location != null) {
      return savedSearch.location!;
    } else {
      return Location(
        type: LocationType.COMMUNE,
        code: savedSearch.criteres.commune ?? "",
        libelle: savedSearch.locationLabel ?? "",
        codePostal: null,
        longitude: savedSearch.criteres.lon,
        latitude: savedSearch.criteres.lat,
      );
    }
  }
}

class SavedSearchServiceCiviqueExtractor {
  ServiceCiviqueSavedSearch extract(SavedSearchResponse savedSearch) {
    return ServiceCiviqueSavedSearch(
      id: savedSearch.id,
      titre: savedSearch.titre,
      domaine: Domaine.fromTag(savedSearch.criteres.domaine),
      ville: savedSearch.locationLabel,
      filtres: ServiceCiviqueFiltresParameters.distance(savedSearch.criteres.distance),
      dateDeDebut: savedSearch.criteres.dateDeDebutMinimum?.toDateTimeUtcOnLocalTimeZone(),
      location: _getLocation(savedSearch),
    );
  }

  Location? _getLocation(SavedSearchResponse savedSearch) {
    if (savedSearch.location != null) {
      return savedSearch.location!;
    } else if (savedSearch.locationLabel != null) {
      return Location(
        type: LocationType.COMMUNE,
        code: savedSearch.locationLabel!,
        libelle: savedSearch.locationLabel ?? "",
        codePostal: null,
        longitude: savedSearch.criteres.lon,
        latitude: savedSearch.criteres.lat,
      );
    } else {
      return null;
    }
  }
}

extension OffreEmploiSavedSearchExt on OffreEmploiSavedSearch {
  SavedSearchResponse toSavedSearchResponse() {
    return SavedSearchResponse(
      id: id,
      titre: title,
      metier: metier,
      locationLabel: location?.libelle,
      location: location,
      type: onlyAlternance ? "OFFRES_ALTERNANCE" : "OFFRES_EMPLOI",
      criteres: SavedSearchResponseCriteres(
        q: keyword,
        departement: location?.type == LocationType.DEPARTMENT ? location!.code : null,
        alternance: onlyAlternance,
        debutantAccepte: filters.debutantOnly,
        experience: filters.experience?.map((e) => FiltresRequest.experienceToUrlParameter(e)).toList(),
        contrat: filters.contrat?.map((e) => FiltresRequest.contratToUrlParameter(e)).toList(),
        duree: filters.duree?.map((e) => FiltresRequest.dureeToUrlParameter(e)).toList(),
        commune: location?.type == LocationType.COMMUNE ? location!.code : null,
        rayon: filters.distance,
        lat: location?.latitude,
        lon: location?.longitude,
        rome: null,
        domaine: null,
        distance: null,
        dateDeDebutMinimum: null,
      ),
    );
  }
}

extension ImmersionSavedSearchExt on ImmersionSavedSearch {
  SavedSearchResponse toSavedSearchResponse() {
    return SavedSearchResponse(
      id: id,
      titre: title,
      metier: metier,
      locationLabel: location.libelle,
      location: location,
      type: "OFFRES_IMMERSION",
      criteres: SavedSearchResponseCriteres(
        q: null,
        departement: location.type == LocationType.DEPARTMENT ? location.code : null,
        alternance: null,
        debutantAccepte: null,
        experience: null,
        contrat: null,
        duree: null,
        commune: location.type == LocationType.COMMUNE ? location.code : null,
        rayon: null,
        lat: location.latitude,
        lon: location.longitude,
        rome: codeRome,
        domaine: null,
        distance: filtres.distance,
        dateDeDebutMinimum: null,
      ),
    );
  }
}

extension ServiceCiviqueSavedSearchExt on ServiceCiviqueSavedSearch {
  SavedSearchResponse toSavedSearchResponse() {
    return SavedSearchResponse(
      id: id,
      titre: titre,
      metier: null,
      locationLabel: ville,
      location: location,
      type: "OFFRES_SERVICES_CIVIQUE",
      criteres: SavedSearchResponseCriteres(
        q: null,
        departement: null,
        alternance: null,
        debutantAccepte: null,
        experience: null,
        contrat: null,
        duree: null,
        commune: null,
        rayon: null,
        lat: location?.latitude,
        lon: location?.longitude,
        rome: null,
        domaine: domaine?.tag,
        distance: filtres.distance,
        dateDeDebutMinimum: dateDeDebut?.toIso8601String(),
      ),
    );
  }
}
