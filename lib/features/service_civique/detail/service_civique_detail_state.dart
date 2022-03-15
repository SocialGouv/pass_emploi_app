import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';

abstract class ServiceCiviqueDetailState extends Equatable {
  ServiceCiviqueDetailState._();

  @override
  List<Object?> get props => [];
}

class ServiceCiviqueDetailLoadingState extends ServiceCiviqueDetailState {
  ServiceCiviqueDetailLoadingState() : super._();
}

class ServiceCiviqueDetailFailureState extends ServiceCiviqueDetailState {
  ServiceCiviqueDetailFailureState() : super._();
}

class ServiceCiviqueDetailNotInitializedState extends ServiceCiviqueDetailState {
  ServiceCiviqueDetailNotInitializedState() : super._();
}

class ServiceCiviqueDetailNotFoundState extends ServiceCiviqueDetailState {
  final ServiceCivique serviceCivique;

  ServiceCiviqueDetailNotFoundState(this.serviceCivique) : super._();
}

class ServiceCiviqueDetailSuccessState extends ServiceCiviqueDetailState {
  final ServiceCiviqueDetail detail;

  ServiceCiviqueDetailSuccessState(this.detail) : super._();

  @override
  List<Object?> get props => [detail];
}
