import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

enum OffreEmploiDetailsPageDisplayState { SHOW_DETAILS, SHOW_INCOMPLETE_DETAILS, SHOW_LOADER, SHOW_ERROR }

class OffreEmploiDetailsPageViewModel {
  final OffreEmploiDetailsPageDisplayState displayState;
  final String? errorMessage;
  final String? id;
  final String? title;
  final String? urlRedirectPourPostulation;
  final String? companyName;
  final String? contractType;
  final String? duration;
  final String? location;
  final String? salary;
  final String? description;
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
    this.errorMessage,
    this.id,
    this.title,
    this.urlRedirectPourPostulation,
    this.companyName,
    this.contractType,
    this.duration,
    this.location,
    this.salary,
    this.description,
    this.experience,
    this.requiredExperience,
    this.companyUrl,
    this.companyAdapted,
    this.companyAccessibility,
    this.companyDescription,
    this.lastUpdate,
    this.skills,
    this.softSkills,
    this.educations,
    this.languages,
    this.driverLicences,
  });

  factory OffreEmploiDetailsPageViewModel.getDetails(Store<AppState> store) {
    final offreEmploiDetailsState = store.state.offreEmploiDetailsState;
    if (offreEmploiDetailsState is OffreEmploiDetailsSuccessState) {
      return _viewModelFromDetails(offreEmploiDetailsState, offreEmploiDetailsState.offre);
    } else if (offreEmploiDetailsState is OffreEmploiDetailsIncompleteDataState) {
      return _viewModelFromIncompleteData(offreEmploiDetailsState.offreEmploi);
    } else {
      return _viewModelForOtherCases(offreEmploiDetailsState);
    }
  }
}

OffreEmploiDetailsPageDisplayState _displayState(OffreEmploiDetailsState offreEmploiDetailsState) {
  if (offreEmploiDetailsState is OffreEmploiDetailsSuccessState) {
    return OffreEmploiDetailsPageDisplayState.SHOW_DETAILS;
  } else if (offreEmploiDetailsState is OffreEmploiDetailsLoadingState) {
    return OffreEmploiDetailsPageDisplayState.SHOW_LOADER;
  } else {
    return OffreEmploiDetailsPageDisplayState.SHOW_ERROR;
  }
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

OffreEmploiDetailsPageViewModel _viewModelFromDetails(
  OffreEmploiDetailsState offreEmploiDetailsState,
  OffreEmploiDetails? offreDetails,
) {
  return OffreEmploiDetailsPageViewModel._(
    displayState: OffreEmploiDetailsPageDisplayState.SHOW_DETAILS,
    id: offreDetails?.id,
    title: offreDetails?.title,
    urlRedirectPourPostulation: offreDetails?.urlRedirectPourPostulation,
    companyName: offreDetails?.companyName,
    contractType: offreDetails?.contractType,
    duration: offreDetails?.duration,
    location: offreDetails?.location,
    salary: offreDetails?.salary,
    description: offreDetails?.description,
    experience: offreDetails?.experience,
    requiredExperience: offreDetails?.requiredExperience,
    companyUrl: offreDetails?.companyUrl,
    companyAdapted: offreDetails?.companyAdapted,
    companyAccessibility: offreDetails?.companyAccessibility,
    companyDescription: offreDetails?.companyDescription,
    lastUpdate: offreDetails?.lastUpdate?.toDayWithFullMonth(),
    skills: offreDetails?.skills,
    softSkills: offreDetails?.softSkills,
    educations: offreDetails?.educations?.map((e) => _toViewModel(e)).toList(),
    languages: offreDetails?.languages,
    driverLicences: offreDetails?.driverLicences,
    errorMessage: Strings.genericError,
  );
}

OffreEmploiDetailsPageViewModel _viewModelFromIncompleteData(OffreEmploi offreEmploi) {
  return OffreEmploiDetailsPageViewModel._(
    displayState: OffreEmploiDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS,
    errorMessage: Strings.genericError,
    title: offreEmploi.title,
    location: offreEmploi.location,
    id: offreEmploi.id,
    duration: offreEmploi.duration,
    companyName: offreEmploi.companyName,
    contractType: offreEmploi.contractType,
  );
}

OffreEmploiDetailsPageViewModel _viewModelForOtherCases(OffreEmploiDetailsState offreEmploiDetailsState) {
  return OffreEmploiDetailsPageViewModel._(
    displayState: _displayState(offreEmploiDetailsState),
    errorMessage: Strings.genericError,
  );
}
