import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_webview_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/apparition_animation.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
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
      tracking: mode.tracking(),
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
    return ApparitionAnimation(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_s),
        child: AnimatedBuilder(
            animation: diagorienteBottomButtonsNotifier,
            builder: (context, child) {
              switch (diagorienteBottomButtonsNotifier.state) {
                case DiagorienteBottomButtonsState.hidden:
                  return SizedBox.shrink();
                case DiagorienteBottomButtonsState.chatbot:
                  return _ChatBotButtons(
                      controller: _controller, diagorienteBottomButtonsNotifier: diagorienteBottomButtonsNotifier);
                case DiagorienteBottomButtonsState.metiers:
                  return _MetiersButton();
              }
            }),
      ),
    );
  }
}

class _ChatBotButtons extends StatelessWidget {
  final WebViewController _controller;
  final DiagorienteBottomButtonsNotifier diagorienteBottomButtonsNotifier;

  const _ChatBotButtons({
    required WebViewController controller,
    required this.diagorienteBottomButtonsNotifier,
  }) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryActionButton(
          label: Strings.diagorienteVoirplus,
          onPressed: () async {
            await _controller.runJavaScript(
              'window.dispatchEvent(new CustomEvent("INCA_ChatbotInteract_Req", { detail: { target: "view_top_jobs_full" } }));',
            );
            diagorienteBottomButtonsNotifier.changed(DiagorienteBottomButtonsState.metiers);
          },
        ),
        SizedBox(height: 8),
        SecondaryButton(
          label: Strings.diagorienteAffinerMesResultats,
          onPressed: () async {
            await _controller.runJavaScript(
              'window.dispatchEvent(new CustomEvent("INCA_ChatbotInteract_Req", { detail: { target: "close_jobs_drawer" } }));',
            );
          },
        ),
      ],
    );
  }
}

class _MetiersButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryActionButton(
        label: Strings.diagorienteTerminerEtRetournerAuProfil,
        onPressed: () async {
          Navigator.pop(context);
        },
      ),
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

enum DiagorienteBottomButtonsState { hidden, chatbot, metiers }

class DiagorienteBottomButtonsNotifier extends ChangeNotifier {
  DiagorienteBottomButtonsState state = DiagorienteBottomButtonsState.hidden;

  void changed(DiagorienteBottomButtonsState value) {
    state = value;
    notifyListeners();
  }
}

extension _DiagorienteWebviewMode on DiagorienteWebviewMode {
  String tracking() {
    return switch (this) {
      DiagorienteWebviewMode.chatbot => AnalyticsScreenNames.diagorienteChatBot,
      DiagorienteWebviewMode.favoris => AnalyticsScreenNames.diagorienteFavoris
    };
  }
}
