import 'package:equatable/equatable.dart';

abstract class PreviewFileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PreviewFileSuccessState extends PreviewFileState {
  final String path;

  PreviewFileSuccessState(this.path);

  @override
  List<Object?> get props => [path];
}

class PreviewFileNotInitializedState extends PreviewFileState {}
