import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/pages/immersion/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_favoris_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/store_extensions.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/favori_card.dart';
import 'package:pass_emploi_app/widgets/dashed_box.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

class AccueilFavoris extends StatelessWidget {
  final AccueilFavorisItem item;

  AccueilFavoris(this.item);

  @override
  Widget build(BuildContext context) {
    final hasContent = item.favoris.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LargeSectionTitle(Strings.accueilMesFavorisSection),
        SizedBox(height: Margins.spacing_base),
        if (hasContent) _AvecFavoris(item),
        if (!hasContent) _SansFavori(),
      ],
    );
  }
}

class _AvecFavoris extends StatelessWidget {
  final AccueilFavorisItem item;

  _AvecFavoris(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...item.favoris.map((favori) => _FavorisCard(favori)),
        SizedBox(height: Margins.spacing_s),
        SecondaryButton(label: Strings.accueilVoirMesFavoris, onPressed: () => _goToFavoris(context)),
      ],
    );
  }

  void _goToFavoris(BuildContext context) {
    Navigator.push(context, OffreFavorisPage.materialPageRoute());
  }
}

class _SansFavori extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Icon(
              AppIcons.favorite_rounded,
              color: AppColors.accent2,
              size: 40,
            ),
          ),
          SizedBox(height: Margins.spacing_base),
          Center(
            child: Text(
              Strings.accueilPasDeFavorisDescription,
              style: TextStyles.textBaseMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: Margins.spacing_base),
          PrimaryActionButton(
            label: Strings.accueilPasDeFavorisBouton,
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

class _FavorisCard extends StatelessWidget {
  final Favori favori;

  _FavorisCard(this.favori);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FavoriCard(
          title: favori.titre,
          company: favori.organisation,
          place: favori.localisation,
          bottomTip: Strings.voirLeDetailCard,
          offreType: favori.type,
          onTap: () => _goToFavori(context, favori),
        ),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }

  MaterialPageRoute<void> _route(Favori favori) {
    switch (favori.type) {
      case OffreType.emploi:
        return OffreEmploiDetailsPage.materialPageRoute(
          favori.id,
          fromAlternance: false,
          popPageWhenFavoriIsRemoved: true,
        );
      case OffreType.alternance:
        return OffreEmploiDetailsPage.materialPageRoute(
          favori.id,
          fromAlternance: true,
          popPageWhenFavoriIsRemoved: true,
        );
      case OffreType.immersion:
        return ImmersionDetailsPage.materialPageRoute(favori.id, popPageWhenFavoriIsRemoved: true);
      case OffreType.serviceCivique:
        return ServiceCiviqueDetailPage.materialPageRoute(favori.id, true);
    }
  }

  void _goToFavori(BuildContext context, Favori favori) {
    Navigator.push(context, _route(favori));
  }
}
