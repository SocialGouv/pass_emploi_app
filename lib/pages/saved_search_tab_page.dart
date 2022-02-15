import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/widgets/cards/saved_search_card.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

import '../presentation/saved_search/saved_search_list_view_model.dart';
import '../redux/actions/saved_search_actions.dart';
import '../ui/app_colors.dart';
import '../ui/margins.dart';
import '../ui/strings.dart';
import '../ui/text_styles.dart';
import '../widgets/buttons/carousel_button.dart';
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
  bool _shouldNavigate = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SavedSearchListViewModel>(
      onInit: (store) => store.dispatch(RequestSavedSearchListAction()),
      onWillChange: (previousVM, newViewModel) {
        if (newViewModel.shouldGoToOffre && _shouldNavigate) {
          _shouldNavigate = false;
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return OffreEmploiListPage(onlyAlternance: false);
          })).then((_) => _shouldNavigate = true);
        }
      },
      builder: (context, viewModel) => _scrollView(viewModel),
      converter: (store) => SavedSearchListViewModel.createFromStore(store),
      distinct: true,
    );
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
      return Center(
          child: Retry(
        Strings.savedSearchGetError,
        () => viewModel.onRetry(),
      ));
    }
    switch (_selectedIndex) {
      case 0:
        MatomoTracker.trackScreenWithName(
            AnalyticsScreenNames.savedSearchEmploiListUrl, AnalyticsScreenNames.savedSearchEmploiListUrl);
        return _getSavedSearchOffreEmplois(viewModel, false);
      case 1:
        MatomoTracker.trackScreenWithName(
            AnalyticsScreenNames.savedSearchImmersionListUrl, AnalyticsScreenNames.savedSearchImmersionListUrl);
        return _getSavedSearchOffreEmplois(viewModel, true);
      default:
        MatomoTracker.trackScreenWithName(
            AnalyticsScreenNames.savedSearchEmploiListUrl, AnalyticsScreenNames.savedSearchEmploiListUrl);
        return _getSavedSearchImmersions(viewModel);
    }
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSavedSearchOffreEmplois(SavedSearchListViewModel viewModel, bool isAlternance) {
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
    return SavedSearchCard(
      onTap: () => viewModel.offreEmploiSelected(offreEmploi),
      title: offreEmploi.title,
      lieu: offreEmploi.location?.libelle,
      dataTag: [
        if (offreEmploi.metier != null) offreEmploi.metier!,
        ..._getDureeTags(offreEmploi.filters.duree),
        ..._getContratTags(offreEmploi.filters.contrat),
        ..._getExperienceTags(offreEmploi.filters.experience),
        if (offreEmploi.filters.distance != null) (offreEmploi.filters.distance.toString() + " km")
      ],
    );
  }

  List<String> _getDureeTags(List<DureeFiltre>? duree) {
    if (duree == null) {
      return [];
    }
    return duree.map((e) => FiltresLabels.fromDureeToString(e)).toList();
  }

  List<String> _getContratTags(List<ContratFiltre>? contrat) {
    if (contrat == null) {
      return [];
    }
    return contrat.map((e) => FiltresLabels.fromContratToString(e)).toList();
  }

  List<String> _getExperienceTags(List<ExperienceFiltre>? experience) {
    if (experience == null) {
      return [];
    }
    return experience.map((e) => FiltresLabels.fromExperienceToString(e)).toList();
  }

  Widget _getSavedSearchImmersions(SavedSearchListViewModel viewModel) {
    final savedSearchsImmersion = viewModel.getImmersions();
    if (savedSearchsImmersion.isEmpty)
      return Center(child: Text(Strings.noSavedSearchYet, style: TextStyles.textSmRegular()));
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: savedSearchsImmersion.length,
      itemBuilder: (context, position) {
        double topPadding = (position == 0) ? Margins.spacing_m : 0;
        return Padding(
          padding: EdgeInsets.fromLTRB(Margins.spacing_base, topPadding, Margins.spacing_base, Margins.spacing_base),
          child: _buildImmersionCard(context, savedSearchsImmersion[position]),
        );
      },
    );
  }

  Widget _buildImmersionCard(BuildContext context, ImmersionSavedSearch savedSearchsImmersion) {
    return SavedSearchCard(
      title: savedSearchsImmersion.title,
      lieu: savedSearchsImmersion.location,
      dataTag: [savedSearchsImmersion.metier],
    );
  }
}
