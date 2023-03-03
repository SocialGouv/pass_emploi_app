import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_webview_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiagorienteWebviewPage extends StatelessWidget {
  final DiagorienteWebviewMode mode;

  const DiagorienteWebviewPage(this.mode);

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
    final controller = WebViewController()
      ..setBackgroundColor(backgroundColor)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(viewModel.url));

    return Scaffold(
      appBar: SecondaryAppBar(title: viewModel.appBarTitle, backgroundColor: backgroundColor),
      body: WebViewWidget(controller: controller),
    );
  }
}
