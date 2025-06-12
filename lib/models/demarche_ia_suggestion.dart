import 'package:equatable/equatable.dart';

class DemarcheIaSuggestion extends Equatable {
  final String id;
  final String? content;
  final String? label;
  final String? titre;
  final String? sousTitre;

  DemarcheIaSuggestion({
    required this.id,
    required this.content,
    required this.label,
    required this.titre,
    required this.sousTitre,
  });

  @override
  List<Object?> get props => [id, content, label, titre, sousTitre];
}
