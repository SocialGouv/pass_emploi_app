import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class MatomoLoggingPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => MatomoLoggingPage());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<String>>(
      builder: _buildBody,
      converter: (store) => store.state.matomoLoggingState.logs,
      distinct: true,
    );
  }

  Widget _buildBody(BuildContext context, List<String> logs) {
    return Scaffold(
      appBar: passEmploiAppBar(label: Strings.developerOptionMatomoPage, context: context),
      body: ListView.separated(
        padding: EdgeInsets.all(Margins.spacing_base),
        separatorBuilder: (_, index) => SepLine(Margins.spacing_s, Margins.spacing_s),
        itemCount: logs.length,
        itemBuilder: (context, index) => Text(logs[index], style: TextStyles.textMRegular),
      ),
    );
  }
}
