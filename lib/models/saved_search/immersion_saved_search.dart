import 'package:equatable/equatable.dart';

class ImmersionSavedSearch extends Equatable {
  final String title;
  final String metier;
  final String location;
  final ImmersionSearchParametersFilters? filters;

  ImmersionSavedSearch({
    required this.title,
    required this.metier,
    required this.location,
    required this.filters,
  });

  @override
  List<Object?> get props => [title, metier, location, filters];
}

class ImmersionSearchParametersFilters extends Equatable {
  final String? codeRome;
  final double? lat;
  final double? lon;

  ImmersionSearchParametersFilters({
    this.codeRome,
    this.lat,
    this.lon,
  });

  factory ImmersionSearchParametersFilters.withFilters({
    required String? codeRome,
    required double? lat,
    required double? lon,
  }) {
    return ImmersionSearchParametersFilters(
      codeRome: codeRome,
      lat: lat,
      lon: lon,
    );
  }

  factory ImmersionSearchParametersFilters.withoutFilters() {
    return ImmersionSearchParametersFilters(
      codeRome: null,
      lat: null,
      lon: null,
    );
  }

  @override
  List<Object?> get props => [codeRome, lat, lon];
}
