import 'package:pass_emploi_app/models/detailed_offer.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class OffreEmploiDetailedViewModel {
  final String  id;
  final String  title;
  final String? companyName;
  final String  contractType;
  final String? duration;
  final String  location;
  final String? salary;
  final String? offerDescription;
  final String? experience;
  // final String skills;
  // final String softSkills;
  final String? education;
  final String? language;
  final String? driverLicence;
  final String? companyUrl;
  final String? numberOfStuff;
  final String? companyDescription;

  OffreEmploiDetailedViewModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.contractType,
    required this.duration,
    required this.location,
    required this.salary,
    required this.offerDescription,
    required this.experience,
    required this.education,
    required this.language,
    required this.driverLicence,
    required this.companyUrl,
    required this.numberOfStuff,
    required this.companyDescription,
    /*this.skills,
    This.softSkills*/
  });

  factory OffreEmploiDetailedViewModel.create(DetailedOffer offer) {
    return OffreEmploiDetailedViewModel(
      id:                 offer.id,
      title:              offer.title,
      companyName:        offer.companyName,
      contractType:       offer.contractType,
      duration:           offer.duration,
      location:           offer.location,
      salary:             offer.salary,
      offerDescription:   offer.offerDescription,
      experience:         offer.experience,
      education:          offer.education,
      language:           offer.language,
      driverLicence:      offer.driverLicence,
      companyUrl:        offer.companyUrl,
      numberOfStuff:      offer.numberOfStuff,
      companyDescription: offer.companyDescription,
    );
  }
}
