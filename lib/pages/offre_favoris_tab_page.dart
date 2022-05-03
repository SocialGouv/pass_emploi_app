import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/pages/favoris/immersion_favoris_page.dart';
import 'package:pass_emploi_app/pages/favoris/offre_emploi_favoris_page.dart';
import 'package:pass_emploi_app/pages/favoris/service_civique_favoris_page.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/carousel_button.dart';

const int _indexOfOffresEmploi = 0;
const int _indexOfAlternance = 1;
const int _indexOfServiceCivique = 2;
const int _indexOfImmersion = 3;

class OffreFavorisTabPage extends StatefulWidget {
  @override
  State<OffreFavorisTabPage> createState() => _OffreFavorisTabPageState();
}

class _OffreFavorisTabPageState extends State<OffreFavorisTabPage> {
  int _selectedIndex = 0;

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
          SizedBox(width: 12),
          CarouselButton(
            isActive: _selectedIndex == _indexOfServiceCivique,
            onPressed: () => _updateIndex(_indexOfServiceCivique),
            label: Strings.serviceCiviqueButton,
          ),
          SizedBox(width: Margins.spacing_base),
          CarouselButton(
            isActive: _selectedIndex == _indexOfImmersion,
            onPressed: () => _updateIndex(_indexOfImmersion),
            label: Strings.immersionButton,
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _content() {
    switch (_selectedIndex) {
      case 0:
        return OffreEmploiFavorisPage(onlyAlternance: false);
      case 1:
        return OffreEmploiFavorisPage(onlyAlternance: true);
      case 2:
        return ImmersionFavorisPage();
      default:
        return ServiceCiviqueFavorisPage();
    }
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
