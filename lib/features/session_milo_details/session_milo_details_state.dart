import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/session_milo_details.dart';

sealed class SessionMiloDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SessionMiloDetailsNotInitializedState extends SessionMiloDetailsState {}

class SessionMiloDetailsLoadingState extends SessionMiloDetailsState {}

class SessionMiloDetailsFailureState extends SessionMiloDetailsState {}

class SessionMiloDetailsSuccessState extends SessionMiloDetailsState {
  final SessionMiloDetails details;

  SessionMiloDetailsSuccessState(this.details);

  @override
  List<Object?> get props => [details];
}
