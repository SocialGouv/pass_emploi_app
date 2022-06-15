import 'package:equatable/equatable.dart';

class AttachedFilesState extends Equatable {
  final Map<String, AttachedFileStatus> status;

  AttachedFilesState(this.status);

  AttachedFilesState updated(String id, AttachedFileStatus state) {
    final updatedData = status;
    updatedData.update(id, (value) => state, ifAbsent: () => state);
    return AttachedFilesState(updatedData);
  }

  @override
  List<Object?> get props => [status];
}

abstract class AttachedFileStatus {}

class AttachedFileLoadingStatus extends AttachedFileStatus {}

class AttachedFileSuccessStatus extends AttachedFileStatus {}

class AttachedFileFailureStatus extends AttachedFileStatus {}
