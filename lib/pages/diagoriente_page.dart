import 'package:flutter/material.dart';
import 'package:pass_emploi_app/app_initializer.dart';
import 'package:pass_emploi_app/repositories/diagoriente_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiagorientePage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => DiagorientePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
        future: DiagorienteRepository(appDio).getChatBotUrl('ZKBAC'),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData) {
            final controller = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse(snapshot.data!));
            return WebViewWidget(controller: controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
