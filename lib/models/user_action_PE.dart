import 'package:pass_emploi_app/utils/string_extensions.dart';

enum UserActionPEStatus { NOT_STARTED, IN_PROGRESS, RETARDED, DONE, CANCELLED }

class UserActionPE {
  final String id;
  final String? content;
  final UserActionPEStatus status;
  final DateTime endDate;
  final DateTime deletionDate;
  final bool createdByAdvisor;

  UserActionPE({
    required this.id,
    required this.content,
    required this.status,
    required this.endDate,
    required this.deletionDate,
    required this.createdByAdvisor,
  });

  factory UserActionPE.fromJson(dynamic json) {
    return UserActionPE(
      id: json['id'] as String,
      content: json['contenu'] as String?,
      status: _statusFromString(statusString: json['statut'] as String),
      endDate: (json['dateFin'] as String).toDateTimeUtcOnLocalTimeZone(),
      deletionDate: (json['dateAnnulation'] as String).toDateTimeUtcOnLocalTimeZone(),
      createdByAdvisor: json['creeeParConseiller'] as bool,
    );
  }
}

UserActionPEStatus _statusFromString({required String statusString}) {
  if (statusString == "A_FAIRE") {
    return UserActionPEStatus.NOT_STARTED;
  } else if (statusString == "EN_COURS") {
    return UserActionPEStatus.IN_PROGRESS;
  } else if (statusString == "EN_RETARD") {
    return UserActionPEStatus.RETARDED;
  } else if (statusString == "REALISEE") {
    return UserActionPEStatus.DONE;
  } else if (statusString == "ANNULEE") {
    return UserActionPEStatus.CANCELLED;
  } else {
    return UserActionPEStatus.DONE;
  }
}