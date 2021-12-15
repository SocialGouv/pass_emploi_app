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
}
