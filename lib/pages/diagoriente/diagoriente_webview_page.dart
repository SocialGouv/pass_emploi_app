import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_webview_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiagorienteWebviewPage extends StatefulWidget {
  final DiagorienteWebviewMode mode;

  const DiagorienteWebviewPage(this.mode);

  static MaterialPageRoute<void> materialPageRoute(DiagorienteWebviewMode mode) {
    return MaterialPageRoute(fullscreenDialog: true, builder: (context) => DiagorienteWebviewPage(mode));
  }

  @override
  State<DiagorienteWebviewPage> createState() => _DiagorienteWebviewPageState();
}

class _DiagorienteWebviewPageState extends State<DiagorienteWebviewPage> {
  bool showBoutons = false;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.diagorienteChatBot,
      child: StoreConnector<AppState, DiagorienteWebviewViewModel>(
        converter: (store) => DiagorienteWebviewViewModel.create(store, widget.mode),
        builder: _builder,
        rebuildOnChange: false,
      ),
    );
  }

  Widget _builder(BuildContext context, DiagorienteWebviewViewModel viewModel) {
    const backgroundColor = AppColors.grey100;

    final controller = WebViewController();
    final delegate = NavigationDelegate(onPageFinished: (_) => controller.addChatbotListener());
    controller
      ..setBackgroundColor(backgroundColor)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(delegate)
      ..loadRequest(Uri.parse(viewModel.url))
      ..addJavaScriptChannel(
        'cejHandler',
        onMessageReceived: (JavaScriptMessage message) {
          print("@@@ isJobsDrawerOpen=\"${message.message}\"");
          //TODO: ça part en boucle avec le set state car la page envoie un evt à chaque démarrage
          // setState(() {
          //   showBoutons = message.toString() == "true";
          // });
        },
      );

    return Scaffold(
      appBar: SecondaryAppBar(title: viewModel.appBarTitle, backgroundColor: backgroundColor),
      body: WebViewWidget(controller: controller),
      floatingActionButton: showBoutons ? _Boutons(controller) : null,
    );
  }
}

class _Boutons extends StatelessWidget {
  final WebViewController _controller;

  const _Boutons(this._controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryActionButton(
          label: 'Voir tous les résultats',
          onPressed: () async {
            await _controller.runJavaScript(
              'window.dispatchEvent(new CustomEvent("INCA_ChatbotInteract_Req", { detail: { target: "view_top_jobs_full" } }));',
            );
          },
        ),
        SizedBox(height: 8),
        PrimaryActionButton(
          label: 'Fermer le déroulé des métiers',
          onPressed: () async {
            await _controller.runJavaScript(
              'window.dispatchEvent(new CustomEvent("INCA_ChatbotInteract_Req", { detail: { target: "close_jobs_drawer" } }));',
            );
          },
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

extension _WebViewController on WebViewController {
  Future<void> addChatbotListener() async {
    runJavaScript('''window.addEventListener("INCA_ChatbotStateChange_Inf", (evt) => { 
              cejHandler.postMessage(evt.detail.isJobsDrawerOpen); 
          });''');
  }
}
