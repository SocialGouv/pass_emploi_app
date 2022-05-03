import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/pages/immersion_list_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_list_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/carousel_button.dart';
import 'package:pass_emploi_app/widgets/cards/saved_search_card.dart';
import 'package:pass_emploi_app/widgets/dialogs/saved_search_delete_dialog.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

enum IndexOf { OFFRES_EMPLOI, ALTERNANCE, SERVICE_CIVIQUE, IMMERSION }

class SavedSearchTabPage extends StatefulWidget {
  @override
  State<SavedSearchTabPage> createState() => _SavedSearchTabPageState();
}

class _SavedSearchTabPageState extends State<SavedSearchTabPage> {
  IndexOf _selectedIndex = IndexOf.OFFRES_EMPLOI;
  bool _shouldNavigate = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SavedSearchListViewModel>(
      onInit: (store) {
        store.dispatch(SavedSearchListRequestAction());
        final DeepLinkState link = store.state.deepLinkState;
        if (link.deepLink == DeepLink.SAVED_SEARCH_RESULTS && link.dataId != null) {
          store.dispatch(SavedSearchGetAction(link.dataId!));
        }
      },
      onWillChange: (_, newVM) => _onWillChange(_, newVM),
      builder: (context, viewModel) => _scrollView(viewModel),
      converter: (store) => SavedSearchListViewModel.createFromStore(store),
      distinct: true,
    );
  }

  void _onWillChange(SavedSearchListViewModel? _, SavedSearchListViewModel? newViewModel) {
    if (!_shouldNavigate || newViewModel == null) return;
    switch (newViewModel.searchNavigationState) {
      case SavedSearchNavigationState.OFFRE_EMPLOI:
        _goToPageNamed(
          IndexOf.OFFRES_EMPLOI,
          OffreEmploiListPage.routeName,
          arguments: {"onlyAlternance": false, "fromSavedSearch": true},
        );
        break;
      case SavedSearchNavigationState.OFFRE_ALTERNANCE:
        _goToPageNamed(
          IndexOf.ALTERNANCE,
          OffreEmploiListPage.routeName,
          arguments: {"onlyAlternance": true, "fromSavedSearch": true},
        );
        break;
      case SavedSearchNavigationState.OFFRE_IMMERSION:
        _goToPage(IndexOf.IMMERSION, ImmersionListPage(true))
            .then((value) => StoreProvider.of<AppState>(context).dispatch(ImmersionListResetAction()));
        break;
      case SavedSearchNavigationState.SERVICE_CIVIQUE:
        _goToPage(IndexOf.SERVICE_CIVIQUE, ServiceCiviqueListPage(true));
        break;
      case SavedSearchNavigationState.NONE:
        break;
    }
  }

  Future<bool> _goToPage(IndexOf newIndex, Widget page) {
    _shouldNavigate = false;
    _updateIndex(newIndex, true);
    // ignore: ban-name
    return Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _shouldNavigate = true);
  }

  Future<bool> _goToPageNamed(IndexOf newIndex, String routeName, {Object? arguments}) {
    _shouldNavigate = false;
    _updateIndex(newIndex, true);
    return Navigator.pushNamed(context, routeName, arguments: arguments).then((_) => _shouldNavigate = true);
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
      controller: _scrollController,
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
      case IndexOf.SERVICE_CIVIQUE:
        MatomoTracker.trackScreenWithName(
            AnalyticsScreenNames.savedSearchServiceCiviqueList, AnalyticsScreenNames.savedSearchServiceCiviqueList);
        return _getSavedSearchServiceCivique(viewModel);
      case IndexOf.OFFRES_EMPLOI:
        MatomoTracker.trackScreenWithName(
            AnalyticsScreenNames.savedSearchEmploiList, AnalyticsScreenNames.savedSearchEmploiList);
        return _getSavedSearchOffreEmploi(viewModel, false);
      case IndexOf.ALTERNANCE:
        MatomoTracker.trackScreenWithName(
            AnalyticsScreenNames.savedSearchAlternanceList, AnalyticsScreenNames.savedSearchAlternanceList);
        return _getSavedSearchOffreEmploi(viewModel, true);
      default:
        MatomoTracker.trackScreenWithName(
            AnalyticsScreenNames.savedSearchEmploiList, AnalyticsScreenNames.savedSearchEmploiList);
        return _getSavedSearchImmersions(viewModel);
    }
  }

  void _updateIndex(IndexOf index, [bool withScroll = false]) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        if (withScroll) {
          _scrollController.jumpTo(_selectedIndex.index * 100);
        }
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
        final double topPadding = (position == 0) ? Margins.spacing_m : 0;
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
        final double topPadding = (position == 0) ? Margins.spacing_m : 0;
        return Padding(
          padding: EdgeInsets.fromLTRB(Margins.spacing_base, topPadding, Margins.spacing_base, Margins.spacing_base),
          child: _buildImmersionCard(context, savedSearchsImmersion[position], viewModel),
        );
      },
    );
  }

  Widget _getSavedSearchServiceCivique(SavedSearchListViewModel viewModel) {
    final savedSearchsServiceCivique = viewModel.getServiceCivique();
    if (savedSearchsServiceCivique.isEmpty) {
      return Center(child: Text(Strings.noSavedSearchYet, style: TextStyles.textSmRegular()));
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: savedSearchsServiceCivique.length,
      itemBuilder: (context, position) {
        final double topPadding = (position == 0) ? Margins.spacing_m : 0;
        return Padding(
          padding: EdgeInsets.fromLTRB(Margins.spacing_base, topPadding, Margins.spacing_base, Margins.spacing_base),
          child: _buildServiceCiviqueCard(context, savedSearchsServiceCivique[position], viewModel),
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
      lieu: savedSearchsImmersion.ville,
      dataTag: [savedSearchsImmersion.metier],
    );
  }

  Widget _buildServiceCiviqueCard(
    BuildContext context,
    ServiceCiviqueSavedSearch savedSearchsServiceCivique,
    SavedSearchListViewModel viewModel,
  ) {
    final domaine = savedSearchsServiceCivique.domaine?.titre;
    return SavedSearchCard(
      onTap: () => viewModel.offreServiceCiviqueSelected(savedSearchsServiceCivique),
      onDeleteTap: () => _showDeleteDialog(viewModel, savedSearchsServiceCivique.id, SavedSearchType.SERVICE_CIVIQUE),
      title: savedSearchsServiceCivique.titre,
      lieu: savedSearchsServiceCivique.ville?.isNotEmpty == true ? savedSearchsServiceCivique.ville : null,
      dataTag: [
        if (domaine != null) domaine,
      ],
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
