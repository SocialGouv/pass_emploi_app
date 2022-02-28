import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/service_civique.dart';

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
  ServiceCiviqueSearchResultErrorState() : super._();
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
  List<Object?> get props => [offres, loadedPage, isMoreDataAvailable];
}
