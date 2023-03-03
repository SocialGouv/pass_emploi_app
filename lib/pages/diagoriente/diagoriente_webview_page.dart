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

class DiagorienteWebviewPage extends StatelessWidget {
  final DiagorienteWebviewMode mode;
  DiagorienteWebviewPage(this.mode);

  static MaterialPageRoute<void> materialPageRoute(DiagorienteWebviewMode mode) {
    return MaterialPageRoute(fullscreenDialog: true, builder: (context) => DiagorienteWebviewPage(mode));
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.diagorienteChatBot,
      child: StoreConnector<AppState, DiagorienteWebviewViewModel>(
        converter: (store) => DiagorienteWebviewViewModel.create(store, mode),
        builder: _builder,
        rebuildOnChange: false,
      ),
    );
  }

  Widget _builder(BuildContext context, DiagorienteWebviewViewModel viewModel) {
    const backgroundColor = AppColors.grey100;
    final DiagorienteBottomButtonsNotifier diagorienteDrawer = DiagorienteBottomButtonsNotifier();
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
          diagorienteDrawer.changed(
              message.message == "true" ? DiagorienteBottomButtonsState.chatbot : DiagorienteBottomButtonsState.hidden);
        },
      );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: viewModel.appBarTitle, backgroundColor: backgroundColor),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: WebViewWidget(controller: controller)),
            _Boutons(controller, diagorienteDrawer),
          ],
        ),
      ),
    );
  }
}

class _Boutons extends StatelessWidget {
  final WebViewController _controller;
  final DiagorienteBottomButtonsNotifier diagorienteBottomButtonsNotifier;

  const _Boutons(this._controller, this.diagorienteBottomButtonsNotifier);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: diagorienteBottomButtonsNotifier,
        builder: (context, child) {
          switch (diagorienteBottomButtonsNotifier.state) {
            case DiagorienteBottomButtonsState.hidden:
              return SizedBox.shrink();
            case DiagorienteBottomButtonsState.chatbot:
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryActionButton(
                    label: 'Voir tous les résultats',
                    onPressed: () async {
                      await _controller.runJavaScript(
                        'window.dispatchEvent(new CustomEvent("INCA_ChatbotInteract_Req", { detail: { target: "view_top_jobs_full" } }));',
                      );
                      diagorienteBottomButtonsNotifier.changed(DiagorienteBottomButtonsState.metiers);
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
            case DiagorienteBottomButtonsState.metiers:
              return PrimaryActionButton(
                label: 'Terminer et retourner au profil',
                onPressed: () async {
                  Navigator.pop(context);
                },
              );
          }
        });
  }
}

extension _WebViewController on WebViewController {
  Future<void> addChatbotListener() async {
    runJavaScript('''window.addEventListener("INCA_ChatbotStateChange_Inf", (evt) => { 
              cejHandler.postMessage(evt.detail.isJobsDrawerOpen); 
          });''');
  }
}

enum DiagorienteBottomButtonsState { hidden, chatbot, metiers }

class DiagorienteBottomButtonsNotifier extends ChangeNotifier {
  DiagorienteBottomButtonsState state = DiagorienteBottomButtonsState.hidden;

  void changed(DiagorienteBottomButtonsState value) {
    state = value;
    notifyListeners();
  }
}
