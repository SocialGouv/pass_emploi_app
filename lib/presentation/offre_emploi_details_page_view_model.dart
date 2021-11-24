import 'package:pass_emploi_app/models/detailed_offer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/detailed_offer_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

enum OffreEmploiDetailsPageDisplayState { SHOW_DETAILS, SHOW_LOADER, SHOW_ERROR }

class OffreEmploiDetailsPageViewModel {
  final OffreEmploiDetailsPageDisplayState displayState;
  final String errorMessage;

  final String? id;
  final String? title;
  final String? companyName;
  final String? contractType;
  final String? duration;
  final String? location;
  final String? salary;
  final String? offerDescription;
  final String? experience;
  final String? requiredExperience;
  final String? companyUrl;
  final bool? companyAdapted;
  final bool? companyAccessibility;
  final String? companyDescription;
  final String? lastUpdate;
  final List<Skill>? skills;
  final List<String>? softSkills;
  final List<Education>? educations;
  final List<Language>? languages;
  final List<DriverLicence>? driverLicences;

  OffreEmploiDetailsPageViewModel._({
    required this.displayState,
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
    required this.companyUrl,
    required this.companyAdapted,
    required this.companyAccessibility,
    required this.companyDescription,
    required this.lastUpdate,
    required this.skills,
    required this.softSkills,
    required this.educations,
    required this.languages,
    required this.driverLicences,
    required this.errorMessage,
  });

  factory OffreEmploiDetailsPageViewModel.getDetails(Store<AppState> store) {
    final searchState = store.state.detailedOfferState;
    var lol = _detailedOffer(searchState);
    return OffreEmploiDetailsPageViewModel._(
      displayState: _displayState(searchState),
      id: lol?.id,
      title: lol?.title,
      companyName: lol?.companyName,
      contractType: lol?.contractType,
      duration: lol?.duration,
      location: lol?.location,
      salary: lol?.salary,
      offerDescription: lol?.offerDescription,
      experience: lol?.experience,
      requiredExperience: lol?.requiredExperience,
      companyUrl: lol?.companyUrl,
      companyAdapted: lol?.companyAdapted,
      companyAccessibility: lol?.companyAccessibility,
      companyDescription: lol?.companyDescription,
      lastUpdate: lol?.lastUpdate?.toDayWithFullMonth(),
      skills: lol?.skills,
      softSkills: lol?.softSkills,
      educations: lol?.educations,
      languages: lol?.languages,
      driverLicences: lol?.driverLicences,
      errorMessage: Strings.genericError,
    );
  }
}

OffreEmploiDetailsPageDisplayState _displayState(DetailedOfferState searchState) {
  if (searchState is DetailedOfferSuccessState) {
    return OffreEmploiDetailsPageDisplayState.SHOW_DETAILS;
  } else if (searchState is DetailedOfferLoadingState) {
    return OffreEmploiDetailsPageDisplayState.SHOW_LOADER;
  } else {
    return OffreEmploiDetailsPageDisplayState.SHOW_ERROR;
  }
}

DetailedOffer? _detailedOffer(DetailedOfferState searchState) {
  return searchState is DetailedOfferSuccessState ? searchState.offer : null;
}
