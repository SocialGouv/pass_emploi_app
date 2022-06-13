import 'package:equatable/equatable.dart';

abstract class ShareFileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShareFileSuccessState extends ShareFileState {
  final String path;

  ShareFileSuccessState(this.path);

  @override
  List<Object?> get props => [path];
}

class ShareFileNotInitializedState extends ShareFileState {}
