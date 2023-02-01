import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_critereres_cherche_contenu_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_critereres_cherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class CriteresRecherche extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCriteresRechercheViewModel>(
      converter: (store) => BlocCriteresRechercheViewModel.create(store),
      builder: (context, vm) {
        return Column(
          children: [
            Material(
              elevation: 16, //TODO Real box shadow ?
              borderRadius: BorderRadius.circular(Dimens.radius_s),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.radius_s),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    key: UniqueKey(),
                    // required to force rebuild with new vm.isOpen value
                    collapsedBackgroundColor: AppColors.primary,
                    collapsedIconColor: Colors.white,
                    iconColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    collapsedTextColor: Colors.white,
                    title: _CritereRechercheBandeau(),
                    initiallyExpanded: vm.isOpen,
                    children: [_CritereRechercheContenu()],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      distinct: true,
    );
  }
}

class _CritereRechercheBandeau extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      // TODO: 1353 MAJ des critères
      "(0) critères actifs",
      // TODO: 1353 Créer un bon TextStyle à part
      style: TextStyle(
        fontFamily: 'Marianne',
        fontSize: FontSizes.medium,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CritereRechercheContenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCriteresRechercheContenuViewModel>(
      converter: (store) => BlocCriteresRechercheContenuViewModel.create(store),
      builder: (context, vm) {
        return Column(
          children: [
            if (vm.displayState == DisplayState.FAILURE) Text("failure"),
            if (vm.displayState == DisplayState.LOADING) Text("loading"),
            PrimaryActionButton(
              label: "Rechercher",
              onPressed: vm.displayState == DisplayState.LOADING ? null : () => vm.onSearch("toto"),
            )
          ],
        );
      },
      distinct: true,
    );
  }
}
