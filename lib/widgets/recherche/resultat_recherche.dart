import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';

class ResultatRecherche extends StatelessWidget {
  final Key listResultatKey;

  ResultatRecherche({required this.listResultatKey});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ResultatRechercheViewModel>(
      builder: _builder,
      converter: (store) => ResultatRechercheViewModel.create(store),
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, ResultatRechercheViewModel viewModel) {
    switch (viewModel.displayState) {
      case ResultatRechercheDisplayState.recherche:
        return _MessagePlaceholder(Strings.rechercheLancerUneRechercheHint);
      case ResultatRechercheDisplayState.empty:
        return _MessagePlaceholder(Strings.noContentError);
      case ResultatRechercheDisplayState.results:
        return _ResultatRecherche(key: listResultatKey, viewModel: viewModel);
    }
  }
}

class _MessagePlaceholder extends StatelessWidget {
  final String message;

  const _MessagePlaceholder(this.message);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(Drawables.icEmptyOffres),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
            child: Text(message, style: TextStyles.textBaseMedium, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}

class _ResultatRecherche extends StatefulWidget {
  final ResultatRechercheViewModel viewModel;

  const _ResultatRecherche({super.key, required this.viewModel});

  @override
  State<_ResultatRecherche> createState() => ResultatRechercheState();
}

class ResultatRechercheState extends State<_ResultatRecherche> {
  late ScrollController _scrollController;
  double _offsetBeforeLoading = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (widget.viewModel.withLoadMore && _scrollController.offset >= _scrollController.position.maxScrollExtent) {
        _offsetBeforeLoading = _scrollController.offset;
        widget.viewModel.onLoadMore();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _onDidBuild);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FavorisStateContext<OffreEmploi>(
      selectState: (store) => store.state.offreEmploiFavorisState,
      child: Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.only(top: Margins.spacing_base, bottom: 120),
          controller: _scrollController,
          itemBuilder: (context, index) => _buildItem(context, widget.viewModel.items[index]),
          separatorBuilder: (context, index) => const SizedBox(height: Margins.spacing_base),
          itemCount: widget.viewModel.items.length,
        ),
      ),
    );
  }

  void _onDidBuild() {
    if (_scrollController.hasClients) _scrollController.jumpTo(_offsetBeforeLoading);
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
    Navigator.push(
      context,
      // TODO: 1353 - only alternance
      //OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: widget.onlyAlternance),
      OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: false),
    );
  }

  void scrollToTop() {
    _offsetBeforeLoading = 0;
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }
}
