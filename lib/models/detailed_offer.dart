class DetailedOffer {
  final String  id;
  final String  title;
  final String? offerDescription;
  final String  contractType;
  final String? duration;
  final String  location;
  final String? salary;
  final String? companyName;
  final String? companyDescription;
  final String? companyUrl;
  final String? numberOfStuff;
  final String? experience;
  final String? education;
  final String? language;
  final String? driverLicence;

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
    required this.numberOfStuff,
    required this.experience,
    required this.education,
    required this.language,
    required this.driverLicence,
  });


  factory DetailedOffer.fromJson(dynamic json) {
    return DetailedOffer(
      id:                 json["id"] as String,
      title:              json["intitule"] as String,
      offerDescription:   json["description"] as String?,
      contractType:       json["typeContratLibelle"] as String,
      duration:           json["dureeTravailLibelle"] as String?,
      location:           json["lieuTravail"]["libelle"] as String,
      salary:             json["salaire"]["libelle"] as String?,
      companyName:        json["entreprise"]["nom"] as String?,
      companyDescription: json["entreprise"]["description"] as String?,
      companyUrl:         json["entreprise"]["url"] as String?,
      numberOfStuff:      json["experienceExige"] as String?, //????
      experience:         json["qualificationLibelle"] as String?,
      education:          json["formations"]["niveauLibelle"] as String?,
      language:           json["langues"]["libelle"] as String?,
      driverLicence:      json["experienceExige"] as String?, //?????
    );
  }

}