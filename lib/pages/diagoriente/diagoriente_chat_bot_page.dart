import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_chat_bot_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiagorienteChatBotPage extends StatelessWidget {
  final DiagorienteChatBotPageMode mode;

  const DiagorienteChatBotPage(this.mode);

  static MaterialPageRoute<void> materialPageRoute(DiagorienteChatBotPageMode mode) {
    return MaterialPageRoute(fullscreenDialog: true, builder: (context) => DiagorienteChatBotPage(mode));
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.diagorienteChatBot,
      child: StoreConnector<AppState, DiagorienteChatBotPageViewModel>(
        converter: (store) => DiagorienteChatBotPageViewModel.create(store, mode),
        builder: _builder,
        distinct: true,
      ),
    );
  }

  Widget _builder(BuildContext context, DiagorienteChatBotPageViewModel viewModel) {
    const backgroundColor = AppColors.grey100;
    final controller = WebViewController()
      ..setBackgroundColor(backgroundColor)
      ..loadRequest(Uri.parse(viewModel.url));

    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.diagorienteChatBotPageTitle, backgroundColor: backgroundColor),
      body: WebViewWidget(controller: controller),
    );
  }
}
