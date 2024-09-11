import 'package:equatable/equatable.dart';

class Preferences extends Equatable {
  final bool partageFavoris;
  final bool pushNotificationAlertesOffres;
  final bool pushNotificationMessages;
  final bool pushNotificationCreationActionConseiller;
  final bool pushNotificationRendezvousSessions;
  final bool pushNotificationRappelActions;

  Preferences({
    required this.partageFavoris,
    required this.pushNotificationAlertesOffres,
    required this.pushNotificationMessages,
    required this.pushNotificationCreationActionConseiller,
    required this.pushNotificationRendezvousSessions,
    required this.pushNotificationRappelActions,
  });

  factory Preferences.fromJson(dynamic json) {
    return Preferences(
      partageFavoris: json['partageFavoris'] as bool,
      pushNotificationAlertesOffres: json['alertesOffres'] as bool,
      pushNotificationMessages: json['messages'] as bool,
      pushNotificationCreationActionConseiller: json['creationActionConseiller'] as bool,
      pushNotificationRendezvousSessions: json['rendezVousSessions'] as bool,
      pushNotificationRappelActions: json['rappelActions'] as bool,
    );
  }

  @override
  List<Object?> get props => [
        partageFavoris,
        pushNotificationAlertesOffres,
        pushNotificationMessages,
        pushNotificationCreationActionConseiller,
        pushNotificationRendezvousSessions,
        pushNotificationRappelActions,
      ];
}
