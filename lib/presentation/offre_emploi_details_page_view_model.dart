import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_details_state.dart';
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
  final List<EducationViewModel>? educations;
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
    final detailedOffer = _detailedOffer(searchState);
    return OffreEmploiDetailsPageViewModel._(
      displayState: _displayState(searchState),
      id: detailedOffer?.id,
      title: detailedOffer?.title,
      companyName: detailedOffer?.companyName,
      contractType: detailedOffer?.contractType,
      duration: detailedOffer?.duration,
      location: detailedOffer?.location,
      salary: detailedOffer?.salary,
      offerDescription: detailedOffer?.offerDescription,
      experience: detailedOffer?.experience,
      requiredExperience: detailedOffer?.requiredExperience,
      companyUrl: detailedOffer?.companyUrl,
      companyAdapted: detailedOffer?.companyAdapted,
      companyAccessibility: detailedOffer?.companyAccessibility,
      companyDescription: detailedOffer?.companyDescription,
      lastUpdate: detailedOffer?.lastUpdate?.toDayWithFullMonth(),
      skills: detailedOffer?.skills,
      softSkills: detailedOffer?.softSkills,
      educations: detailedOffer?.educations?.map((e) => _toViewModel(e)).toList(),
      languages: detailedOffer?.languages,
      driverLicences: detailedOffer?.driverLicences,
      errorMessage: Strings.genericError,
    );
  }
}

OffreEmploiDetailsPageDisplayState _displayState(OffreEmploiDetailsState searchState) {
  if (searchState is OffreEmploiDetailsSuccessState) {
    return OffreEmploiDetailsPageDisplayState.SHOW_DETAILS;
  } else if (searchState is OffreEmploiDetailsLoadingState) {
    return OffreEmploiDetailsPageDisplayState.SHOW_LOADER;
  } else {
    return OffreEmploiDetailsPageDisplayState.SHOW_ERROR;
  }
}

OffreEmploiDetails? _detailedOffer(OffreEmploiDetailsState searchState) {
  return searchState is OffreEmploiDetailsSuccessState ? searchState.offre : null;
}

EducationViewModel _toViewModel(Education education) {
  final field = education.field != null ? " ${education.field}" : "";
  return EducationViewModel("${education.level}$field", education.requirement);
}

class EducationViewModel extends Equatable {
  final String label;
  final String? requirement;

  EducationViewModel(this.label, this.requirement);

  @override
  List<Object?> get props => [label, requirement];
}
