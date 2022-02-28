import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';

abstract class ServiceCiviqueSearchResultState extends Equatable {
  ServiceCiviqueSearchResultState._();

  factory ServiceCiviqueSearchResultState.fromResponse(ServiceCiviqueSearchResponse response) =>
      ServiceCiviqueSearchResultDataState(
        isMoreDataAvailable: response.isMoreDataAvailable,
        loadedPage: response.lastPageRequested,
        offres: response.offres,
      );
}

class ServiceCiviqueSearchResultNotInitializedState extends ServiceCiviqueSearchResultState {
  ServiceCiviqueSearchResultNotInitializedState() : super._();

  @override
  List<Object?> get props => [];
}

class ServiceCiviqueSearchResultLoadingState extends ServiceCiviqueSearchResultState {
  ServiceCiviqueSearchResultLoadingState() : super._();

  @override
  List<Object?> get props => [];
}

class ServiceCiviqueSearchResultErrorState extends ServiceCiviqueSearchResultState {
  ServiceCiviqueSearchResultErrorState() : super._();

  @override
  List<Object?> get props => [];
}

class ServiceCiviqueSearchResultDataState extends ServiceCiviqueSearchResultState {
  final List<ServiceCivique> offres;
  final int loadedPage;
  final bool isMoreDataAvailable;

  ServiceCiviqueSearchResultDataState({
    required this.isMoreDataAvailable,
    required this.loadedPage,
    required this.offres,
  }) : super._();

  @override
  List<Object?> get props => [this.offres, this.loadedPage, this.isMoreDataAvailable];
}
