import 'package:pass_emploi_app/models/detailed_offer.dart';

class DetailedOfferViewModel {
  final String  id;
  final String  title;
  final String? companyName;
  final String? contractType;
  final String? duration;
  final String? location;
  final String? salary;
  final String? offerDescription;
  final String? experience;
  final String? requiredExperience;
  final String? companyUrl;
  final String? companyDescription;
  final String? lastUpdate;
  final List<Skill?>? skills;
  final List<SoftSkill?>? softSkills;
  final List<Education?>? educations;
  final List<Language?>? languages;
  final List<DriverLicence?>? driverLicences;


  DetailedOfferViewModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.contractType,
    required this.duration,
    required this.location,
    required this.salary,
    required this.offerDescription,
    required this.experience,
    required this.requiredExperience,
    required this.educations,
    required this.languages,
    required this.driverLicences,
    required this.companyUrl,
    required this.companyDescription,
    required this.lastUpdate,
    required this.skills,
    required this.softSkills,
  });

  factory DetailedOfferViewModel.create(DetailedOffer offer) {
    return DetailedOfferViewModel(
      id:                 offer.id,
      title:              offer.title,
      companyName:        offer.companyName,
      contractType:       offer.contractType,
      duration:           offer.duration,
      location:           offer.location,
      salary:             offer.salary,
      offerDescription:   offer.offerDescription,
      experience:         offer.experience,
      educations:         offer.educations,
      languages:          offer.languages,
      driverLicences:     offer.driverLicences,
      companyUrl:         offer.companyUrl,
      companyDescription: offer.companyDescription,
      lastUpdate:         offer.lastUpdate,
      skills:             offer.skills,
      softSkills:         offer.softSkills,
      requiredExperience: offer.requiredExperience,
    );
  }
}
