import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
//TODO(1418): à supprimer ?
class SearchLocationState extends Equatable {
  final List<Location> locations;

  SearchLocationState(this.locations);

  @override
  List<Object?> get props =>[locations];
}