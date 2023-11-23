import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/models/alerte/evenement_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';
import 'package:pass_emploi_app/network/filtres_request.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class AlerteResponse {
  final String id;
  final String titre;
  final String type;
  final String? metier;
  final String? locationLabel;
  final Location? location;
  final AlerteResponseCriteres criteres;

  AlerteResponse({
    required this.id,
    required this.titre,
    required this.type,
    this.metier,
    this.locationLabel,
    this.location,
    required this.criteres,
  });

  factory AlerteResponse.fromJson(dynamic json) {
    return AlerteResponse(
      id: json["id"] as String,
      titre: json["titre"] as String,
      type: json["type"] as String,
      metier: json["metier"] as String?,
      locationLabel: json["localisation"] as String?,
      location: json["realLocation"] != null ? Location.fromJson(json["realLocation"]) : null,
      criteres: AlerteResponseCriteres.fromJson(json["criteres"]),
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

class AlerteResponseCriteres {
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

  AlerteResponseCriteres({
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

  factory AlerteResponseCriteres.fromJson(dynamic json) {
    return AlerteResponseCriteres(
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

class AlerteEmploiExtractor {
  OffreEmploiAlerte extract(AlerteResponse alerte) {
    return OffreEmploiAlerte(
      id: alerte.id,
      title: alerte.titre,
      metier: alerte.metier,
      location: _getLocation(alerte),
      keyword: alerte.criteres.q,
      onlyAlternance: alerte.criteres.alternance ?? (alerte.type == "OFFRES_ALTERNANCE"),
      filters: _getFilters(alerte.criteres),
    );
  }

  Location? _getLocation(AlerteResponse alerte) {
    if (alerte.location != null) {
      return alerte.location;
    } else if (alerte.locationLabel != null) {
      final type = alerte.criteres.commune == null ? LocationType.DEPARTMENT : LocationType.COMMUNE;
      return Location(
        type: type,
        code: alerte.criteres.commune ?? alerte.criteres.departement!,
        libelle: alerte.locationLabel ?? "",
        codePostal: null,
        longitude: null,
        latitude: null,
      );
    } else {
      return null;
    }
  }

  EmploiFiltresRecherche _getFilters(AlerteResponseCriteres criteres) {
    return EmploiFiltresRecherche.withFiltres(
      distance: criteres.rayon,
      debutantOnly: criteres.debutantAccepte,
      experience: criteres.experience?.map((e) => FiltresRequest.experienceFromUrlParameter(e)).whereNotNull().toList(),
      contrat: criteres.contrat?.map((e) => FiltresRequest.contratFromUrlParameter(e)).whereNotNull().toList(),
      duree: criteres.duree?.map((e) => FiltresRequest.dureeFromUrlParameter(e)).whereNotNull().toList(),
    );
  }
}

class AlerteImmersionExtractor {
  ImmersionAlerte extract(AlerteResponse alerte) {
    return ImmersionAlerte(
      id: alerte.id,
      title: alerte.titre,
      metier: alerte.metier ?? "",
      location: _getLocation(alerte),
      filtres: _getFiltres(alerte.criteres),
      ville: alerte.locationLabel ?? "",
      codeRome: alerte.criteres.rome!,
    );
  }

  ImmersionFiltresRecherche _getFiltres(AlerteResponseCriteres criteres) {
    return ImmersionFiltresRecherche.distance(criteres.rayon);
  }

  Location _getLocation(AlerteResponse alerte) {
    if (alerte.location != null) {
      return alerte.location!;
    } else {
      return Location(
        type: LocationType.COMMUNE,
        code: alerte.criteres.commune ?? "",
        libelle: alerte.locationLabel ?? "",
        codePostal: null,
        longitude: alerte.criteres.lon,
        latitude: alerte.criteres.lat,
      );
    }
  }
}

class AlerteServiceCiviqueExtractor {
  ServiceCiviqueAlerte extract(AlerteResponse alerte) {
    return ServiceCiviqueAlerte(
      id: alerte.id,
      titre: alerte.titre,
      domaine: Domaine.fromTag(alerte.criteres.domaine),
      ville: alerte.locationLabel,
      filtres: ServiceCiviqueFiltresParameters.distance(alerte.criteres.distance),
      dateDeDebut: alerte.criteres.dateDeDebutMinimum?.toDateTimeUtcOnLocalTimeZone(),
      location: _getLocation(alerte),
    );
  }

  Location? _getLocation(AlerteResponse alerte) {
    if (alerte.location != null) {
      return alerte.location!;
    } else if (alerte.locationLabel != null) {
      return Location(
        type: LocationType.COMMUNE,
        code: alerte.locationLabel!,
        libelle: alerte.locationLabel ?? "",
        codePostal: null,
        longitude: alerte.criteres.lon,
        latitude: alerte.criteres.lat,
      );
    } else {
      return null;
    }
  }
}

class AlerteEvenementEmploiExtractor {
  EvenementEmploiAlerte extract(AlerteResponse alerte) {
    return EvenementEmploiAlerte(
      id: alerte.id,
      titre: alerte.titre,
      location: _getLocation(alerte),
    );
  }

  Location _getLocation(AlerteResponse alerte) {
    if (alerte.location != null) {
      return alerte.location!;
    } else {
      return Location(
        type: LocationType.COMMUNE,
        code: alerte.criteres.commune ?? "",
        libelle: alerte.locationLabel ?? "",
        codePostal: null,
        longitude: alerte.criteres.lon,
        latitude: alerte.criteres.lat,
      );
    }
  }
}

extension OffreEmploiAlerteExt on OffreEmploiAlerte {
  AlerteResponse toAlerteResponse() {
    return AlerteResponse(
      id: id,
      titre: title,
      metier: metier,
      locationLabel: location?.libelle,
      location: location,
      type: onlyAlternance ? "OFFRES_ALTERNANCE" : "OFFRES_EMPLOI",
      criteres: AlerteResponseCriteres(
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

extension ImmersionAlerteExt on ImmersionAlerte {
  AlerteResponse toAlerteResponse() {
    return AlerteResponse(
      id: id,
      titre: title,
      metier: metier,
      locationLabel: location.libelle,
      location: location,
      type: "OFFRES_IMMERSION",
      criteres: AlerteResponseCriteres(
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

extension ServiceCiviqueAlerteExt on ServiceCiviqueAlerte {
  AlerteResponse toAlerteResponse() {
    return AlerteResponse(
      id: id,
      titre: titre,
      metier: null,
      locationLabel: ville,
      location: location,
      type: "OFFRES_SERVICES_CIVIQUE",
      criteres: AlerteResponseCriteres(
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

extension AlerteEvenementEmploiExtractorExt on EvenementEmploiAlerte {
  AlerteResponse toAlerteResponse() {
    return AlerteResponse(
      id: id,
      titre: titre,
      locationLabel: location.libelle,
      location: location,
      type: "EVENEMENT_EMPLOI",
      criteres: AlerteResponseCriteres(
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
        rome: null,
        domaine: null,
        distance: null,
        dateDeDebutMinimum: null,
      ),
    );
  }
}
