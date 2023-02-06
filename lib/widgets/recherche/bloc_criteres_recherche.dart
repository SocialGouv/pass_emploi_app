import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_criteres_cherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/widgets/customized_flutter_widgets/cej_expansion_tile.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_bandeau.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_emploi_contenu.dart';

class BlocCriteresRecherche<Result> extends StatefulWidget {
  final RechercheState Function(AppState) rechercheState;

  BlocCriteresRecherche({required this.rechercheState});

  @override
  State<BlocCriteresRecherche<Result>> createState() => _BlocCriteresRechercheState<Result>();
}

class _BlocCriteresRechercheState<Result> extends State<BlocCriteresRecherche<Result>> {
  final _expansionTileKey = GlobalKey();
  int? _criteresActifsCount;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCriteresRechercheViewModel<Result>>(
      converter: (store) => BlocCriteresRechercheViewModel.create(store, widget.rechercheState),
      onDidChange: (previousViewModel, currentViewModel) {
        if (!currentViewModel.isOpen) {
          final currentState = _expansionTileKey.currentState;
          if (currentState is CejExpansionTileState) {
            currentState.closeExpansion();
          }
        }
      },
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, BlocCriteresRechercheViewModel<Result> viewModel) {
    return Material(
      elevation: 16, //TODO Real box shadow ?
      borderRadius: BorderRadius.circular(Dimens.radius_base),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: CejExpansionTile(
            key: _expansionTileKey,
            onExpansionChanged: viewModel.onExpansionChanged,
            maintainState: true,
            backgroundColor: Colors.white,
            textColor: AppColors.contentColor,
            iconColor: AppColors.primary,
            collapsedBackgroundColor: AppColors.primary,
            collapsedTextColor: Colors.white,
            collapsedIconColor: Colors.white,
            leading: Icon(Icons.search),
            title: CriteresRechercheBandeau(criteresActifsCount: _criteresActifsCount ?? 0),
            initiallyExpanded: viewModel.isOpen,
            children: [
              CriteresRechercheEmploiContenu(
                onNumberOfCriteresChanged: (number) {
                  setState(() => _criteresActifsCount = number);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
