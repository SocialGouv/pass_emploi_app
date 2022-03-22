import 'package:equatable/equatable.dart';

class ImmersionSearchParametersFiltres extends Equatable {
  static const defaultDistanceValue = 10;

  final int? distance;

  ImmersionSearchParametersFiltres._({this.distance});

  @override
  List<Object?> get props => [distance];

  factory ImmersionSearchParametersFiltres.noFiltres() {
    return ImmersionSearchParametersFiltres._(
      distance: null,
    );
  }

  factory ImmersionSearchParametersFiltres.distance(int? distance) {
    return ImmersionSearchParametersFiltres._(
      distance: distance,
    );
  }
}
