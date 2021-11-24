import 'package:pass_emploi_app/models/detailed_offer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/detailed_offer_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

enum OffreEmploiDetailsPageDisplayState { SHOW_DETAILS, SHOW_LOADER, SHOW_ERROR }

class OffreEmploiDetailsPageViewModel {
  final OffreEmploiDetailsPageDisplayState displayState;
  final DetailedOffer? detailedOffer;
  final String errorMessage;

  //final String  id;
  //final String  title;
  //final String? companyName;
  //final String? contractType;
  //final String? duration;
  //final String? location;
  //final String? salary;
  //final String? offerDescription;
  //final String? experience;
  //final String? requiredExperience;
  //final String? companyUrl;
  //final String? companyDescription;
  //final String? lastUpdate;
  //final List<Skill?>? skills;
  //final List<SoftSkill?>? softSkills;
  //final List<Education?>? educations;
  //final List<Language?>? languages;
  //final List<DriverLicence?>? driverLicences;

  OffreEmploiDetailsPageViewModel._({
    required this.displayState,
    required this.detailedOffer,
    required this.errorMessage,
  });

  factory OffreEmploiDetailsPageViewModel.getDetails(Store<AppState> store) {
    final searchState = store.state.detailedOfferState;
    return OffreEmploiDetailsPageViewModel._(
      displayState: _displayState(searchState),
      detailedOffer: _detailedOffer(searchState),
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
