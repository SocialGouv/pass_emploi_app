import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class OffreEmploiDetails extends Equatable {
  final String id;
  final String title;
  final String urlRedirectPourPostulation;
  final String? description;
  final String contractType;
  final String? duration;
  final String? location;
  final String? salary;
  final String? companyName;
  final String? companyDescription;
  final String? companyUrl;
  final bool? companyAdapted;
  final bool companyAccessibility;
  final bool isAlternance;
  final String? experience;
  final String? requiredExperience;
  final DateTime? lastUpdate;
  final List<Education>? educations;
  final List<Language>? languages;
  final List<Skill>? skills;
  final List<String>? softSkills;
  final List<DriverLicence>? driverLicences;

  OffreEmploiDetails({
    required this.id,
    required this.title,
    required this.urlRedirectPourPostulation,
    required this.description,
    required this.contractType,
    required this.duration,
    required this.location,
    required this.salary,
    required this.companyName,
    required this.companyDescription,
    required this.companyUrl,
    required this.experience,
    required this.educations,
    required this.languages,
    required this.driverLicences,
    required this.lastUpdate,
    required this.skills,
    required this.softSkills,
    required this.companyAdapted,
    required this.companyAccessibility,
    required this.isAlternance,
    required this.requiredExperience,
  });

  factory OffreEmploiDetails.fromJson(Map<String, dynamic> json, String urlRedirectPourPostulation) {
    return OffreEmploiDetails(
      id: json["id"] as String,
      title: json["intitule"] as String,
      urlRedirectPourPostulation: urlRedirectPourPostulation,
      description: json["description"] as String?,
      contractType: json["typeContratLibelle"] as String,
      duration: json["dureeTravailLibelle"] as String?,
      location: json["lieuTravail"]?["libelle"] as String?,
      salary: json["salaire"]?["libelle"] as String?,
      companyName: json["entreprise"]?["nom"] as String?,
      companyDescription: json["entreprise"]?["description"] as String?,
      companyUrl: json["entreprise"]?["url"] as String?,
      experience: json["experienceLibelle"] as String?,
      requiredExperience: json["experienceExige"] as String?,
      educations: _extractEducations(json),
      languages: _extractLanguages(json),
      driverLicences: _extractDriverLicences(json),
      lastUpdate: _extractLastUpdate(json),
      skills: _extractSkills(json),
      softSkills: _extractSoftSkills(json).map((soft) => soft.description).whereType<String>().toList(),
      companyAdapted: json["entreprise"]?["entrepriseAdaptee"] as bool?,
      companyAccessibility: json["accessibleTH"] as bool,
      isAlternance: json["alternance"] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        urlRedirectPourPostulation,
        description,
        contractType,
        duration,
        location,
        salary,
        companyName,
        companyDescription,
        companyUrl,
        companyAdapted,
        companyAccessibility,
        experience,
        requiredExperience,
        lastUpdate,
        educations,
        languages,
        skills,
        softSkills,
        driverLicences,
      ];
}

class Skill extends Equatable {
  final String description;
  final String? requirement;

  Skill({required this.description, required this.requirement});

  static Skill? fromJson(Map<String, dynamic> json) {
    if (json['libelle'] == null) return null;
    return Skill(
      description: json['libelle'] as String,
      requirement: json['exigence'] as String,
    );
  }

  @override
  List<Object?> get props => [description, requirement];
}

class SoftSkill extends Equatable {
  final String? description;

  SoftSkill({
    required this.description,
  });

  factory SoftSkill.fromJson(Map<String, dynamic> json) => SoftSkill(description: json['libelle'] as String?);

  @override
  List<Object?> get props => [description];
}

class DriverLicence extends Equatable {
  final String category;
  final String? requirement;

  DriverLicence({required this.category, required this.requirement});

  static DriverLicence? fromJson(Map<String, dynamic> json) {
    if (json['libelle'] == null) return null;
    return DriverLicence(
      category: json['libelle'] as String,
      requirement: json['exigence'] as String?,
    );
  }

  @override
  List<Object?> get props => [category, requirement];
}

class Education extends Equatable {
  final String level;
  final String? field;
  final String? requirement;

  Education({
    required this.level,
    required this.field,
    required this.requirement,
  });

  static Education? fromJson(Map<String, dynamic> json) {
    if (json['niveauLibelle'] == null) return null;
    return Education(
      level: json['niveauLibelle'] as String,
      field: json['domaineLibelle'] as String?,
      requirement: json['exigence'] as String?,
    );
  }

  @override
  List<Object?> get props => [level, field, requirement];
}

class Language extends Equatable {
  final String type;
  final String? requirement;

  Language({required this.type, required this.requirement});

  static Language? fromJson(Map<String, dynamic> json) {
    if (json['libelle'] == null) return null;
    return Language(
      type: json['libelle'] as String,
      requirement: json['exigence'] as String?,
    );
  }

  @override
  List<Object?> get props => [type, requirement];
}

List<Education> _extractEducations(Map<String, dynamic> json) {
  if (json.containsKey("formations")) {
    final formations = json["formations"] as List;
    return formations.map((e) => Education.fromJson(e as Map<String, dynamic>)).whereType<Education>().toList();
  } else {
    return [];
  }
}

List<SoftSkill> _extractSoftSkills(Map<String, dynamic> json) {
  if (json.containsKey("qualitesProfessionnelles")) {
    final softSkills = json["qualitesProfessionnelles"] as List;
    return softSkills.map((e) => SoftSkill.fromJson(e as Map<String, dynamic>)).toList();
  } else {
    return [];
  }
}

List<Skill> _extractSkills(Map<String, dynamic> json) {
  if (json.containsKey("competences")) {
    final skills = json["competences"] as List;
    return skills.map((e) => Skill.fromJson(e as Map<String, dynamic>)).whereType<Skill>().toList();
  } else {
    return [];
  }
}

List<DriverLicence> _extractDriverLicences(Map<String, dynamic> json) {
  if (json.containsKey("permis")) {
    final licences = json["permis"] as List;
    return licences.map((e) => DriverLicence.fromJson(e as Map<String, dynamic>)).whereType<DriverLicence>().toList();
  } else {
    return [];
  }
}

List<Language> _extractLanguages(Map<String, dynamic> json) {
  if (json.containsKey("langues")) {
    final languages = json["langues"] as List;
    return languages.map((e) => Language.fromJson(e as Map<String, dynamic>)).whereType<Language>().toList();
  } else {
    return [];
  }
}

DateTime? _extractLastUpdate(Map<String, dynamic> json) {
  return (json["dateActualisation"] is String)
      ? (json["dateActualisation"] as String).toDateTimeUtcOnLocalTimeZone()
      : null;
}

extension OffreEmploiDetailsExt on OffreEmploiDetails {
  OffreEmploi get toOffreEmploi => OffreEmploi(
        id: id,
        title: title,
        companyName: companyName,
        contractType: contractType,
        isAlternance: isAlternance,
        location: location,
        duration: duration,
      );
}
