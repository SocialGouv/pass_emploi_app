import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/offre_emploi_filtres_page.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/offre_emploi_saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/filtre_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class ActionsRecherche extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ActionsRechercheViewModel>(
      converter: (store) => ActionsRechercheViewModel.create(store),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, ActionsRechercheViewModel viewModel) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        if (viewModel.withAlertButton)
          PrimaryActionButton(
            label: Strings.createAlert,
            drawableRes: Drawables.icAlert,
            rippleColor: AppColors.primaryDarken,
            heightPadding: 6,
            widthPadding: 6,
            iconSize: 16,
            onPressed: () => _onAlertButtonPressed(context),
          ),
        if (viewModel.withFiltreButton)
          FiltreButton.primary(
            filtresCount: viewModel.filtresCount,
            onPressed: () => _onFiltreButtonPressed(context),
          ),
      ],
    );
  }

  void _onAlertButtonPressed(BuildContext context) {
    showPassEmploiBottomSheet(
      context: context,
      // TODO-1353 only alternance
      builder: (context) => OffreEmploiSavedSearchBottomSheet(onlyAlternance: false),
    );
  }

  Future<void> _onFiltreButtonPressed(BuildContext context) {
    return Navigator.push(
      context,
      // TODO-1353 only alternance
      OffreEmploiFiltresPage.materialPageRoute(false),
    ).then((value) {
      if (value == true) {
        // TODO-1353 scroll behavior
        // _offsetBeforeLoading = 0;
        // if (_scrollController.hasClients) _scrollController.jumpTo(_offsetBeforeLoading);
      }
    });
  }
}
