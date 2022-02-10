import 'package:flutter/material.dart';

import '../ui/margins.dart';
import '../ui/strings.dart';
import '../widgets/carousel_button.dart';

const int _indexOfOffresEmploi = 0;
const int _indexOfAlternance = 1;
const int _indexOfImmersion = 2;

class SavedSearchTabPage extends StatefulWidget {
  @override
  State<SavedSearchTabPage> createState() => _SavedSearchTabPageState();
}

class _SavedSearchTabPageState extends State<SavedSearchTabPage> {
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
        return Container();
      case 1:
        return Container();
      default:
        return Container();
    }
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
