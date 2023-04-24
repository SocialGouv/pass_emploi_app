import 'package:equatable/equatable.dart';

class Outil extends Equatable {
  final String title;
  final String description;
  final String actionLabel;
  final String urlRedirect;
  final String? imagePath;

  Outil({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.urlRedirect,
    required this.imagePath,
  });

  Outil withoutImage() {
    return Outil(
      title: title,
      description: description,
      actionLabel: actionLabel,
      urlRedirect: urlRedirect,
      imagePath: null,
    );
  }

  @override
  List<Object?> get props => [title, description, actionLabel, urlRedirect, imagePath];
}
