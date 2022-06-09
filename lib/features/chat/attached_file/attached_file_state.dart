import 'package:equatable/equatable.dart';

abstract class AttachedFileState extends Equatable {
  final Map<String, String?> data;

  AttachedFileState(this.data);

  @override
  List<Object?> get props => [data];
}

class AttachedFileNotInitializedState extends AttachedFileState {
  AttachedFileNotInitializedState(super.data);
}

class AttachedFileLoadingState extends AttachedFileState {
  AttachedFileLoadingState(super.data);
}

class AttachedFileSuccessState extends AttachedFileState {
  AttachedFileSuccessState(super.data);
}

class AttachedFileFailureState extends AttachedFileState {
  AttachedFileFailureState(super.data);
}
