import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class Commentaire extends Equatable {
  final String id;
  final String? content;
  final DateTime? creationDate;
  final UserActionCreator creator;

  Commentaire({
    required this.id,
    required this.content,
    required this.creator,
    required this.creationDate,
  });

  factory Commentaire.fromJson(dynamic json) {
    return Commentaire(
      id: json['id'] as String,
      content: json['contenu'] as String?,
      creator: _creator(json),
      creationDate: (json['dateCreation'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
    );
  }

  String? getDayDate() => creationDate?.toDayOfWeekWithFullMonth();

  @override
  List<Object?> get props => [id, content, creator, creationDate];
}


UserActionCreator _creator(dynamic json) {
  final creatorType = json["creatorType"] as String;
  if (creatorType == "jeune") {
    return JeuneActionCreator();
  } else {
    final creatorName = json["creator"] as String;
    return ConseillerActionCreator(
      name: creatorName,
    );
  }
}