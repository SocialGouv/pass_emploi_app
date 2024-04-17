import 'package:equatable/equatable.dart';

class Outil extends Equatable {
  final String title;
  final String description;
  final OutilRedirect outilRedirect;
  final String? actionLabel;
  final String? imagePath;

  Outil({
    required this.title,
    required this.description,
    required this.outilRedirect,
    this.actionLabel,
    this.imagePath,
  });

  Outil withoutImage() {
    return Outil(
      title: title,
      description: description,
      actionLabel: actionLabel,
      outilRedirect: outilRedirect,
      imagePath: null,
    );
  }

  @override
  List<Object?> get props => [title, description, actionLabel, outilRedirect, imagePath];
}

enum OutilInternalLink { benevolat }

sealed class OutilRedirect extends Equatable {}

class OutilExternalRedirect extends OutilRedirect {
  final String url;

  OutilExternalRedirect(this.url);

  @override
  List<Object?> get props => [url];
}

class OutilInternalRedirect extends OutilRedirect {
  final OutilInternalLink internalLink;

  OutilInternalRedirect(this.internalLink);

  @override
  List<Object?> get props => [internalLink];
}
