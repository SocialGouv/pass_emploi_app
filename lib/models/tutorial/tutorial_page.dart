import 'package:equatable/equatable.dart';

class TutorialPage extends Equatable {
  final String title;
  final String description;
  final String image;

  TutorialPage({required this.title, required this.description, required this.image});

  @override
  List<Object?> get props => [title, description, image];
}
