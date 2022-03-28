import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/MonConseillerInfo.dart';

abstract class ConseillerState extends Equatable {
  @override
  List<Object> get props => [];
}

class ConseillerNotInitializedState extends ConseillerState {}

class ConseillerLoadingState extends ConseillerState {}

class ConseillerSuccessState extends ConseillerState {
  final MonConseillerInfo conseillerInfo;

  ConseillerSuccessState({required this.conseillerInfo});

  @override
  List<Object> get props => [conseillerInfo];
}

class ConseillerFailureState extends ConseillerState {}