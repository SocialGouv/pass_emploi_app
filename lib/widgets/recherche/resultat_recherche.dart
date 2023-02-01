import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';

class ResultatRecherche extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ResultatRechercheViewModel>(
      builder: _builder,
      converter: (store) => ResultatRechercheViewModel.create(store),
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, ResultatRechercheViewModel viewModel) {
    final items = viewModel.items;
    if (items == null) {
      return Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Text("Faites votre recherche !"));
    } else if (items.isEmpty) {
      return Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Text("Aucun résultat"));
    } else {
      return FavorisStateContext<OffreEmploi>(
        selectState: (store) => store.state.offreEmploiFavorisState,
        child: Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: Margins.spacing_base, bottom: 120),
            //controller: _scrollController,
            itemBuilder: (context, index) => _buildItem(context, items[index]),
            separatorBuilder: (context, index) => const SizedBox(height: Margins.spacing_base),
            itemCount: items.length,
          ),
        ),
      );
    }
  }

  Widget _buildItem(BuildContext context, OffreEmploiItemViewModel item) {
    return DataCard<OffreEmploi>(
      titre: item.title,
      sousTitre: item.companyName,
      lieu: item.location,
      id: item.id,
      dataTag: [item.contractType, item.duration ?? ''],
      onTap: () => _showOffreEmploiDetailsPage(context, item.id),
      from: OffrePage.emploiResults, // TODO: 1353 - only alternance
      //from: widget.onlyAlternance ? OffrePage.alternanceResults : OffrePage.emploiResults,
    );
  }

  void _showOffreEmploiDetailsPage(BuildContext context, String offreId) {
    // TODO: 1353 - Scroll
    //_offsetBeforeLoading = _scrollController.offset;
    Navigator.push(
      context,
      // TODO: 1353 - only alternance
      //OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: widget.onlyAlternance),
      OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: false),
    ); //.then((_) => _scrollController.jumpTo(_offsetBeforeLoading));
  }
}
