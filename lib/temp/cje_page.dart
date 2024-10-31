import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/app_initializer.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/log.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CjePage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => CjePage());

  @override
  Widget build(BuildContext context) {
    final userId = StoreProvider.of<AppState>(context).state.user()!.id;
    return Scaffold(
      body: SafeArea(child: Center(child: _FutureBuilder(userId))),
    );
  }
}

class _FutureBuilder extends StatefulWidget {
  final String userId;

  const _FutureBuilder(this.userId);

  @override
  State<_FutureBuilder> createState() => _FutureBuilderState();
}

class _FutureBuilderState extends State<_FutureBuilder> {
  Future<String?>? _tokenFuture;

  @override
  void initState() {
    _tokenFuture = _getFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _tokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Retry(
              Strings.miscellaneousErrorRetry,
              () {
                _tokenFuture = _getFuture();
                setState(() {});
              },
            );
          } else {
            return _WebView(snapshot.data as String);
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<String?> _getFuture() {
    final repository = _Repository(AppInitializer.dio, AppInitializer.firebaseCrashlytics);
    return repository.getCjeToken(widget.userId);
  }
}

class _WebView extends StatelessWidget {
  final String token;

  const _WebView(this.token);

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
      // TODO-CJE(31/10/24): replace with conditional prod/preprod url
      ..loadRequest(Uri.parse("https://cje-preprod.ovh.fabrique.social.gouv.fr/widget?widgetToken=$token"));
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}

class _Repository {
  final Dio _httpClient;
  final Crashlytics _crashlytics;

  _Repository(this._httpClient, this._crashlytics);

  Future<String?> getCjeToken(String userId) async {
    final url = "/jeunes/$userId/cje/token";
    try {
      final response = await _httpClient.get(url);
      return response.data["widgetToken"] as String;
    } catch (e, stack) {
      _crashlytics.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
