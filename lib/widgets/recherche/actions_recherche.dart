import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/filtre_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:redux/redux.dart';

class ActionsRecherche extends StatelessWidget {
  final ActionsRechercheViewModel Function(Store<AppState> store) buildViewModel;
  final Widget Function() buildAlertBottomSheet;
  final Route<bool>? Function() buildFiltresMaterialPageRoute;
  final Function() onFiltreApplied;

  ActionsRecherche({
    required this.buildViewModel,
    required this.buildAlertBottomSheet,
    required this.buildFiltresMaterialPageRoute,
    required this.onFiltreApplied,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ActionsRechercheViewModel>(
      converter: buildViewModel,
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
              icon: AppIcons.notifications_rounded,
              rippleColor: AppColors.primaryDarken,
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
    showPassEmploiBottomSheet(context: context, builder: (_) => buildAlertBottomSheet());
  }

  Future<void> _onFiltreButtonPressed(BuildContext context) {
    final route = buildFiltresMaterialPageRoute();
    if (route == null) return Future(() => {});
    return Navigator.push(context, route).then((value) {
      if (value == true) onFiltreApplied();
    });
  }
}
