import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';

class LocationViewModel extends Equatable {
  final String title;
  final Location location;

  LocationViewModel(this.title, this.location);

  @override
  List<Object?> get props => [title, location];

  @override
  String toString() => title;

  static LocationViewModel fromLocation(Location location) {
    final String title;
    switch (location.type) {
      case LocationType.COMMUNE:
        title = '${location.libelle} (${location.codePostal})';
        break;
      case LocationType.DEPARTMENT:
        title = '${location.libelle} (${location.code})';
        break;
    }
    return LocationViewModel(title, location);
  }
}
