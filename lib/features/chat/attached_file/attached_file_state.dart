import 'package:equatable/equatable.dart';

class AttachedFilesState extends Equatable {
  final Map<String, AttachedFileState> states;

  AttachedFilesState(this.states);

  @override
  List<Object?> get props => [states];

  AttachedFilesState updated(String id, AttachedFileState state) {
    final updatedData = states;
    updatedData.update(id, (value) => state, ifAbsent: () => state);
    return AttachedFilesState(updatedData);
  }
}

abstract class AttachedFileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttachedFileLoadingState extends AttachedFileState {
  AttachedFileLoadingState();
}

class AttachedFileSuccessState extends AttachedFileState {
  final String path;

  AttachedFileSuccessState(this.path);

  @override
  List<Object?> get props => [path];
}

class AttachedFileFailureState extends AttachedFileState {
  AttachedFileFailureState();
}
