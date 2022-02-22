import 'package:equatable/equatable.dart';

import '../requests/immersion_request.dart';

abstract class ImmersionSearchRequestState extends Equatable {
  ImmersionSearchRequestState._();
}

class RequestedImmersionSearchRequestState extends ImmersionSearchRequestState {
  final String codeRome;
  final double latitude;
  final double longitude;
  final String ville;

  RequestedImmersionSearchRequestState({
    required this.codeRome,
    required this.latitude,
    required this.longitude,
    required this.ville,
  }) : super._();

  static RequestedImmersionSearchRequestState fromRequest(ImmersionRequest request) {
    return RequestedImmersionSearchRequestState(
      codeRome: request.codeRome,
      latitude: request.location.latitude ?? 0,
      longitude: request.location.longitude ?? 0,
      ville: request.location.libelle,
    );
  }

  @override
  List<Object> get props => [codeRome, latitude, longitude, ville];
}

class EmptyImmersionSearchRequestState extends ImmersionSearchRequestState {
  EmptyImmersionSearchRequestState() : super._();

  @override
  List<Object> get props => [];
}
