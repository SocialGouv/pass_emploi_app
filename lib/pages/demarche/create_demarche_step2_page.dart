import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/demarche/create_custom_demarche.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step3_page.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step2_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/demarche_du_referentiel_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class CreateDemarcheStep2Page extends StatelessWidget {
  const CreateDemarcheStep2Page({super.key, required this.source});

  static MaterialPageRoute<String?> materialPageRoute({required DemarcheSource source}) {
    return MaterialPageRoute(builder: (context) => CreateDemarcheStep2Page(source: source));
  }

  final DemarcheSource source;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.searchDemarcheStep2,
      child: StoreConnector<AppState, CreateDemarcheStep2ViewModel>(
        builder: _buildBody,
        converter: (store) => CreateDemarcheStep2ViewModel.create(store, source),
        distinct: true,
      ),
    );
  }

  Widget _buildBody(BuildContext context, CreateDemarcheStep2ViewModel viewModel) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.createDemarcheTitle),
      body: ListView.separated(
        itemCount: viewModel.items.length,
        padding: const EdgeInsets.all(Margins.spacing_m),
        separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
        itemBuilder: (context, index) {
          final item = viewModel.items[index];
          if (item is CreateDemarcheStep2TitleItem) {
            return Text(item.title, style: TextStyles.textBaseMedium);
          }
          if (item is CreateDemarcheStep2DemarcheFoundItem) {
            return DemarcheDuReferentielCard(
              source: source,
              idDemarche: item.idDemarche,
              onTap: () {
                Navigator.push(context, CreateDemarcheStep3Page.materialPageRoute(item.idDemarche, source))
                    .then((value) {
                  // forward result to previous page
                  if (value != null) Navigator.pop(context, value);
                });
              },
            );
          }
          return CreateCustomDemarche();
        },
      ),
    );
  }
}
