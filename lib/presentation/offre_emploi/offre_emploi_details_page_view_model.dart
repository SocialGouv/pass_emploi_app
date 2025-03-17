import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/date_consultation_offre/date_derniere_consultation_store_extension.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_actions.dart';
import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_state.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_origin_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

enum OffreEmploiDetailsPageDisplayState { SHOW_DETAILS, SHOW_INCOMPLETE_DETAILS, SHOW_LOADER, SHOW_ERROR }

class OffreEmploiDetailsPageViewModel {
  final OffreEmploiDetailsPageDisplayState displayState;
  final bool shouldShowCvBottomSheet;
  final bool shouldShowOffreSuivieBottomSheet;
  final bool shouldShowOffreSuiviForm;
  final void Function() onPostuler;
  final String? id;
  final String? title;
  final String? urlRedirectPourPostulation;
  final String? companyName;
  final String? contractType;
  final DateTime? dateDerniereConsultation;
  final DateTime? datePostulation;
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
  final OffreEmploiOriginViewModel? originViewModel;
  final List<Skill>? skills;
  final List<String>? softSkills;
  final List<EducationViewModel>? educations;
  final List<Language>? languages;
  final List<DriverLicence>? driverLicences;

  OffreEmploiDetailsPageViewModel._({
    required this.displayState,
    required this.shouldShowCvBottomSheet,
    required this.shouldShowOffreSuivieBottomSheet,
    required this.shouldShowOffreSuiviForm,
    required this.onPostuler,
    this.id,
    this.title,
    this.urlRedirectPourPostulation,
    this.companyName,
    this.contractType,
    this.dateDerniereConsultation,
    this.datePostulation,
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
    this.originViewModel,
    this.skills,
    this.softSkills,
    this.educations,
    this.languages,
    this.driverLicences,
  });

  factory OffreEmploiDetailsPageViewModel.create(Store<AppState> store) {
    final offreEmploiDetailsState = store.state.offreEmploiDetailsState;
    final loginMode = (store.state.loginState as LoginSuccessState).user.loginMode;
    if (offreEmploiDetailsState is OffreEmploiDetailsSuccessState) {
      final offreId = offreEmploiDetailsState.offre.id;
      return _viewModelFromDetails(
        store,
        offreEmploiDetailsState,
        offreEmploiDetailsState.offre,
        loginMode,
        store.getOffreDateDerniereConsultationOrNull(offreId),
      );
    } else if (offreEmploiDetailsState is OffreEmploiDetailsIncompleteDataState) {
      final offreId = offreEmploiDetailsState.offre.id;
      return _viewModelFromIncompleteData(
        store,
        offreEmploiDetailsState.offre,
        loginMode,
        store.getOffreDateDerniereConsultationOrNull(offreId),
      );
    } else {
      return _viewModelForOtherCases(
        store,
        offreEmploiDetailsState,
        loginMode,
      );
    }
  }
}

OffreEmploiDetailsPageDisplayState _displayState(OffreEmploiDetailsState state) {
  if (state is OffreEmploiDetailsSuccessState) return OffreEmploiDetailsPageDisplayState.SHOW_DETAILS;
  if (state is OffreEmploiDetailsLoadingState) return OffreEmploiDetailsPageDisplayState.SHOW_LOADER;
  return OffreEmploiDetailsPageDisplayState.SHOW_ERROR;
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
  Store<AppState> store,
  OffreEmploiDetailsSuccessState offreEmploiDetailsState,
  OffreEmploiDetails offreDetails,
  LoginMode loginMode,
  DateTime? dateDerniereConsultation,
) {
  return OffreEmploiDetailsPageViewModel._(
    displayState: OffreEmploiDetailsPageDisplayState.SHOW_DETAILS,
    shouldShowCvBottomSheet: loginMode.isPe(),
    shouldShowOffreSuivieBottomSheet: _shouldShowOffreSuivieBottomSheet(store, offreDetails.toOffreEmploi),
    shouldShowOffreSuiviForm: _shouldShowOffreSuiviForm(store, offreDetails.toOffreEmploi),
    onPostuler: () => _onPostuler(store, offreDetails.toOffreEmploi),
    id: offreDetails.id,
    title: offreDetails.title,
    urlRedirectPourPostulation: offreDetails.urlRedirectPourPostulation,
    companyName: offreDetails.companyName,
    contractType: offreDetails.contractType,
    dateDerniereConsultation: dateDerniereConsultation,
    datePostulation: _datePostulation(store, offreDetails.id),
    duration: offreDetails.duration?.removeNewLine(),
    location: offreDetails.location,
    salary: offreDetails.salary,
    description: offreDetails.description,
    experience: offreDetails.experience,
    requiredExperience: offreDetails.requiredExperience,
    companyUrl: offreDetails.companyUrl,
    companyAdapted: offreDetails.companyAdapted,
    companyAccessibility: offreDetails.companyAccessibility,
    companyDescription: offreDetails.companyDescription,
    lastUpdate: offreDetails.lastUpdate?.timeAgo(),
    originViewModel: OffreEmploiOriginViewModel.from(offreDetails.origin),
    skills: offreDetails.skills,
    softSkills: offreDetails.softSkills,
    educations: offreDetails.educations?.map((e) => _toViewModel(e)).toList(),
    languages: offreDetails.languages,
    driverLicences: offreDetails.driverLicences,
  );
}

OffreEmploiDetailsPageViewModel _viewModelFromIncompleteData(
  Store<AppState> store,
  OffreEmploi offreEmploi,
  LoginMode loginMode,
  DateTime? dateDerniereConsultation,
) {
  return OffreEmploiDetailsPageViewModel._(
    displayState: OffreEmploiDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS,
    shouldShowCvBottomSheet: loginMode.isPe(),
    shouldShowOffreSuivieBottomSheet: _shouldShowOffreSuivieBottomSheet(store, offreEmploi),
    shouldShowOffreSuiviForm: _shouldShowOffreSuiviForm(store, offreEmploi),
    onPostuler: () => _onPostuler(store, offreEmploi),
    title: offreEmploi.title,
    location: offreEmploi.location,
    id: offreEmploi.id,
    duration: offreEmploi.duration?.removeNewLine(),
    companyName: offreEmploi.companyName,
    contractType: offreEmploi.contractType,
    dateDerniereConsultation: dateDerniereConsultation,
    datePostulation: null,
  );
}

OffreEmploiDetailsPageViewModel _viewModelForOtherCases(
  Store<AppState> store,
  OffreEmploiDetailsState state,
  LoginMode loginMode,
) {
  return OffreEmploiDetailsPageViewModel._(
    displayState: _displayState(state),
    shouldShowCvBottomSheet: loginMode.isPe(),
    shouldShowOffreSuivieBottomSheet: false,
    shouldShowOffreSuiviForm: false,
    onPostuler: () {},
    datePostulation: null,
  );
}

bool _shouldShowOffreSuivieBottomSheet(Store<AppState> store, OffreEmploi offre) {
  return store.shouldShowOffreSuivieBottomSheet(offre);
}

bool _shouldShowOffreSuiviForm(Store<AppState> store, OffreEmploi offre) {
  final offresSuiviesState = store.state.offresSuiviesState;
  return offresSuiviesState.isPresent(offre.id) || offresSuiviesState.confirmationOffre?.offreDto.id == offre.id;
}

void _onPostuler(Store<AppState> store, OffreEmploi offre) {
  if (store.shouldShowOffreSuivieBottomSheet(offre)) {
    store.dispatch(OffresSuiviesWriteAction(OffreEmploiDto(offre)));
  }
}

DateTime? _datePostulation(Store<AppState> store, String offreId) {
  return store.state.offreEmploiFavorisIdsState.datePostulationOf(offreId);
}

extension on Store<AppState> {
  bool shouldShowOffreSuivieBottomSheet(OffreEmploi offre) {
    final offresSuiviesState = state.offresSuiviesState;
    final isOffreSuivie = offresSuiviesState.isPresent(offre.id);

    final isOffreFavoris = state.offreEmploiFavorisIdsState.contains(offre.id);
    return !isOffreSuivie && !isOffreFavoris;
  }
}

extension on String? {
  String? removeNewLine() {
    return this?.replaceAll('\n', ' - ');
  }
}
