import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step2_page.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step1_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class CreateDemarcheStep1Page extends TraceableStatefulWidget {
  CreateDemarcheStep1Page._() : super(name: "TODO-724");

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CreateDemarcheStep1Page._());
  }

  @override
  State<CreateDemarcheStep1Page> createState() => _CreateDemarcheStep1PageState();
}

class _CreateDemarcheStep1PageState extends State<CreateDemarcheStep1Page> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateDemarcheStep1ViewModel>(
      builder: _buildBody,
      converter: (store) => CreateDemarcheStep1ViewModel.create(store),
      onDidChange: (oldVm, newVm) {
        if (newVm.shouldGoToStep2) {
          widget.pushAndTrackBack(context, CreateDemarcheStep2Page.materialPageRoute(), 'TODO-724');
        }
      },
      onDispose: (store) => store.dispatch(SearchDemarcheResetAction()),
      distinct: true,
    );
  }

  Scaffold _buildBody(BuildContext context, CreateDemarcheStep1ViewModel viewModel) {
    return Scaffold(
      appBar: passEmploiAppBar(label: Strings.createDemarcheTitle, context: context),
      body: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: Column(
          children: [
            Text('Saisissez une démarche'),
            Text('Renseigner un mot clé pour rechercher une démarche à créer'),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.contentColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
              ),
            ),
            if (viewModel.displayState.isFailure()) Text('Erreur'),
            PrimaryActionButton(
              label: 'Rechercher une démarche',
              onPressed: viewModel.displayState.isLoading() ? null : () => viewModel.onSearchDemarche(_query),
            ),
          ],
        ),
      ),
    );
  }
}
