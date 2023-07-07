import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/pages/saved_search_page.dart';
import 'package:pass_emploi_app/pages/suggestions_recherche/suggestions_recherche_list_page.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/utils/store_extensions.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/dashed_box.dart';
import 'package:pass_emploi_app/widgets/saved_search_card.dart';
import 'package:pass_emploi_app/widgets/textes.dart';
import 'package:pass_emploi_app/widgets/voir_suggestions_recherche_bandeau.dart';

class AccueilAlertes extends StatelessWidget {
  final AccueilAlertesItem item;

  AccueilAlertes(this.item);

  @override
  Widget build(BuildContext context) {
    final hasContent = item.savedSearches.isNotEmpty;
    return SavedSearchNavigator(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LargeSectionTitle(Strings.accueilMesAlertesSection),
          VoirSuggestionsRechercheBandeau(
            padding: EdgeInsets.only(top: Margins.spacing_base),
            onTapShowSuggestions: () {
              PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.accueilSuggestionsListe);
              Navigator.push(context, SuggestionsRechercheListPage.materialPageRoute());
            },
          ),
          SizedBox(height: Margins.spacing_base),
          if (hasContent) _AvecAlertes(item),
          if (!hasContent) _SansAlerte(),
        ],
      ),
    );
  }
}

class _AvecAlertes extends StatelessWidget {
  final AccueilAlertesItem item;

  _AvecAlertes(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...item.savedSearches.map((search) => _AlerteCard(search)),
        SizedBox(height: Margins.spacing_s),
        SecondaryButton(label: Strings.accueilVoirMesAlertes, onPressed: () => goToSavedSearches(context)),
      ],
    );
  }

  void goToSavedSearches(BuildContext context) {
    Navigator.push(context, SavedSearchPage.materialPageRoute());
  }
}

class _SansAlerte extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Icon(
              AppIcons.notifications_rounded,
              color: AppColors.accent1,
              size: 40,
            ),
          ),
          SizedBox(height: Margins.spacing_base),
          Center(
            child: Text(
              Strings.accueilPasDalerteDescription,
              style: TextStyles.textBaseMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: Margins.spacing_base),
          PrimaryActionButton(
            label: Strings.accueilPasDalerteBouton,
            onPressed: () => goToRecherche(context),
          ),
        ],
      ),
    );
  }

  void goToRecherche(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatchRechercheDeeplink();
  }
}

class _AlerteCard extends StatelessWidget {
  final SavedSearch savedSearch;

  _AlerteCard(this.savedSearch);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SavedSearchCard(savedSearch),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}
