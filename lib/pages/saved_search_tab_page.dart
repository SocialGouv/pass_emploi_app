import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

import '../presentation/saved_search/saved_search_list_view_model.dart';
import '../redux/actions/saved_search_actions.dart';
import '../ui/app_colors.dart';
import '../ui/margins.dart';
import '../ui/strings.dart';
import '../widgets/buttons/carousel_button.dart';

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
    return StoreConnector<AppState, SavedSearchListViewModel>(
      onInit: (store) => store.dispatch(RequestSavedSearchListAction()),
      builder: (context, viewModel) => _scrollView(viewModel),
      converter: (store) => SavedSearchListViewModel.createFromStore(store),
      distinct: true,
    );
  }

  SingleChildScrollView _scrollView(SavedSearchListViewModel viewModel) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: Margins.spacing_m),
          _carousel(),
          _content(viewModel),
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

  Widget _content(SavedSearchListViewModel viewModel) {
    switch (_selectedIndex) {
      case 0:
        return getOffreEmplois(viewModel);
      case 1:
        return getOffreEmplois(viewModel);
      default:
        return getOffreEmplois(viewModel);
    }
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getOffreEmplois(SavedSearchListViewModel viewModel) {
    final offreEmplois = viewModel.getOffresEmploi(false);
    if (offreEmplois.isEmpty) return Center(child: CircularProgressIndicator(color: AppColors.nightBlue));
    return ListView.builder(
      itemCount: offreEmplois.length,
      itemBuilder: (context, position) => Text(offreEmplois[position].title),
    );
  }
}
