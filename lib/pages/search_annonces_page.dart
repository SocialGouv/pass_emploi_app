import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/immersion_search_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_search_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_search_page.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/carousel_button.dart';

enum IndexOf { OFFRES_EMPLOI, ALTERNANCE, SERVICE_CIVIQUE, IMMERSION }

class SearchAnnoncesPage extends StatefulWidget {
  const SearchAnnoncesPage() : super();

  @override
  State<SearchAnnoncesPage> createState() => _SearchAnnoncesPageState();
}

class _SearchAnnoncesPageState extends State<SearchAnnoncesPage> {
  IndexOf _selectedIndex = IndexOf.OFFRES_EMPLOI;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          SizedBox(width: Margins.spacing_base),
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
          SizedBox(width: Margins.spacing_base),
        ],
      ),
    );
  }

  Widget _content() {
    switch (_selectedIndex) {
      case IndexOf.OFFRES_EMPLOI:
        return OffreEmploiSearchPage(onlyAlternance: false);
      case IndexOf.ALTERNANCE:
        return OffreEmploiSearchPage(onlyAlternance: true);
      case IndexOf.IMMERSION:
        return ImmersionSearchPage();
      default:
        return ServiceCiviqueSearchPage();
    }
  }

  void _updateIndex(IndexOf index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
