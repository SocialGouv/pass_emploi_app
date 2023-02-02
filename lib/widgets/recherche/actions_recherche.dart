import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/offre_emploi_filtres_page.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/offre_emploi_saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/filtre_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class ActionsRecherche extends StatelessWidget {
  final Function() onFiltreApplied;

  ActionsRecherche({required this.onFiltreApplied});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ActionsRechercheViewModel>(
      converter: (store) => ActionsRechercheViewModel.create(store),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, ActionsRechercheViewModel viewModel) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(begin: Offset(0.0, 1), end: Offset(0.0, 0)).animate(animation);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      switchInCurve: Curves.fastOutSlowIn,
      switchOutCurve: Curves.fastOutSlowIn,
      child: Wrap(
        key: UniqueKey(),
        alignment: WrapAlignment.center,
        spacing: Margins.spacing_base,
        runSpacing: Margins.spacing_base,
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
      ),
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
      if (value == true) onFiltreApplied();
    });
  }
}
