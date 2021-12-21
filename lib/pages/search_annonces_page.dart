import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/carousel_button.dart';

const int _indexOfOffresEmploi = 0;
const int _indexOfImmersion = 1;

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
          SizedBox(height: 24),
          _carousel(),
          // contenu
        ],
      ),
    );
  }

  Widget _carousel() {
    return Row(children: [
      SizedBox(width: 12),
      carouselButton(
        isActive: _selectedIndex == _indexOfOffresEmploi,
        onPressed: () => _updateIndex(_indexOfOffresEmploi),
        label: Strings.offresEmploiButton,
      ),
      SizedBox(width: 12),
      carouselButton(
        isActive: _selectedIndex == _indexOfImmersion,
        onPressed: () => _updateIndex(_indexOfImmersion),
        label: Strings.immersionButton,
      ),
    ]);
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
