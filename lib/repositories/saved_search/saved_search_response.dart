import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/network/filtres_request.dart';

import '../../models/offre_emploi_filtres_parameters.dart';
import '../../models/saved_search/immersion_saved_search.dart';

class SavedSearchResponse {
  final String id;
  final String titre;
  final String type;
  final String? metier;
  final String? localisation;
  final SavedSearchResponseCriteres criteres;

  SavedSearchResponse({
    required this.id,
    required this.titre,
    required this.type,
    this.metier,
    this.localisation,
    required this.criteres,
  });

  factory SavedSearchResponse.fromJson(dynamic json) {
    return SavedSearchResponse(
      id: json["id"] as String,
      titre: json["titre"] as String,
      type: json["type"] as String,
      metier: json["metier"] as String?,
      localisation: json["localisation"] as String?,
      criteres: SavedSearchResponseCriteres.fromJson(json["criteres"]),
    );
  }
}

class SavedSearchResponseCriteres {
  final String? q;
  final String? departement;
  final bool? alternance;
  final List<String>? experience;
  final List<String>? contrat;
  final List<String>? duree;
  final String? commune;
  final int? rayon;
  final double? lon;
  final double? lat;
  final String? rome;

  SavedSearchResponseCriteres(
      {this.q,
      this.departement,
      this.alternance,
      this.experience,
      this.contrat,
      this.duree,
      this.commune,
      this.rayon,
      this.lon,
      this.lat,
      this.rome});

  factory SavedSearchResponseCriteres.fromJson(dynamic json) {
    return SavedSearchResponseCriteres(
      q: json["q"] as String?,
      departement: json["departement"] as String?,
      alternance: json["alternance"] as bool?,
      experience: (json["experience"] as List?)?.map((e) => e as String).toList(),
      contrat: (json["contrat"] as List?)?.map((e) => e as String).toList(),
      duree: (json["duree"] as List?)?.map((e) => e as String).toList(),
      commune: json["commune"] as String?,
      rayon: json["rayon"] as int?,
      lat: json["lat"] as double?,
      lon: json["lon"] as double?,
      rome: json["rome"] as String?,
    );
  }
}

class SavedSearchEmploiExtractor {
  OffreEmploiSavedSearch extract(SavedSearchResponse savedSearch) {
    return OffreEmploiSavedSearch(
      title: savedSearch.titre,
      metier: savedSearch.metier,
      location: _getLocation(savedSearch),
      keywords: savedSearch.criteres.q,
      isAlternance: savedSearch.criteres.alternance!,
      filters: _getFilters(savedSearch.criteres),
    );
  }

  Location? _getLocation(SavedSearchResponse savedSearch) {
    if (savedSearch.localisation != null) {
      final type = savedSearch.criteres.commune == null ? LocationType.DEPARTMENT : LocationType.COMMUNE;
      return Location(
        type: type,
        code: savedSearch.criteres.commune ?? savedSearch.criteres.departement!,
        libelle: savedSearch.localisation ?? "",
        codePostal: null,
        longitude: null,
        latitude: null,
      );
    } else {
      return null;
    }
  }

  OffreEmploiSearchParametersFiltres _getFilters(SavedSearchResponseCriteres criteres) {
    return OffreEmploiSearchParametersFiltres.withFiltres(
      distance: criteres.rayon,
      experience: criteres.experience?.map((e) => FiltresRequest.experienceFromUrlParameter(e)).toList(),
      contrat: criteres.contrat?.map((e) => FiltresRequest.contratFromUrlParameter(e)).toList(),
      duree: criteres.duree?.map((e) => FiltresRequest.dureeFromUrlParameter(e)).toList(),
    );
  }
}

class SavedSearchImmersionExtractor {
  ImmersionSavedSearch extract(SavedSearchResponse savedSearch) {
    return ImmersionSavedSearch(
      title: savedSearch.titre,
      metier: savedSearch.metier ?? "",
      location: savedSearch.localisation ?? "",
      filters: _getFilters(savedSearch.criteres),
    );
  }

  ImmersionSearchParametersFilters _getFilters(SavedSearchResponseCriteres criteres) {
    return ImmersionSearchParametersFilters.withFilters(
      codeRome: criteres.rome,
      lat: criteres.lat,
      lon: criteres.lon,
    );
  }
}
