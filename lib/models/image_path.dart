sealed class ImagePath {}

class NetworkImagePath extends ImagePath {
  final String url;

  NetworkImagePath(this.url);
}

class AssetImagePath extends ImagePath {
  final String path;

  AssetImagePath(this.path);
}
