import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:uuid/uuid.dart';

List<Message> modeDemoChat() => [
      Message(
        id: Uuid().v4(),
        content:
            "Bonjour Paul, avez-vous commencé à  rechercher des entreprises pour effectuer une période d'immersion ?",
        creationDate: DateTime.now().subtract(Duration(minutes: 40)),
        sentBy: Sender.conseiller,
        type: MessageType.message,
        sendingStatus: MessageSendingStatus.sent,
        contentStatus: MessageContentStatus.content,
        pieceJointes: [],
      ),
      Message(
        id: Uuid().v4(),
        content: "Bonjour, oui j'ai contacté Carrefour et on a rendez-vous la semaine prochaine !",
        creationDate: DateTime.now().subtract(Duration(minutes: 34)),
        sentBy: Sender.jeune,
        type: MessageType.message,
        sendingStatus: MessageSendingStatus.sent,
        contentStatus: MessageContentStatus.content,
        pieceJointes: [],
      ),
      Message(
        id: Uuid().v4(),
        content:
            "Super ! Nous pouvons nous voir mercredi prochain à 11H00 pour préparer l'entretien si cela vous convient !",
        creationDate: DateTime.now().subtract(Duration(minutes: 21)),
        sentBy: Sender.conseiller,
        type: MessageType.message,
        sendingStatus: MessageSendingStatus.sent,
        contentStatus: MessageContentStatus.content,
        pieceJointes: [],
      ),
      Message(
        id: Uuid().v4(),
        content: "Bonjour, je vous partage une offre d’emploi afin d’avoir votre avis",
        creationDate: DateTime.now().subtract(Duration(minutes: 18)),
        sentBy: Sender.jeune,
        type: MessageType.offre,
        sendingStatus: MessageSendingStatus.sent,
        contentStatus: MessageContentStatus.content,
        pieceJointes: [],
        offre: Offre(
          "132WNLT",
          "Employé / Employée de rayon libre-service (H/F)",
          OffreType.emploi,
        ),
      )
    ];
