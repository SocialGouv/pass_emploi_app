import 'package:pass_emploi_app/models/message.dart';

List<Message> modeDemoChat() => [
      Message(
        "Bonjour Paul, avez-vous commencé à  rechercher des entreprises pour effectuer une période d'immersion ?",
        DateTime.now().subtract(Duration(minutes: 40)),
        Sender.conseiller,
        MessageType.message,
        [],
      ),
      Message(
        "Bonjour, oui j'ai contacté Carrefour et on a rendez-vous la semaine prochaine !",
        DateTime.now().subtract(Duration(minutes: 34)),
        Sender.jeune,
        MessageType.message,
        [],
      ),
      Message(
        "Super ! Nous pouvons nous voir mercredi prochain à 11H00 pour préparer l'entretien si cela vous convient !",
        DateTime.now().subtract(Duration(minutes: 21)),
        Sender.conseiller,
        MessageType.message,
        [],
      ),
      Message(
        "Bonjour, je vous partage une offre d’emploi afin d’avoir votre avis",
        DateTime.now().subtract(Duration(minutes: 18)),
        Sender.jeune,
        MessageType.offre,
        [],
        "132WNLT",
        "Employé / Employée de rayon libre-service (H/F)",
        OffreType.emploi,
      ),
    ];
