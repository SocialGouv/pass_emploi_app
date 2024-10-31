import 'package:flutter/material.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/log.dart';
import 'package:webview_flutter/webview_flutter.dart';

const url = "URL";

class CjePage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => CjePage());

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            Log.i('[CJE web view] Navigate to ${request.url}');
            if (request.url.contains('signup') || request.url.contains('login-widget')) {
              final navigator = Navigator.of(context);
              launchExternalUrl(request.url).then((value) => navigator.pop());
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
