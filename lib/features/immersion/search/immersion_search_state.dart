import 'package:equatable/equatable.dart';

import '../list/immersion_list_request.dart';

abstract class ImmersionSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class ImmersionSearchRequestState extends ImmersionSearchState {
  final String codeRome;
  final double latitude;
  final double longitude;
  final String ville;

  ImmersionSearchRequestState({
    required this.codeRome,
    required this.latitude,
    required this.longitude,
    required this.ville,
  });

  static ImmersionSearchRequestState fromRequest(ImmersionListRequest request) {
    return ImmersionSearchRequestState(
      codeRome: request.codeRome,
      latitude: request.location.latitude ?? 0,
      longitude: request.location.longitude ?? 0,
      ville: request.location.libelle,
    );
  }

  @override
  List<Object> get props => [codeRome, latitude, longitude, ville];
}

class ImmersionSearchEmptyState extends ImmersionSearchState {}
