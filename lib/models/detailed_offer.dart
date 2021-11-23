import 'package:equatable/equatable.dart';

class DetailedOffer extends Equatable {
  final String  id;
  final String  title;
  final String? offerDescription;
  final String? contractType;
  final String? duration;
  final String? location;
  final String? salary;
  final String? companyName;
  final String? companyDescription;
  final String? companyUrl;
  final bool    companyAdapted;
  final bool    companyAccessibility;
  final String? experience;
  final String? requiredExperience;
  final String? lastUpdate;
  final Education? education;
  final List<Language?>? language;
  final List<Skill?>? skills;
  final List<SoftSkill?>? softSkills;
  final List<DriverLicence?>? driverLicence;

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
    required this.education,
    required this.language,
    required this.driverLicence,
    required this.lastUpdate,
    required this.skills,
    required this.softSkills,
    required this.companyAdapted,
    required this.companyAccessibility,
    required this.requiredExperience,
  });


  factory DetailedOffer.fromJson(dynamic json) {
    return DetailedOffer(
      id:                   json["id"] as String,
      title:                json["intitule"] as String,
      offerDescription:     json["description"] as String?,
      contractType:         json["typeContratLibelle"] as String?,
      duration:             json["dureeTravailLibelle"] as String?,
      location:             json["lieuTravail"]?["libelle"] as String?,
      salary:               json["salaire"]?["libelle"] as String?,
      companyName:          json["entreprise"]?["nom"] as String?,
      companyDescription:   json["entreprise"]?["description"] as String?,
      companyUrl:           json["entreprise"]?["url"] as String?,
      experience:           json["experienceLibelle"] as String?,
      requiredExperience:   json["experienceExige"] as String?,
      education:            (json.containsKey("formations")) ?
                            Education.fromJson(json["formations"]) : null,
      language:             (json.containsKey("langues")) ?
                            List<Language?>.from(json["langues"]?.map((data) => Language.fromJson(data))) : [],
      driverLicence:        (json.containsKey("permis")) ?
                            List<DriverLicence?>.from(json["permis"]?.map((data) => DriverLicence.fromJson(data))) : [],
      lastUpdate:           json["dateActualisation"] as String?,
      skills:               (json.containsKey("competences")) ?
                            List<Skill?>.from(json["competences"]?.map((data) => Skill.fromJson(data))) : [],
      softSkills:           (json.containsKey("qualitesProfessionnelles")) ?
                            List<SoftSkill?>.from(json["qualitesProfessionnelles"]?.map((data) =>
                                SoftSkill.fromJson(data)))  : [],
      companyAdapted:       json["entreprise"]?["entrepriseAdaptee"] as bool,
      companyAccessibility: json["accessibleTH"] as bool,
    );
  }

  @override
  List<Object?> get props => [
    id, title, offerDescription, contractType, duration, location, salary,
    companyName, companyDescription, companyUrl, companyAdapted, companyAccessibility,
    experience, requiredExperience, lastUpdate, education, language, skills, softSkills, driverLicence];
}

class Skill extends Equatable {
  String? description;
  String? requirement;

  Skill({
    required this.description,
    required this.requirement
  });

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    description: json['libelle'],
    requirement: json['exigence'],
  );

  @override
  List<Object?> get props => [description, requirement];
}

class SoftSkill extends Equatable {
  String? description;

  SoftSkill({
    required this.description,
  });

  factory SoftSkill.fromJson(Map<String, dynamic> json) =>
      SoftSkill(
        description: json['libelle'],
      );

  @override
  List<Object?> get props => [description];
}

class DriverLicence extends Equatable {
  String? category;
  String? requirement;

  DriverLicence({
    required this.category,
    required this.requirement
  });

  factory DriverLicence.fromJson(Map<String, dynamic> json) => DriverLicence(
    category: json['libelle'],
    requirement: json['exigence'],
  );

  @override
  List<Object?> get props => [category, requirement];
}

class Education extends Equatable {
  String? level;
  String? field;
  String? requirement;

  Education({
    required this.level,
    required this.field,
    required this.requirement,
  });

  factory Education.fromJson(dynamic json) {
    return Education(
        level: json['name'] as String?,
        field: json['domaineLibelle'] as String?,
        requirement: json['exigence'] as String?,
    );
  }

  @override
  List<Object?> get props => [level, field, requirement];
}

class Language extends Equatable {
  String? type;
  String? requirement;

  Language({
    required this.type,
    required this.requirement
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
        type: json['libelle'],
        requirement: json['exigence'],
    );
  }

  @override
  List<Object?> get props => [type, requirement];
}