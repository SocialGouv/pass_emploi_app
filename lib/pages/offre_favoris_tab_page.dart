import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/pages/favoris/immersion_favoris_page.dart';
import 'package:pass_emploi_app/pages/favoris/offre_emploi_favoris_page.dart';
import 'package:pass_emploi_app/pages/favoris/service_civique_favoris_page.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/carousel_button.dart';

enum IndexOf { OFFRES_EMPLOI, ALTERNANCE, SERVICE_CIVIQUE, IMMERSION }

class OffreFavorisTabPage extends StatefulWidget {
  @override
  State<OffreFavorisTabPage> createState() => _OffreFavorisTabPageState();
}

class _OffreFavorisTabPageState extends State<OffreFavorisTabPage> {
  IndexOf _selectedIndex = IndexOf.OFFRES_EMPLOI;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: Margins.spacing_m),
          _carousel(),
          _content(),
        ],
      ),
    );
  }

  Widget _carousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: Margins.spacing_base),
          CarouselButton(
            isActive: _selectedIndex == IndexOf.OFFRES_EMPLOI,
            onPressed: () => _updateIndex(IndexOf.OFFRES_EMPLOI),
            label: Strings.offresEmploiButton,
          ),
          SizedBox(width: Margins.spacing_base),
          CarouselButton(
            isActive: _selectedIndex == IndexOf.ALTERNANCE,
            onPressed: () => _updateIndex(IndexOf.ALTERNANCE),
            label: Strings.alternanceButton,
          ),
          SizedBox(width: 12),
          CarouselButton(
            isActive: _selectedIndex == IndexOf.SERVICE_CIVIQUE,
            onPressed: () => _updateIndex(IndexOf.SERVICE_CIVIQUE),
            label: Strings.serviceCiviqueButton,
          ),
          SizedBox(width: Margins.spacing_base),
          CarouselButton(
            isActive: _selectedIndex == IndexOf.IMMERSION,
            onPressed: () => _updateIndex(IndexOf.IMMERSION),
            label: Strings.immersionButton,
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _content() {
    switch (_selectedIndex) {
      case IndexOf.OFFRES_EMPLOI:
        return OffreEmploiFavorisPage(onlyAlternance: false);
      case IndexOf.ALTERNANCE:
        return OffreEmploiFavorisPage(onlyAlternance: true);
      case IndexOf.IMMERSION:
        return ImmersionFavorisPage();
      default:
        return ServiceCiviqueFavorisPage();
    }
  }

  void _updateIndex(IndexOf index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
