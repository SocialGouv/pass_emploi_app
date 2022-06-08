import 'package:equatable/equatable.dart';

abstract class AttachedFileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttachedFileNotInitializedState extends AttachedFileState {}

class AttachedFileLoadingState extends AttachedFileState {}

class AttachedFileSuccessState extends AttachedFileState {
  final Map<String, String> data;

  AttachedFileSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AttachedFileFailureState extends AttachedFileState {}
