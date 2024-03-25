import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:uuid/uuid.dart';

List<Message> modeDemoChat() => [
      Message(
        Uuid().v4(),
        "Bonjour Paul, avez-vous commencé à  rechercher des entreprises pour effectuer une période d'immersion ?",
        DateTime.now().subtract(Duration(minutes: 40)),
        Sender.conseiller,
        MessageType.message,
        MessageSendingStatus.sent,
        MessageContentStatus.content,
        [],
      ),
      Message(
        Uuid().v4(),
        "Bonjour, oui j'ai contacté Carrefour et on a rendez-vous la semaine prochaine !",
        DateTime.now().subtract(Duration(minutes: 34)),
        Sender.jeune,
        MessageType.message,
        MessageSendingStatus.sent,
        MessageContentStatus.content,
        [],
      ),
      Message(
        Uuid().v4(),
        "Super ! Nous pouvons nous voir mercredi prochain à 11H00 pour préparer l'entretien si cela vous convient !",
        DateTime.now().subtract(Duration(minutes: 21)),
        Sender.conseiller,
        MessageType.message,
        MessageSendingStatus.sent,
        MessageContentStatus.content,
        [],
      ),
      Message(
        Uuid().v4(),
        "Bonjour, je vous partage une offre d’emploi afin d’avoir votre avis",
        DateTime.now().subtract(Duration(minutes: 18)),
        Sender.jeune,
        MessageType.offre,
        MessageSendingStatus.sent,
        MessageContentStatus.content,
        [],
        Offre(
          "132WNLT",
          "Employé / Employée de rayon libre-service (H/F)",
          OffreType.emploi,
        ),
      )
    ];
