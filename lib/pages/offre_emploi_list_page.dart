import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_filtres_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_results_view_model.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/offre_emploi_saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/filtre_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/empty_offre_widget.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';

import 'offre_page.dart';

class OffreEmploiListPage extends TraceableStatefulWidget {
  final bool onlyAlternance;
  final bool fromSavedSearch;

  OffreEmploiListPage({required this.onlyAlternance, this.fromSavedSearch = false})
      : super(name: onlyAlternance ? AnalyticsScreenNames.alternanceResults : AnalyticsScreenNames.emploiResults);

  @override
  State<OffreEmploiListPage> createState() => _OffreEmploiListPageState();
}

class _OffreEmploiListPageState extends State<OffreEmploiListPage> {
  late ScrollController _scrollController;
  OffreEmploiSearchResultsViewModel? _currentViewModel;
  double _offsetBeforeLoading = 0;
  bool _shouldLoadAtBottom = true;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_shouldLoadAtBottom && _scrollController.offset >= _scrollController.position.maxScrollExtent) {
        _offsetBeforeLoading = _scrollController.offset;
        _currentViewModel?.onLoadMore();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiSearchResultsViewModel>(
      converter: (store) => OffreEmploiSearchResultsViewModel.create(store),
      onInitialBuild: (viewModel) => _currentViewModel = viewModel,
      builder: (context, viewModel) => FavorisStateContext<OffreEmploi>(
        selectState: (store) => store.state.offreEmploiFavorisState,
        child: _scaffold(_body(context, viewModel)),
      ),
      onDidChange: (previousViewModel, viewModel) {
        _currentViewModel = viewModel;
        if (_scrollController.hasClients) _scrollController.jumpTo(_offsetBeforeLoading);
        _shouldLoadAtBottom = viewModel.displayLoaderAtBottomOfList && viewModel.displayState != DisplayState.FAILURE;
      },
      distinct: true,
      onDispose: (store) => store.dispatch(OffreEmploiResetResultsAction()),
    );
  }

  Widget _scaffold(Widget body) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: passEmploiAppBar(
        label: widget.onlyAlternance ? Strings.alternanceTitle : Strings.offresEmploiTitle,
        withBackButton: true,
      ),
      body: body,
    );
  }

  Widget _body(BuildContext context, OffreEmploiSearchResultsViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
      case DisplayState.LOADING:
        return _content(context, viewModel);
      case DisplayState.EMPTY:
        return _empty(context, viewModel);
      case DisplayState.FAILURE:
        return _error(viewModel);
    }
  }

  Widget _content(BuildContext context, OffreEmploiSearchResultsViewModel viewModel) {
    return Stack(children: [
      ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        controller: _scrollController,
        itemBuilder: (context, index) => _buildItem(context, index, viewModel),
        separatorBuilder: (context, index) => _listSeparator(),
        itemCount: _itemCount(viewModel),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              _alertPrimaryButton(viewModel),
              if (viewModel.withFiltreButton) _filtrePrimaryButton(viewModel),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _empty(BuildContext context, OffreEmploiSearchResultsViewModel viewModel) {
    _trackEmptyResult();
    return EmptyOffreWidget(
      withModifyButton: !widget.fromSavedSearch,
      additional: Padding(
        padding: const EdgeInsets.only(top: Margins.spacing_base),
        child: widget.fromSavedSearch
            ? Container()
            : Column(
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _alertSecondaryButton(viewModel),
                      if (viewModel.withFiltreButton) _filtreSecondaryButton(viewModel),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _error(OffreEmploiSearchResultsViewModel viewModel) {
    return Stack(
      children: [
        Center(child: Text(viewModel.errorMessage, style: TextStyles.textSmRegular())),
        if (viewModel.withFiltreButton)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(padding: const EdgeInsets.only(bottom: 24), child: _filtrePrimaryButton(viewModel)),
          ),
      ],
    );
  }

  Widget _buildOffreItemWithListener(
    BuildContext context,
    int index,
    OffreEmploiSearchResultsViewModel resultsViewModel,
  ) {
    final OffreEmploiItemViewModel item = resultsViewModel.items[index];
    return DataCard<OffreEmploi>(
      titre: item.title,
      sousTitre: item.companyName,
      lieu: item.location,
      id: item.id,
      dataTag: [item.contractType, item.duration ?? ''],
      onTap: () => _showOffreEmploiDetailsPage(context, resultsViewModel.items[index].id),
      from: widget.onlyAlternance ? OffrePage.alternanceResults : OffrePage.emploiResults,
    );
  }

  Widget _buildFirstItem(BuildContext context, OffreEmploiSearchResultsViewModel resultsViewModel) {
    return _buildOffreItemWithListener(context, 0, resultsViewModel);
  }

  Widget _buildItem(BuildContext context, int index, OffreEmploiSearchResultsViewModel resultsViewModel) {
    if (index == 0) {
      return _buildFirstItem(context, resultsViewModel);
    } else if (index == resultsViewModel.items.length) {
      return _buildLastItem(resultsViewModel);
    } else {
      return _buildOffreItemWithListener(context, index, resultsViewModel);
    }
  }

  Padding _buildLastItem(OffreEmploiSearchResultsViewModel resultsViewModel) {
    if (resultsViewModel.displayState == DisplayState.FAILURE) {
      return _buildErrorItem();
    } else {
      return _buildLoaderItem();
    }
  }

  Padding _buildErrorItem() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
      child: Column(
        children: [
          Text(
            Strings.loadMoreOffresError,
            textAlign: TextAlign.center,
            style: TextStyles.textSRegular(),
          ),
          TextButton(
            onPressed: () => _currentViewModel?.onLoadMore(),
            child: Text(Strings.retry, style: TextStyles.textBaseBold),
          ),
        ],
      ),
    );
  }

  Padding _buildLoaderItem() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator(color: AppColors.nightBlue)),
    );
  }

  Widget _listSeparator() => Container(height: Margins.spacing_base);

  void _showOffreEmploiDetailsPage(BuildContext context, String offreId) {
    _offsetBeforeLoading = _scrollController.offset;
    widget
        .pushAndTrackBack(
          context,
          OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: widget.onlyAlternance),
        )
        .then((_) => _scrollController.jumpTo(_offsetBeforeLoading));
  }

  int _itemCount(OffreEmploiSearchResultsViewModel viewModel) {
    if (viewModel.displayLoaderAtBottomOfList) {
      return viewModel.items.length + 1;
    } else {
      return viewModel.items.length;
    }
  }

  Widget _filtrePrimaryButton(OffreEmploiSearchResultsViewModel viewModel) {
    return FiltreButton.primary(
      filtresCount: viewModel.filtresCount,
      onPressed: () => _onFiltreButtonPressed(),
    );
  }

  Widget _filtreSecondaryButton(OffreEmploiSearchResultsViewModel viewModel) {
    return FiltreButton.secondary(
      filtresCount: viewModel.filtresCount,
      onPressed: () => _onFiltreButtonPressed(),
    );
  }

  Future<void> _onFiltreButtonPressed() {
    return widget
        .pushAndTrackBack(context, OffreEmploiFiltresPage.materialPageRoute(widget.onlyAlternance))
        .then((value) {
      if (value == true) {
        _offsetBeforeLoading = 0;
        if (_scrollController.hasClients) _scrollController.jumpTo(_offsetBeforeLoading);
      }
    });
  }

  void _trackEmptyResult() {
    MatomoTracker.trackScreenWithName(
      widget.onlyAlternance ? AnalyticsScreenNames.alternanceNoResults : AnalyticsScreenNames.emploiNoResults,
      widget.onlyAlternance ? AnalyticsScreenNames.alternanceResearch : AnalyticsScreenNames.emploiResearch,
    );
  }

  Widget _alertPrimaryButton(OffreEmploiSearchResultsViewModel viewModel) {
    return PrimaryActionButton(
      label: Strings.createAlert,
      drawableRes: Drawables.icAlert,
      rippleColor: AppColors.primaryDarken,
      heightPadding: 6,
      widthPadding: 6,
      iconSize: 16,
      onPressed: () => _onAlertButtonPressed(),
    );
  }

  Widget _alertSecondaryButton(OffreEmploiSearchResultsViewModel viewModel) {
    return SecondaryButton(
      label: Strings.createAlert,
      drawableRes: Drawables.icAlert,
      onPressed: () => _onAlertButtonPressed(),
    );
  }

  void _onAlertButtonPressed() {
    showPassEmploiBottomSheet(
      context: context,
      builder: (context) => OffreEmploiSavedSearchBottomSheet(onlyAlternance: widget.onlyAlternance),
    );
  }
}
