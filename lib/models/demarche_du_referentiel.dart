import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class DemarcheDuReferentiel extends Equatable {
  final String id;
  final String quoi;
  final String pourquoi;
  final String codeQuoi;
  final String codePourquoi;
  final List<Comment> comments;
  final bool commentObligatoire;

  DemarcheDuReferentiel({
    String? id,
    required this.quoi,
    required this.pourquoi,
    required this.codeQuoi,
    required this.codePourquoi,
    required this.comments,
    required this.commentObligatoire,
  }) : id = id ?? Uuid().v4();

  factory DemarcheDuReferentiel.fromJson(dynamic json) {
    return DemarcheDuReferentiel(
      quoi: json['libelleQuoi'] as String,
      pourquoi: json['libellePourquoi'] as String,
      codeQuoi: json['codeQuoi'] as String,
      codePourquoi: json['codePourquoi'] as String,
      commentObligatoire: json['commentObligatoire'] as bool,
      comments: (json['comment'] as List).map((comment) => Comment.fromJson(comment)).toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        quoi,
        pourquoi,
        codeQuoi,
        codePourquoi,
        comments,
        commentObligatoire,
      ];
}

class Comment extends Equatable {
  final String label;
  final String code;

  Comment({required this.label, required this.code});

  factory Comment.fromJson(dynamic json) {
    return Comment(
      label: json['label'] as String,
      code: json['code'] as String,
    );
  }

  @override
  List<Object?> get props => [label, code];
}
