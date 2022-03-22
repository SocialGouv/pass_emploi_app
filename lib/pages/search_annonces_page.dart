import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/immersion_search_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_search_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_search_page.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/carousel_button.dart';

const int _indexOfOffresEmploi = 0;
const int _indexOfAlternance = 1;
const int _indexOfImmersion = 2;
const int _indexOfServiceCivique = 3;

class SearchAnnoncesPage extends StatefulWidget {
  const SearchAnnoncesPage() : super();

  @override
  State<SearchAnnoncesPage> createState() => _SearchAnnoncesPageState();
}

class _SearchAnnoncesPageState extends State<SearchAnnoncesPage> {
  int _selectedIndex = 0;

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
            isActive: _selectedIndex == _indexOfOffresEmploi,
            onPressed: () => _updateIndex(_indexOfOffresEmploi),
            label: Strings.offresEmploiButton,
          ),
          SizedBox(width: Margins.spacing_base),
          CarouselButton(
            isActive: _selectedIndex == _indexOfAlternance,
            onPressed: () => _updateIndex(_indexOfAlternance),
            label: Strings.alternanceButton,
          ),
          SizedBox(width: Margins.spacing_base),
          CarouselButton(
            isActive: _selectedIndex == _indexOfImmersion,
            onPressed: () => _updateIndex(_indexOfImmersion),
            label: Strings.immersionButton,
          ),
          SizedBox(width: Margins.spacing_base),
          CarouselButton(
            isActive: _selectedIndex == _indexOfServiceCivique,
            onPressed: () => _updateIndex(_indexOfServiceCivique),
            label: Strings.serviceCiviqueButton,
          ),
          SizedBox(width: Margins.spacing_base),
        ],
      ),
    );
  }

  Widget _content() {
    switch (_selectedIndex) {
      case _indexOfOffresEmploi:
        return OffreEmploiSearchPage(onlyAlternance: false);
      case _indexOfAlternance:
        return OffreEmploiSearchPage(onlyAlternance: true);
      case _indexOfImmersion:
        return ImmersionSearchPage();
      default:
        return ServiceCiviqueSearchPage();
    }
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
