import 'package:equatable/equatable.dart';

sealed class ImagePath extends Equatable {}

class NetworkImagePath extends ImagePath {
  final String url;

  NetworkImagePath(this.url);

  @override
  List<Object?> get props => [url];
}

class AssetsImagePath extends ImagePath {
  final String path;

  AssetsImagePath(this.path);

  @override
  List<Object?> get props => [path];
}
