import 'package:equatable/equatable.dart';

class ServiceCiviqueFiltresRecherche extends Equatable {
  final int? distance;
  final String? startDate;
  final String? domain;

  ServiceCiviqueFiltresRecherche({
    required this.distance,
    required this.startDate,
    required this.domain,
  });

  @override
  List<Object?> get props => [distance, startDate, domain];
}
