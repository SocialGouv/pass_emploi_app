import 'package:pass_emploi_app/models/message.dart';

List<Message> modeDemoChat() => [
      Message(
        "Hello !",
        DateTime.now().subtract(Duration(minutes: 34)),
        Sender.jeune,
        MessageType.message,
      ),
      Message(
        " Bonjour Monsieur",
        DateTime.now().subtract(Duration(minutes: 30)),
        Sender.conseiller,
        MessageType.message,
      )
    ];
