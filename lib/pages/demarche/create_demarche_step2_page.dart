import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_personnalisee_page.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step2_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/demarche_du_referentiel_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class CreateDemarcheStep2Page extends TraceableStatelessWidget {
  CreateDemarcheStep2Page._() : super(name: 'TODO-724');

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CreateDemarcheStep2Page._());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateDemarcheStep2ViewModel>(
      builder: _buildBody,
      converter: (store) => CreateDemarcheStep2ViewModel.create(store),
      distinct: true,
    );
  }

  Widget _buildBody(BuildContext context, CreateDemarcheStep2ViewModel viewModel) {
    return Scaffold(
      appBar: passEmploiAppBar(label: Strings.createDemarcheTitle, context: context),
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
            return DemarcheDuReferentielCard(indexOfDemarche: item.indexOfDemarche);
          }
          return SecondaryButton(
            label: Strings.createDemarchePersonnalisee,
            onPressed: () {
              pushAndTrackBack(
                context,
                CreateDemarchePersonnaliseePage.materialPageRoute(),
                'TODO-724',
              );
            },
          );
        },
      ),
    );
  }
}
