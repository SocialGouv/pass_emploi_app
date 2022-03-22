import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';

abstract class ServiceCiviqueSearchResultState extends Equatable {
  ServiceCiviqueSearchResultState._();

  @override
  List<Object?> get props => [];
}

class ServiceCiviqueSearchResultNotInitializedState extends ServiceCiviqueSearchResultState {
  ServiceCiviqueSearchResultNotInitializedState() : super._();
}

class ServiceCiviqueSearchResultLoadingState extends ServiceCiviqueSearchResultState {
  ServiceCiviqueSearchResultLoadingState() : super._();
}

class ServiceCiviqueSearchResultErrorState extends ServiceCiviqueSearchResultState {
  final SearchServiceCiviqueRequest failedRequest;
  final List<ServiceCivique> previousOffers;

  ServiceCiviqueSearchResultErrorState(this.failedRequest, this.previousOffers) : super._();
}

class ServiceCiviqueSearchResultDataState extends ServiceCiviqueSearchResultState {
  final List<ServiceCivique> offres;
  final SearchServiceCiviqueRequest lastRequest;
  final bool isMoreDataAvailable;

  ServiceCiviqueSearchResultDataState({
    required this.isMoreDataAvailable,
    required this.lastRequest,
    required this.offres,
  }) : super._();

  @override
  List<Object?> get props => [offres, lastRequest, isMoreDataAvailable];
}
