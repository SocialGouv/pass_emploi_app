import 'package:equatable/equatable.dart';

class AttachedFilesState extends Equatable {
  final Map<String, AttachedFileStatus> status;

  AttachedFilesState(this.status);

  @override
  List<Object?> get props => [status];

  AttachedFilesState updated(String id, AttachedFileStatus state) {
    final updatedData = status;
    updatedData.update(id, (value) => state, ifAbsent: () => state);
    return AttachedFilesState(updatedData);
  }
}

abstract class AttachedFileStatus extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttachedFileLoadingStatus extends AttachedFileStatus {
  AttachedFileLoadingStatus();
}

class AttachedFileSuccessStatus extends AttachedFileStatus {
  final String path;

  AttachedFileSuccessStatus(this.path);

  @override
  List<Object?> get props => [path];
}

class AttachedFileFailureStatus extends AttachedFileStatus {
  AttachedFileFailureStatus();
}
