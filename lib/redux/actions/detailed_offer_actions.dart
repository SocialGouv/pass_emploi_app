import 'package:pass_emploi_app/models/detailed_offer.dart';

abstract class DetailedOfferAction {}

class DetailedOfferLoadingAction extends DetailedOfferAction {}

class GetDetailedOfferAction extends DetailedOfferAction {
  final String offerId;

  GetDetailedOfferAction({required this.offerId});
}

class DetailedOfferSuccessAction extends DetailedOfferAction {
  final DetailedOffer offer;

  DetailedOfferSuccessAction(this.offer);
}

class DetailedOfferFailureAction extends DetailedOfferAction {}
