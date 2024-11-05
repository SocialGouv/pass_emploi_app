import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/app_initializer.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/wrappers/package_info_wrapper.dart';
import 'package:webview_flutter/webview_flutter.dart';

// TODO-CJE(04/11/24): remove file when feature deleted
enum CjePageSource { accueil, boite_a_outils, profil }

class CjePage extends StatelessWidget {
  final CjePageSource source;

  const CjePage(this.source);

  static MaterialPageRoute<void> materialPageRoute(CjePageSource source) => MaterialPageRoute(
        builder: (context) => CjePage(source),
        fullscreenDialog: true,
      );

  @override
  Widget build(BuildContext context) {
    final userId = StoreProvider.of<AppState>(context).state.user()!.id;
    return Tracker(
      tracking: "cje_webview/${source.toString().replaceAll("CjePageSource.", "")}",
      child: Scaffold(
        body: SafeArea(child: _BottomSheetWrapper(child: Center(child: _FutureBuilder(userId)))),
      ),
    );
  }
}

class _BottomSheetWrapper extends StatelessWidget {
  final Widget child;

  const _BottomSheetWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.primary),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: Navigator.of(context).pop,
                icon: Icon(
                  AppIcons.close_rounded,
                  size: Dimens.icon_size_m,
                  semanticLabel: Strings.close,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.radius_l),
                  topRight: Radius.circular(Dimens.radius_l),
                ),
                child: Material(color: Colors.white, child: child),
              ),
            )
          ],
        ),
      ],
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
  final String url;

  const _WebView(this.url);

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('login-widget')) {
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

class _Repository {
  final Dio _httpClient;
  final Crashlytics _crashlytics;

  _Repository(this._httpClient, this._crashlytics);

  Future<String?> getCjeToken(String userId) async {
    final url = "/jeunes/$userId/cje/token";
    try {
      final response = await _httpClient.get(url);
      return await _webViewUrl(response.data["widgetToken"] as String);
    } catch (e, stack) {
      _crashlytics.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<String> _webViewUrl(String token) async {
    return (await PackageInfoWrapper.getPackageName()).contains("staging")
        ? "https://cje-preprod.ovh.fabrique.social.gouv.fr/widget?widgetToken=$token"
        : "https://cje.fabrique.social.gouv.fr/widget?widgetToken=$token";
  }
}
