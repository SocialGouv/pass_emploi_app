import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/repositories/auto_inscription_repository.dart';

sealed class AutoInscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AutoInscriptionNotInitializedState extends AutoInscriptionState {}

class AutoInscriptionLoadingState extends AutoInscriptionState {}

class AutoInscriptionFailureState extends AutoInscriptionState {
  final AutoInscriptionError error;

  AutoInscriptionFailureState({required this.error});
}

class AutoInscriptionSuccessState extends AutoInscriptionState {}
