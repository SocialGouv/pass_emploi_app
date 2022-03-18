import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_actions.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_detail_page.dart';
import 'package:pass_emploi_app/pages/service_civique/service_civique_filtres_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/empty_offre_widget.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

import '../../presentation/service_civique_view_model.dart';
import '../../widgets/buttons/filtre_button.dart';
import '../offre_page.dart';

class ServiceCiviqueListPage extends TraceableStatefulWidget {
  ServiceCiviqueListPage() : super(name: AnalyticsScreenNames.serviceCiviqueResults);

  @override
  State<ServiceCiviqueListPage> createState() => _ServiceCiviqueListPage();
}

class _ServiceCiviqueListPage extends State<ServiceCiviqueListPage> {
  late ScrollController _scrollController;
  ServiceCiviqueViewModel? _currentViewModel;
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
    return StoreConnector<AppState, ServiceCiviqueViewModel>(
      converter: (store) => ServiceCiviqueViewModel.create(store),
      onInitialBuild: (viewModel) => _currentViewModel = viewModel,
      builder: (context, viewModel) => FavorisStateContext<ServiceCivique>(
        selectState: (store) => store.state.serviceCiviqueFavorisState,
        child: _scaffold(_body(context, viewModel)),
      ),
      onDidChange: (previousViewModel, viewModel) {
        _currentViewModel = viewModel;
        if (_scrollController.hasClients) _scrollController.jumpTo(_offsetBeforeLoading);
        _shouldLoadAtBottom = viewModel.displayLoaderAtBottomOfList && viewModel.displayState != DisplayState.FAILURE;
      },
      distinct: true,
      onDispose: (store) => store.dispatch(ServiceCiviqueSearchResetAction()),
    );
  }

  Widget _scaffold(Widget body) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: passEmploiAppBar(
        label: Strings.serviceCiviqueListTitle,
        withBackButton: true,
      ),
      body: body,
    );
  }

  Widget _body(BuildContext context, ServiceCiviqueViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
      case DisplayState.LOADING:
        return _content(context, viewModel);
      case DisplayState.EMPTY:
        return _empty(viewModel);
      case DisplayState.FAILURE:
        return _error(viewModel);
    }
  }

  Widget _content(BuildContext context, ServiceCiviqueViewModel viewModel) {
    if (viewModel.items.isEmpty) return _empty(viewModel);
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
              _filtrePrimaryButton(viewModel),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildOffreItemWithListener(
    BuildContext context,
    int index,
    ServiceCiviqueViewModel resultsViewModel,
  ) {
    final ServiceCivique item = resultsViewModel.items[index];
    return DataCard<ServiceCivique>(
      titre: item.title,
      category: Domaine.fromTag(item.domain)?.titre,
      sousTitre: item.companyName,
      lieu: item.location,
      id: item.id,
      dataTag: [
        if (item.startDate != null)
          Strings.asSoonAs + item.startDate!.toDateTimeUtcOnLocalTimeZone().toDayWithFullMonth(),
      ],
      from: OffrePage.serviceCiviqueResults,
      onTap: () {
        widget.pushAndTrackBack(context, MaterialPageRoute(builder: (_) {
          return ServiceCiviqueDetailPage(item.id);
        }));
      },
    );
  }

  Widget _buildFirstItem(BuildContext context, ServiceCiviqueViewModel resultsViewModel) {
    return _buildOffreItemWithListener(context, 0, resultsViewModel);
  }

  Widget _buildItem(BuildContext context, int index, ServiceCiviqueViewModel resultsViewModel) {
    if (index == 0) {
      return _buildFirstItem(context, resultsViewModel);
    } else if (index == resultsViewModel.items.length) {
      return _buildLastItem(resultsViewModel);
    } else {
      return _buildOffreItemWithListener(context, index, resultsViewModel);
    }
  }

  Padding _buildLastItem(ServiceCiviqueViewModel resultsViewModel) {
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

  int _itemCount(ServiceCiviqueViewModel viewModel) {
    if (viewModel.displayLoaderAtBottomOfList) {
      return viewModel.items.length + 1;
    } else {
      return viewModel.items.length;
    }
  }

  Widget _error(ServiceCiviqueViewModel viewModel) {
    return Stack(
      children: [
        Center(child: Retry(Strings.genericError, viewModel.onRetry)), // if (viewModel.withFiltreButton)
        //   Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Padding(padding: const EdgeInsets.only(bottom: 24), child: null),
        //   ),
      ],
    );
  }

  Widget _empty(ServiceCiviqueViewModel viewModel) {
    MatomoTracker.trackScreenWithName(
        AnalyticsScreenNames.serviceCiviqueNoResults, AnalyticsScreenNames.serviceCiviqueNoResults);
    return EmptyOffreWidget(
      additional: Padding(
        padding: const EdgeInsets.only(top: Margins.spacing_base),
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _filtreSecondaryButton(viewModel),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filtrePrimaryButton(ServiceCiviqueViewModel viewModel) {
    return FiltreButton.primary(
      filtresCount: viewModel.filtresCount,
      onPressed: () => _onFiltreButtonPressed(),
    );
  }

  Widget _filtreSecondaryButton(ServiceCiviqueViewModel viewModel) {
    return FiltreButton.secondary(
      filtresCount: viewModel.filtresCount,
      onPressed: () => _onFiltreButtonPressed(),
    );
  }

  Future<void> _onFiltreButtonPressed() async {
    return widget.pushAndTrackBack(context, ServiceCiviqueFiltresPage.materialPageRoute()).then((value) {
      if (value == true) {
        _offsetBeforeLoading = 0;
        if (_scrollController.hasClients) _scrollController.jumpTo(_offsetBeforeLoading);
      }
    });
  }
}
