import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/widgets/cards/saved_search_card.dart';
import 'package:pass_emploi_app/widgets/dialogs/saved_search_delete_dialog.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

import '../presentation/saved_search/saved_search_list_view_model.dart';
import '../redux/actions/named_actions.dart';
import '../redux/actions/saved_search_actions.dart';
import '../ui/app_colors.dart';
import '../ui/margins.dart';
import '../ui/strings.dart';
import '../ui/text_styles.dart';
import '../widgets/buttons/carousel_button.dart';
import '../widgets/snack_bar/show_snack_bar.dart';
import 'immersion_list_page.dart';
import 'offre_emploi_list_page.dart';

const int _indexOfOffresEmploi = 0;
const int _indexOfAlternance = 1;
const int _indexOfImmersion = 2;

class SavedSearchTabPage extends StatefulWidget {
  @override
  State<SavedSearchTabPage> createState() => _SavedSearchTabPageState();
}

class _SavedSearchTabPageState extends State<SavedSearchTabPage> {
  int _selectedIndex = 0;
  bool _shouldNavigate = true;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SavedSearchListViewModel>(
      onInit: (store) {
        store.dispatch(RequestSavedSearchListAction());
        final DeepLinkState link = store.state.deepLinkState;
        if (link.deepLink == DeepLink.SAVED_SEARCH_RESULTS && link.dataId != null) {
          store.dispatch(GetSavedSearchAction(link.dataId!));
        }
      },
      onWillChange: (previousVM, newViewModel) {
        if (newViewModel.searchNavigationState == SavedSearchNavigationState.OFFRE_EMPLOI && _shouldNavigate) {
          _goToOffresPage(context, false);
        } else if (newViewModel.searchNavigationState == SavedSearchNavigationState.OFFRE_ALTERNANCE &&
            _shouldNavigate) {
          _goToOffresPage(context, true);
        } else if (newViewModel.searchNavigationState == SavedSearchNavigationState.OFFRE_IMMERSION &&
            _shouldNavigate) {
          _goToImmersion(context, newViewModel.immersionsResults);
        }
      },
      builder: (context, viewModel) => _scrollView(viewModel),
      converter: (store) => SavedSearchListViewModel.createFromStore(store),
      distinct: true,
    );
  }

  void _goToOffresPage(BuildContext context, bool onlyAlternance) {
    _shouldNavigate = false;
    _updateIndex(onlyAlternance ? _indexOfAlternance : _indexOfOffresEmploi);
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return OffreEmploiListPage(
        onlyAlternance: onlyAlternance,
        fromSavedSearch: true,
      );
    })).then((_) => _shouldNavigate = true);
  }

  void _goToImmersion(BuildContext context, List<Immersion> immersionsResults) {
    _shouldNavigate = false;
    _updateIndex(_indexOfImmersion);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ImmersionListPage(immersionsResults, true)))
        .then((value) {
      StoreProvider.of<AppState>(context).dispatch(ImmersionAction.reset());
    }).then((_) => _shouldNavigate = true);
  }

  Widget _scrollView(SavedSearchListViewModel viewModel) {
    return Column(
      children: [
        SizedBox(height: Margins.spacing_m),
        _carousel(),
        Expanded(child: _content(viewModel)),
      ],
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
    if (viewModel.displayState == DisplayState.LOADING) {
      return Center(child: CircularProgressIndicator(color: AppColors.nightBlue));
    }
    if (viewModel.displayState == DisplayState.FAILURE) {
      return Center(child: Retry(Strings.savedSearchGetError, () => viewModel.onRetry()));
    }
    switch (_selectedIndex) {
      case _indexOfOffresEmploi:
        MatomoTracker.trackScreenWithName(
            AnalyticsScreenNames.savedSearchEmploiList, AnalyticsScreenNames.savedSearchEmploiList);
        return _getSavedSearchOffreEmploi(viewModel, false);
      case _indexOfAlternance:
        MatomoTracker.trackScreenWithName(
            AnalyticsScreenNames.savedSearchAlternanceList, AnalyticsScreenNames.savedSearchAlternanceList);
        return _getSavedSearchOffreEmploi(viewModel, true);
      default:
        MatomoTracker.trackScreenWithName(
            AnalyticsScreenNames.savedSearchEmploiList, AnalyticsScreenNames.savedSearchEmploiList);
        return _getSavedSearchImmersions(viewModel);
    }
  }

  void _updateIndex(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _getSavedSearchOffreEmploi(SavedSearchListViewModel viewModel, bool isAlternance) {
    final offreEmplois = viewModel.getOffresEmploi(isAlternance);
    if (offreEmplois.isEmpty) return Center(child: Text(Strings.noSavedSearchYet, style: TextStyles.textSmRegular()));
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: offreEmplois.length,
      itemBuilder: (context, position) {
        double topPadding = (position == 0) ? Margins.spacing_m : 0;
        return Padding(
          padding: EdgeInsets.fromLTRB(Margins.spacing_base, topPadding, Margins.spacing_base, Margins.spacing_base),
          child: _buildCard(context, offreEmplois[position], viewModel),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, OffreEmploiSavedSearch offreEmploi, SavedSearchListViewModel viewModel) {
    final type = offreEmploi.isAlternance ? SavedSearchType.ALTERNANCE : SavedSearchType.EMPLOI;
    return SavedSearchCard(
      onTap: () => viewModel.offreEmploiSelected(offreEmploi),
      onDeleteTap: () => _showDeleteDialog(viewModel, offreEmploi.id, type),
      title: offreEmploi.title,
      lieu: offreEmploi.location?.libelle,
      dataTag: [
        if (offreEmploi.metier != null) offreEmploi.metier!,
      ],
    );
  }

  Widget _getSavedSearchImmersions(SavedSearchListViewModel viewModel) {
    final savedSearchsImmersion = viewModel.getImmersions();
    if (savedSearchsImmersion.isEmpty) {
      return Center(child: Text(Strings.noSavedSearchYet, style: TextStyles.textSmRegular()));
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: savedSearchsImmersion.length,
      itemBuilder: (context, position) {
        double topPadding = (position == 0) ? Margins.spacing_m : 0;
        return Padding(
          padding: EdgeInsets.fromLTRB(Margins.spacing_base, topPadding, Margins.spacing_base, Margins.spacing_base),
          child: _buildImmersionCard(context, savedSearchsImmersion[position], viewModel),
        );
      },
    );
  }

  Widget _buildImmersionCard(
    BuildContext context,
    ImmersionSavedSearch savedSearchsImmersion,
    SavedSearchListViewModel viewModel,
  ) {
    return SavedSearchCard(
      onTap: () => viewModel.offreImmersionSelected(savedSearchsImmersion),
      onDeleteTap: () => _showDeleteDialog(viewModel, savedSearchsImmersion.id, SavedSearchType.IMMERSION),
      title: savedSearchsImmersion.title,
      lieu: savedSearchsImmersion.location,
      dataTag: [savedSearchsImmersion.metier],
    );
  }

  void _showDeleteDialog(SavedSearchListViewModel viewModel, String savedSearchId, SavedSearchType type) {
    showDialog(
      context: context,
      builder: (_) => SavedSearchDeleteDialog(savedSearchId, type),
    ).then((result) {
      if (result == true) showSuccessfulSnackBar(context, Strings.savedSearchDeleteSuccess);
    });
  }
}
