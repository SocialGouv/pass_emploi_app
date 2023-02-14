import 'package:equatable/equatable.dart';

class ImmersionFiltresRecherche extends Equatable {
  static const defaultDistanceValue = 10;

  final int? distance;

  ImmersionFiltresRecherche._({this.distance});

  @override
  List<Object?> get props => [distance];

  factory ImmersionFiltresRecherche.noFiltre() {
    return ImmersionFiltresRecherche._(
      distance: null,
    );
  }

  factory ImmersionFiltresRecherche.distance(int? distance) {
    return ImmersionFiltresRecherche._(
      distance: distance,
    );
  }
}
