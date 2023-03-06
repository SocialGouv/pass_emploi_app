import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/recherches_recentes/recherches_recentes_actions.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/presentation/recherches_recentes_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';

class RecherchesRecentes extends StatelessWidget {
  const RecherchesRecentes({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RecherchesRecentesViewModel>(
      onInit: (store) => store.dispatch(RecherchesRecentesRequestAction()),
      converter: (store) => RecherchesRecentesViewModel.create(store),
      builder: (context, viewModel) {
        return _Body(viewModel.rechercheRecente);
      },
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.rechercheRecente);
  final SavedSearch? rechercheRecente;

  @override
  Widget build(BuildContext context) {
    if (rechercheRecente == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Strings.derniereRecherche,
          style: TextStyles.textMRegular,
        ),
        SizedBox(height: Margins.spacing_base),
        _buildFavorisCard(context, rechercheRecente!),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}

Widget _buildFavorisCard(BuildContext context, SavedSearch savedSearch) {
  if (savedSearch is OffreEmploiSavedSearch) {
    return _buildEmploiAndAlternanceCard(context, savedSearch);
  } else if (savedSearch is ImmersionSavedSearch) {
    return _buildImmersionCard(context, savedSearch);
  } else if (savedSearch is ServiceCiviqueSavedSearch) {
    return _buildServiceCiviqueCard(context, savedSearch);
  } else {
    return Container();
  }
}

Widget _buildEmploiAndAlternanceCard(BuildContext context, OffreEmploiSavedSearch offreEmploi) {
  return FavoriCard(
    solutionType: offreEmploi.onlyAlternance ? SolutionType.Alternance : SolutionType.OffreEmploi,
    title: offreEmploi.title,
    place: offreEmploi.location?.libelle,
    bottomTip: Strings.voirResultatsSuggestion,
  );
}

Widget _buildImmersionCard(
  BuildContext context,
  ImmersionSavedSearch savedSearchsImmersion,
) {
  return FavoriCard(
    solutionType: SolutionType.Immersion,
    title: savedSearchsImmersion.title,
    place: savedSearchsImmersion.ville,
    bottomTip: Strings.voirResultatsSuggestion,
  );
}

Widget _buildServiceCiviqueCard(
  BuildContext context,
  ServiceCiviqueSavedSearch savedSearchsServiceCivique,
) {
  return FavoriCard(
    solutionType: SolutionType.ServiceCivique,
    title: savedSearchsServiceCivique.titre,
    place: savedSearchsServiceCivique.ville?.isNotEmpty == true ? savedSearchsServiceCivique.ville : null,
    bottomTip: Strings.voirResultatsSuggestion,
  );
}
