import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/favoris/offre_emploi_favoris_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/carousel_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

import 'immersion_favoris_page.dart';

const int _indexOfOffresEmploi = 0;
const int _indexOfAlternance = 1;
const int _indexOfImmersion = 2;

class FavorisTabsPage extends StatefulWidget {
  const FavorisTabsPage() : super();

  @override
  State<FavorisTabsPage> createState() => _FavorisTabsPageState();
}

class _FavorisTabsPageState extends State<FavorisTabsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: passEmploiAppBar(label: Strings.menuFavoris),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: Margins.spacing_m),
            _carousel(),
            _content(),
          ],
        ),
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
      default:
        return ImmersionFavorisPage();
    }
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
