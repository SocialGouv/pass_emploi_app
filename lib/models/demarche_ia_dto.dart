import 'package:equatable/equatable.dart';

class DemarcheIaDto extends Equatable {
  final String description;
  final String codePourquoi;
  final String codeQuoi;

  DemarcheIaDto({required this.description, required this.codePourquoi, required this.codeQuoi});

  factory DemarcheIaDto.fromJson(dynamic json) {
    return DemarcheIaDto(
      description: json['description'] as String,
      codePourquoi: json['codePourquoi'] as String,
      codeQuoi: json['codeQuoi'] as String,
    );
  }

  @override
  List<Object?> get props => [description, codePourquoi, codeQuoi];
}
