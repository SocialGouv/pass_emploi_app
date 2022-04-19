import 'package:equatable/equatable.dart';

class ServiceCiviqueFiltresParameters extends Equatable {
  static const defaultDistanceValue = 10;

  final int? distance;

  ServiceCiviqueFiltresParameters._({this.distance});

  @override
  List<Object?> get props => [distance];

  factory ServiceCiviqueFiltresParameters.noFiltres() {
    return ServiceCiviqueFiltresParameters._(
      distance: null,
    );
  }

  factory ServiceCiviqueFiltresParameters.distance(int? distance) {
    return ServiceCiviqueFiltresParameters._(
      distance: distance,
    );
  }
}