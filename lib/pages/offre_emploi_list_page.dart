import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_results_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class OffreEmploiListPage extends StatefulWidget {
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
      builder: (context, viewModel) => _willPopScope(context, viewModel),
      onDidChange: (previousViewModel, viewModel) => {
        _currentViewModel = viewModel,
        _scrollController.jumpTo(_offsetBeforeLoading),
        _shouldLoadAtBottom = viewModel.displayState != OffreEmploiSearchResultsDisplayState.SHOW_ERROR
      },
    );
  }

  WillPopScope _willPopScope(BuildContext context, OffreEmploiSearchResultsViewModel viewModel) {
    return WillPopScope(
      child: _scaffold(context, viewModel),
      onWillPop: () {
        viewModel.onQuit();
        return Future.value(false);
      },
    );
  }

  Widget _scaffold(BuildContext context, OffreEmploiSearchResultsViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: FlatDefaultAppBar(
        title: Text(Strings.offresEmploiTitle, style: TextStyles.textLgMedium),
        leading: BackButton(onPressed: () => viewModel.onQuit()),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.zero),
          child: ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, index) => _buildItem(context, index, viewModel),
            separatorBuilder: (context, index) => _listSeparator(),
            itemCount: viewModel.items.length + 1,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, OffreEmploiSearchResultsViewModel resultsViewModel) {
    if (index == resultsViewModel.items.length) {
      return _buildLastItem(resultsViewModel);
    } else {
      return _buildOffreItem(resultsViewModel, index);
    }
  }

  Widget _buildOffreItem(OffreEmploiSearchResultsViewModel resultsViewModel, int index) {
    final itemViewModel = resultsViewModel.items[index];
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              itemViewModel.title,
              style: TextStyles.textSmMedium(),
            ),
            if (itemViewModel.companyName != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  itemViewModel.companyName!,
                  style: TextStyles.textSmRegular(color: AppColors.bluePurple),
                ),
              ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _lightBlueTag(label: itemViewModel.contractType),
                if (itemViewModel.duration != null) _lightBlueTag(label: itemViewModel.duration!),
                if (itemViewModel.location != null)
                  _lightBlueTag(label: itemViewModel.location!, icon: SvgPicture.asset("assets/ic_place.svg")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding _buildLastItem(OffreEmploiSearchResultsViewModel resultsViewModel) {
    if (resultsViewModel.displayState == OffreEmploiSearchResultsDisplayState.SHOW_ERROR) {
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

  Container _lightBlueTag({required String label, SvgPicture? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: icon,
                ),
              Flexible(
                child: Text(
                  label,
                  style: TextStyles.textSmRegular(),
                ),
              ),
            ],
          )),
    );
  }
}
