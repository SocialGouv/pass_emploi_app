import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class Commentaire extends Equatable {
  final String id;
  final String? content;
  final DateTime? creationDate;
  final bool createdByAdvisor;
  final String? creatorName;

  Commentaire({
    required this.id,
    required this.content,
    required this.creationDate,
    required this.createdByAdvisor,
    required this.creatorName,
  });

  factory Commentaire.fromJson(dynamic json) {
    return Commentaire(
      id: json['id'] as String,
      content: json['message'] as String?,
      creationDate: (json['date'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
      createdByAdvisor: _creator(json),
      creatorName: _creator(json) ? _creatorName(json) : null,
    );
  }

  String? getDayDate() => creationDate?.toDayOfWeekWithFullMonth();

  @override
  List<Object?> get props => [id, content, creationDate, createdByAdvisor, creatorName];
}


bool _creator(dynamic json) {
  final creatorType = json["createur"]["type"] as String;
  return creatorType == "conseiller";
}

String _creatorName(dynamic json) {
  final creatorFirstName = json["createur"]["prenom"] as String;
  final creatorLastName = json["createur"]["nom"] as String;
  return creatorFirstName + " " + creatorLastName;
}