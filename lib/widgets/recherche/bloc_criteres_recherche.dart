import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_criteres_cherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/utils/keyboard.dart';
import 'package:pass_emploi_app/widgets/customized_flutter_widgets/cej_expansion_tile.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_bandeau.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recherche_contenu.dart';

class BlocCriteresRecherche extends StatefulWidget {
  @override
  State<BlocCriteresRecherche> createState() => _BlocCriteresRechercheState();
}

class _BlocCriteresRechercheState extends State<BlocCriteresRecherche> {
  final _expansionTileKey = GlobalKey();
  int? _criteresActifsCount;
  LocationViewModel? _selectedLocationViewModel;
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCriteresRechercheViewModel>(
      converter: (store) => BlocCriteresRechercheViewModel.create(store),
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

  Widget _builder(BuildContext context, BlocCriteresRechercheViewModel viewModel) {
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
              CriteresRechercheContenu(
                onKeywordChanged: (keyword) {
                  _keyword = keyword;
                  setState(() => _updateCriteresActifsCount());
                },
                onSelectLocationViewModel: (locationVM) {
                  _selectedLocationViewModel = locationVM;
                  setState(() => _updateCriteresActifsCount());
                },
                getPreviouslySelectedTitle: () => _selectedLocationViewModel?.title,
                onRechercheButtonPressed: () {
                  // TODO: 1353 - only alternance
                  viewModel.onSearchingRequest(_keyword, _selectedLocationViewModel?.location, false);
                  Keyboard.dismiss(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateCriteresActifsCount() {
    int criteresActifsCount = 0;
    criteresActifsCount += _keyword.isNotEmpty ? 1 : 0;
    criteresActifsCount += _selectedLocationViewModel != null ? 1 : 0;
    _criteresActifsCount = criteresActifsCount;
  }
}
