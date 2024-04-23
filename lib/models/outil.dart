import 'package:equatable/equatable.dart';

class Outil extends Equatable {
  final String title;
  final String description;
  final OutilRedirectMode redirectMode;
  final String? actionLabel;
  final String? imagePath;

  Outil({
    required this.title,
    required this.description,
    required this.redirectMode,
    this.actionLabel,
    this.imagePath,
  });

  Outil withoutImage() {
    return Outil(
      title: title,
      description: description,
      actionLabel: actionLabel,
      redirectMode: redirectMode,
      imagePath: null,
    );
  }

  @override
  List<Object?> get props => [title, description, actionLabel, redirectMode, imagePath];
}

enum OutilInternalLink { benevolat }

sealed class OutilRedirectMode extends Equatable {}

class OutilExternalRedirectMode extends OutilRedirectMode {
  final String url;

  OutilExternalRedirectMode(this.url);

  @override
  List<Object?> get props => [url];
}

class OutilInternalRedirectMode extends OutilRedirectMode {
  final OutilInternalLink internalLink;

  OutilInternalRedirectMode(this.internalLink);

  @override
  List<Object?> get props => [internalLink];
}
