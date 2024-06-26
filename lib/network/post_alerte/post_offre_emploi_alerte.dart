import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/network/filtres_request.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';

class PostOffreEmploiAlerte implements JsonSerializable {
  final String title;
  final String? metier;
  final Location? localisation;
  final String? keywords;
  final bool isAlternance;
  final List<ExperienceFiltre>? experience;
  final bool? debutantOnly;
  final List<ContratFiltre>? contrat;
  final List<DureeFiltre>? duration;
  final int? rayon;

  PostOffreEmploiAlerte({
    required this.title,
    required this.metier,
    required this.localisation,
    required this.keywords,
    required this.isAlternance,
    required this.debutantOnly,
    required this.experience,
    required this.contrat,
    required this.duration,
    required this.rayon,
  });

  @override
  Map<String, dynamic> toJson() => {
        "titre": title,
        "metier": metier,
        "localisation": localisation?.libelle,
        "criteres": {
          if (keywords != null && keywords!.isNotEmpty) "q": keywords,
          "departement": getLocationType(localisation, LocationType.DEPARTMENT),
          "alternance": isAlternance,
          "debutantAccepte": debutantOnly,
          "experience": getExperience(experience),
          "contrat": getContrat(contrat),
          "duree": getDuration(duration),
          "commune": getLocationType(localisation, LocationType.COMMUNE),
          "rayon": rayon
        }
      };
}

String? getLocationType(Location? location, LocationType type) =>
    (location != null && location.type == type) ? location.code : null;

List<String> getExperience(List<ExperienceFiltre>? experience) {
  final List<String> list = [];
  if (experience != null && experience.isNotEmpty) {
    for (var element in experience) {
      list.add(FiltresRequest.experienceToUrlParameter(element));
    }
  }
  return list;
}

List<String> getContrat(List<ContratFiltre>? contrat) {
  final List<String> list = [];
  if (contrat != null && contrat.isNotEmpty) {
    for (var element in contrat) {
      list.add(FiltresRequest.contratToUrlParameter(element));
    }
  }
  return list;
}

List<String> getDuration(List<DureeFiltre>? duration) {
  final List<String> list = [];
  if (duration != null && duration.isNotEmpty) {
    for (var element in duration) {
      list.add(FiltresRequest.dureeToUrlParameter(element));
    }
  }
  return list;
}