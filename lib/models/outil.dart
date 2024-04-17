import 'package:equatable/equatable.dart';

class Outil extends Equatable {
  final String title;
  final String description;
  final String urlRedirect;
  final String? actionLabel;
  final String? imagePath;

  Outil({
    required this.title,
    required this.description,
    required this.urlRedirect,
    this.actionLabel,
    this.imagePath,
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
