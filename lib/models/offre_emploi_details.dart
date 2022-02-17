import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class OffreEmploiDetails extends Equatable {
  final String id;
  final String title;
  final String urlRedirectPourPostulation;
  final String? description;
  final String? contractType;
  final String? duration;
  final String? location;
  final String? salary;
  final String? companyName;
  final String? companyDescription;
  final String? companyUrl;
  final bool companyAdapted;
  final bool companyAccessibility;
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
    required this.requiredExperience,
  });

  factory OffreEmploiDetails.fromJson(dynamic json, String urlRedirectPourPostulation) {
    return OffreEmploiDetails(
      id: json["id"] as String,
      title: json["intitule"] as String,
      urlRedirectPourPostulation: urlRedirectPourPostulation,
      description: json["description"] as String?,
      contractType: json["typeContratLibelle"] as String?,
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
      companyAdapted: json["entreprise"]?["entrepriseAdaptee"] as bool,
      companyAccessibility: json["accessibleTH"] as bool,
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
        driverLicences
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

List<Education> _extractEducations(json) {
  return (json.containsKey("formations"))
      ? List<Education>.from(json["formations"]?.map((data) => Education.fromJson(data)).whereType<Education>())
      : [];
}

List<SoftSkill> _extractSoftSkills(json) {
  return (json.containsKey("qualitesProfessionnelles"))
      ? List<SoftSkill>.from(json["qualitesProfessionnelles"]?.map((data) => SoftSkill.fromJson(data)))
      : [];
}

List<Skill> _extractSkills(json) {
  return (json.containsKey("competences"))
      ? List<Skill>.from(json["competences"]?.map((data) => Skill.fromJson(data)).whereType<Skill>())
      : [];
}

List<DriverLicence> _extractDriverLicences(json) {
  return (json.containsKey("permis"))
      ? List<DriverLicence>.from(json["permis"]?.map((data) => DriverLicence.fromJson(data)).whereType<DriverLicence>())
      : [];
}

List<Language> _extractLanguages(json) {
  return (json.containsKey("langues"))
      ? List<Language>.from(json["langues"]?.map((data) => Language.fromJson(data)).whereType<Language>())
      : [];
}

DateTime? _extractLastUpdate(json) {
  return (json["dateActualisation"] is String)
      ? (json["dateActualisation"] as String).toDateTimeUtcOnLocalTimeZone()
      : null;
}
