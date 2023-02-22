import 'package:flutter/material.dart';
import 'package:pass_emploi_app/app_initializer.dart';
import 'package:pass_emploi_app/repositories/diagoriente_repository.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiagorientePage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => DiagorientePage());

  final controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: PrimaryActionButton(
        label: 'clic',
        onPressed: () => controller.runJavaScript(
          'window.dispatchEvent(new CustomEvent("INCA_ChatbotInteract_Req", { detail: { target: view_top_jobs_full } }));',
        ),
      ),
      body: FutureBuilder<String?>(
        future: DiagorienteRepository(appDio).getChatBotUrl('ZKBAC'),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData) {
            controller
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..addJavaScriptChannel(
                'messageHandler',
                onMessageReceived: (JavaScriptMessage message) {
                  print("####### message from the web view=\"${message.message}\"");
                },
              )
              ..loadRequest(Uri.parse(snapshot.data!))
              ..runJavaScript(
                'window.addEventListener("INCA_ChatbotStateChange_Inf", (evt) => { messageHandler.postMessage(evt); });',
              );
            return WebViewWidget(controller: controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
