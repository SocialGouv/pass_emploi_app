import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/detailed_offer.dart';

abstract class DetailedOfferState extends Equatable {
  DetailedOfferState._();

  factory DetailedOfferState.loading() =  DetailedOfferLoadingState;

  factory DetailedOfferState.success(DetailedOffer offer) = DetailedOfferSuccessState;

  factory DetailedOfferState.failure() = DetailedOfferFailureState;

  factory DetailedOfferState.notInitialized() = DetailedOfferNotInitializedState;

  @override
  List<Object> get props => [];
}

class DetailedOfferLoadingState extends DetailedOfferState {
  DetailedOfferLoadingState() : super._();
}

class DetailedOfferSuccessState extends DetailedOfferState {
  final DetailedOffer offer;

  DetailedOfferSuccessState(this.offer) : super._();

  @override
  List<Object> get props => [offer];
}

class DetailedOfferFailureState extends DetailedOfferState {
  DetailedOfferFailureState() : super._();
}

class DetailedOfferNotInitializedState extends DetailedOfferState {
  DetailedOfferNotInitializedState() : super._();
}
