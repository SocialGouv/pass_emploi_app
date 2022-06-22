import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step3_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/tags/status_tag.dart';

class CreateDemarcheStep3Page extends TraceableStatelessWidget {
  final String idDemarche;

  CreateDemarcheStep3Page._(this.idDemarche) : super(name: AnalyticsScreenNames.searchDemarcheStep3);

  static MaterialPageRoute<void> materialPageRoute(String idDemarche) {
    return MaterialPageRoute(builder: (context) => CreateDemarcheStep3Page._(idDemarche));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateDemarcheStep3ViewModel>(
      builder: _buildBody,
      converter: (store) => CreateDemarcheStep3ViewModel.create(store, idDemarche),
      distinct: true,
    );
  }

  Widget _buildBody(BuildContext context, CreateDemarcheStep3ViewModel viewModel) {
    return Scaffold(
      appBar: passEmploiAppBar(label: Strings.createDemarcheTitle, context: context),
      body: Padding(
        padding: const EdgeInsets.all(Margins.spacing_m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatutTag(
              backgroundColor: AppColors.accent2Lighten,
              textColor: AppColors.accent2,
              title: viewModel.pourquoi,
            ),
            Text(viewModel.quoi),
          ],
        ),
      ),
    );
  }
}
