import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_filtres_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_results_view_model.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/offre_emploi_list_item.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';

class OffreEmploiListPage extends TraceableStatefulWidget {
  OffreEmploiListPage() : super(name: AnalyticsScreenNames.offreEmploiResults);

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
      builder: (context, viewModel) => _scaffold(context, viewModel),
      onDidChange: (previousViewModel, viewModel) {
        _currentViewModel = viewModel;
        if (_scrollController.hasClients) _scrollController.jumpTo(_offsetBeforeLoading);
        _shouldLoadAtBottom = viewModel.displayLoaderAtBottomOfList && viewModel.displayState != DisplayState.FAILURE;
      },
      distinct: true,
      onDispose: (store) => store.dispatch(OffreEmploiResetResultsAction()),
    );
  }

  Widget _scaffold(BuildContext context, OffreEmploiSearchResultsViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: FlatDefaultAppBar(
        title: Text(Strings.offresEmploiTitle, style: TextStyles.textLgMedium),
      ),
      body: Stack(children: [
        if (viewModel.displayState == DisplayState.CONTENT)
          ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              controller: _scrollController,
              itemBuilder: (context, index) => _buildItem(context, index, viewModel),
              separatorBuilder: (context, index) => _listSeparator(),
              itemCount: _itemCount(viewModel))
        else if (viewModel.displayState == DisplayState.EMPTY || viewModel.displayState == DisplayState.FAILURE)
          Center(child: Text(viewModel.errorMessage, style: TextStyles.textSmRegular())),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(padding: const EdgeInsets.only(bottom: 24), child: _filterButton(viewModel)),
        ),
      ]),
    );
  }

  Widget _buildOffreItemWithListener(
    BuildContext context,
    int index,
    OffreEmploiSearchResultsViewModel resultsViewModel,
  ) {
    return Container(
      color: Colors.white,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => _showOffreEmploiDetailsPage(context, resultsViewModel.items[index].id),
          splashColor: AppColors.bluePurple,
          child: OffreEmploiListItem(itemViewModel: resultsViewModel.items[index]),
        ),
      ),
    );
  }

  Widget _buildFirstItem(BuildContext context, OffreEmploiSearchResultsViewModel resultsViewModel) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.zero),
      child: _buildOffreItemWithListener(context, 0, resultsViewModel),
    );
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
            style: TextStyles.textSmRegular(color: AppColors.bluePurple),
          ),
          TextButton(
              onPressed: () => _currentViewModel?.onLoadMore(),
              child: Text(Strings.retry, style: TextStyles.textMdMedium)),
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

  Widget _listSeparator() => Container(height: 1, color: AppColors.bluePurpleAlpha20);

  void _showOffreEmploiDetailsPage(BuildContext context, String offreId) {
    _offsetBeforeLoading = _scrollController.offset;
    Navigator.push(context, OffreEmploiDetailsPage.materialPageRoute(offreId))
        .then((value) => _scrollController.jumpTo(_offsetBeforeLoading));
  }

  int _itemCount(OffreEmploiSearchResultsViewModel viewModel) {
    if (viewModel.displayLoaderAtBottomOfList)
      return viewModel.items.length + 1;
    else
      return viewModel.items.length;
  }

  Widget _filterButton(OffreEmploiSearchResultsViewModel viewModel) {
    return PrimaryActionButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Strings.filtrer, style: TextStyles.textPrimaryButton.copyWith(fontSize: FontSizes.medium),),
            SizedBox(width: 12),
            SvgPicture.asset(Drawables.icFilter, height: 18, width: 18,),
            SizedBox(width: 16),
            if (viewModel.filtresCount != null)
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                width: 24,
                height: 24,
                alignment: Alignment.center,
                child: Text(viewModel.filtresCount!.toString(), style: TextStyle(
                  color: Colors.black,
                  fontSize: FontSizes.normal,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Marianne',
                ),),
              ),
          ],
        ),
        onPressed: () => Navigator.push(context, OffreEmploiFiltresPage.materialPageRoute()).then((value) {
              if (value == true) {
                _offsetBeforeLoading = 0;
                if (_scrollController.hasClients) _scrollController.jumpTo(_offsetBeforeLoading);
              }
            }));
  }
}
