import 'package:equatable/equatable.dart';

class DemarcheIaSuggestion extends Equatable {
  final String id;
  final String? label;
  final String? titre;
  final String? sousTitre;
  final String codeQuoi;
  final String codePourquoi;

  DemarcheIaSuggestion({
    required this.id,
    required this.label,
    required this.titre,
    required this.sousTitre,
    required this.codeQuoi,
    required this.codePourquoi,
  });

  @override
  List<Object?> get props => [id, label, titre, sousTitre, codeQuoi, codePourquoi];
}
