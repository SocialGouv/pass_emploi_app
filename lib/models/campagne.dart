import 'package:equatable/equatable.dart';

class Campagne extends Equatable {
  final String id;
  final String titre;
  final String description;
  final List<Question> questions;

  Campagne({required this.id, required this.titre, required this.description, required this.questions});

  factory Campagne.fromJson(dynamic json) {
    final questions = (json["questions"] as List).map((question) => Question.fromJson(question)).toList();
    return Campagne(
      id: json["id"] as String,
      titre: json["titre"] as String,
      description: json["description"] as String,
      questions: questions,
    );
  }

  @override
  List<Object?> get props => [id, titre, description, questions];
}

class Question extends Equatable {
  final int id;
  final String libelle;
  final List<Option> options;

  Question({required this.id, required this.libelle, required this.options});

  factory Question.fromJson(dynamic json) {
    final options = (json["options"] as List).map((option) => Option.fromJson(option)).toList();
    return Question(
      id: json["id"] as int,
      libelle: json["libelle"] as String,
      options: options,
    );
  }

  @override
  List<Object?> get props => [id, libelle, options];
}

class Option extends Equatable {
  final int id;
  final String libelle;

  Option({required this.id, required this.libelle});

  factory Option.fromJson(dynamic json) {
    return Option(
      id: json["id"] as int,
      libelle: json["libelle"] as String,
    );
  }

  @override
  List<Object?> get props => [id, libelle];
}
