import 'package:equatable/equatable.dart';

sealed class ImageSource extends Equatable {}

class NetworkImageSource extends ImageSource {
  final String url;

  NetworkImageSource(this.url);

  @override
  List<Object?> get props => [url];
}

class AssetsImageSource extends ImageSource {
  final String path;

  AssetsImageSource(this.path);

  @override
  List<Object?> get props => [path];
}
