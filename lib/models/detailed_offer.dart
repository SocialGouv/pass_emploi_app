import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class DetailedOffer extends Equatable {
  final String id;
  final String title;
  final String? offerDescription;
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

  DetailedOffer({
    required this.id,
    required this.title,
    required this.offerDescription,
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

  factory DetailedOffer.fromJson(dynamic json) {
    List<Education>? educations = (json.containsKey("formations"))
        ? List<Education>.from(json["formations"]?.map((data) => Education.fromJson(data)).whereType<Education>())
        : [];
    print("educations passed.");

    List<Language>? languages = (json.containsKey("langues"))
        ? List<Language>.from(json["langues"]?.map((data) => Language.fromJson(data)).whereType<Language>())
        : [];
    print("languages passed.");

    List<DriverLicence>? driverlicences = (json.containsKey("permis"))
        ? List<DriverLicence>.from(
            json["permis"]?.map((data) => DriverLicence.fromJson(data)).whereType<DriverLicence>())
        : [];
    print("licences passed.");

    List<Skill>? skills = (json.containsKey("competences"))
        ? List<Skill>.from(json["competences"]?.map((data) => Skill.fromJson(data)).whereType<Skill>())
        : [];
    print("skills passed.");

    List<SoftSkill>? softSkills = (json.containsKey("qualitesProfessionnelles"))
        ? List<SoftSkill>.from(json["qualitesProfessionnelles"]?.map((data) => SoftSkill.fromJson(data)))
        : [];
    print("soft skills passed.");

    DetailedOffer test = DetailedOffer(
      id: json["id"] as String,
      title: json["intitule"] as String,
      offerDescription: json["description"] as String?,
      contractType: json["typeContratLibelle"] as String?,
      duration: json["dureeTravailLibelle"] as String?,
      location: json["lieuTravail"]?["libelle"] as String?,
      salary: json["salaire"]?["libelle"] as String?,
      companyName: json["entreprise"]?["nom"] as String?,
      companyDescription: json["entreprise"]?["description"] as String?,
      companyUrl: json["entreprise"]?["url"] as String?,
      experience: json["experienceLibelle"] as String?,
      requiredExperience: json["experienceExige"] as String?,
      educations: educations,
      languages: languages,
      driverLicences: driverlicences,
      lastUpdate: (json["dateActualisation"] is String)
          ? (json["dateActualisation"] as String).toDateTimeFromPoleEmploi()
          : null,
      skills: skills,
      softSkills: softSkills.map((soft) => soft.description).whereType<String>().toList(),
      companyAdapted: json["entreprise"]?["entrepriseAdaptee"] as bool,
      companyAccessibility: json["accessibleTH"] as bool,
    );
    print("contructor passed.");
    return test;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        offerDescription,
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
      description: json['libelle'],
      requirement: json['exigence'],
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

  factory SoftSkill.fromJson(Map<String, dynamic> json) => SoftSkill(
        description: json['libelle'],
      );

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
      category: json['libelle'],
      requirement: json['exigence'],
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
      type: json['libelle'],
      requirement: json['exigence'],
    );
  }

  @override
  List<Object?> get props => [type, requirement];
}
