import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/filtre_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:redux/redux.dart';

class ActionsRecherche extends StatelessWidget {
  final ActionsRechercheViewModel Function(Store<AppState> store) buildViewModel;
  final Widget Function() buildAlertBottomSheet;
  final Future<bool?>? Function() buildFiltresBottomSheet;
  final Function() onFiltreApplied;

  ActionsRecherche({
    required this.buildViewModel,
    required this.buildAlertBottomSheet,
    required this.buildFiltresBottomSheet,
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
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: Margins.spacing_base,
      runSpacing: Margins.spacing_base,
      children: [
        if (viewModel.withAlertButton)
          PrimaryActionButton(
            label: Strings.createAlert,
            icon: AppIcons.notifications_rounded,
            rippleColor: AppColors.primaryDarken,
            iconSize: Dimens.icon_size_base,
            onPressed: () => _onAlertButtonPressed(context),
          ),
        if (viewModel.withFiltreButton)
          FiltreButton(
            filtresCount: viewModel.filtresCount,
            onPressed: () => _onFiltreButtonPressed(context),
          ),
      ],
    );
  }

  void _onAlertButtonPressed(BuildContext context) {
    showPassEmploiBottomSheet(context: context, builder: (_) => buildAlertBottomSheet());
  }

  Future<void> _onFiltreButtonPressed(BuildContext context) {
    final bottomSheet = buildFiltresBottomSheet();
    if (bottomSheet == null) return Future(() => {});
    return bottomSheet.then((value) {
      if (value == true) onFiltreApplied();
    });
  }
}
