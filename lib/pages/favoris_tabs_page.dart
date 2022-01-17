import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/carousel_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

import 'favoris_page.dart';

const int _indexOfOffresEmploi = 0;
const int _indexOfAlternance = 1;

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
      backgroundColor: AppColors.lightBlue,
      appBar: passEmploiAppBar(label: Strings.menuFavoris),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 24),
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
          SizedBox(width: 12),
          CarouselButton(
            isActive: _selectedIndex == _indexOfOffresEmploi,
            onPressed: () => _updateIndex(_indexOfOffresEmploi),
            label: Strings.offresEmploiButton,
          ),
          SizedBox(width: 12),
          CarouselButton(
            isActive: _selectedIndex == _indexOfAlternance,
            onPressed: () => _updateIndex(_indexOfAlternance),
            label: Strings.alternanceButton,
          ),
          SizedBox(width: 12)
        ],
      ),
    );
  }

  Widget _content() => FavorisPage(onlyAlternance: _selectedIndex == _indexOfAlternance);

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
