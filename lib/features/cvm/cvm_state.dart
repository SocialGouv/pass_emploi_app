import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/repositories/cvm_repository.dart';

sealed class CvmState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CvmNotInitializedState extends CvmState {}

class CvmLoadingState extends CvmState {}

class CvmFailureState extends CvmState {}

class CvmSuccessState extends CvmState {
  final List<CvmMessage> messages;

  CvmSuccessState(this.messages);

  @override
  List<Object?> get props => [messages];
}
