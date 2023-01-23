import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/pages/campagne/campagne_details_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step1_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_detail_page.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/campagne_card.dart';
import 'package:pass_emploi_app/widgets/cards/demarche_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/empty_page.dart';
import 'package:pass_emploi_app/widgets/not_up_to_date_message.dart';
import 'package:pass_emploi_app/widgets/reloadable_page.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class DemarcheListPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.userActionList,
      child: StoreConnector<AppState, DemarcheListPageViewModel>(
        onInit: (store) => store.dispatch(DemarcheListRequestAction()),
        builder: (context, viewModel) => _scaffold(context, viewModel),
        converter: (store) => DemarcheListPageViewModel.create(store),
        onDidChange: (previous, current) => _onDidChange(context, previous, current),
        distinct: true,
        onDispose: (store) => store.dispatch(DemarcheListResetAction()),
      ),
    );
  }

  Widget _scaffold(BuildContext context, DemarcheListPageViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Stack(
        children: [
          DefaultAnimatedSwitcher(child: _animatedBody(context, viewModel)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(padding: const EdgeInsets.only(bottom: 24), child: _AddDemarcheButton()),
          ),
        ],
      ),
    );
  }

  Widget _animatedBody(BuildContext context, DemarcheListPageViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return _userActionsList(context, viewModel);
      case DisplayState.LOADING:
        return Center(child: CircularProgressIndicator());
      case DisplayState.EMPTY:
        return _emptyPage(context, viewModel);
      case DisplayState.FAILURE:
        return Center(child: Retry(Strings.demarchesError, () => viewModel.onRetry()));
    }
  }

  Widget _userActionsList(BuildContext context, DemarcheListPageViewModel viewModel) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(
        Margins.spacing_base,
        Margins.spacing_base,
        Margins.spacing_base,
        Margins.spacing_huge,
      ),
      itemCount: viewModel.items.length,
      itemBuilder: (context, i) => _listItem(context, viewModel.items[i], viewModel),
      separatorBuilder: (context, i) => _listSeparator(),
    );
  }

  Container _listSeparator() => Container(height: Margins.spacing_base);

  Widget _listItem(BuildContext context, DemarcheListItem item, DemarcheListPageViewModel viewModel) {
    if (item is DemarcheCampagneItem) {
      return _CampagneCard(title: item.titre, description: item.description);
    } else if (item is DemarcheNotUpToDateItem) {
      return NotUpToDateMessage(message: Strings.demarchesNotUpToDateMessage, onRefresh: viewModel.onRetry);
    } else {
      final id = (item as IdItem).demarcheId;
      return DemarcheCard(
        demarcheId: id,
        stateSource: DemarcheStateSource.demarcheList,
        onTap: () =>
            Navigator.push(context, DemarcheDetailPage.materialPageRoute(id, DemarcheStateSource.demarcheList)),
      );
    }
  }

  void _onDidChange(BuildContext context, DemarcheListPageViewModel? previous, DemarcheListPageViewModel current) {
    if (previous?.isReloading == true && _currentDemarchesAreUpToDate(current)) {
      showSuccessfulSnackBar(context, Strings.demarchesUpToDate);
    }
  }

  bool _currentDemarchesAreUpToDate(DemarcheListPageViewModel current) {
    return [DisplayState.CONTENT, DisplayState.EMPTY].contains(current.displayState) &&
        (current.items.isEmpty || current.items.first is! DemarcheNotUpToDateItem);
  }

  Widget _emptyPage(BuildContext context, DemarcheListPageViewModel viewModel) {
    final emptyMessage = Strings.emptyContentTitle(Strings.demarchesToDo);
    final showNotUpToDateMessage = viewModel.items.isNotEmpty && viewModel.items.first is DemarcheNotUpToDateItem;
    return showNotUpToDateMessage
        ? ReloadablePage(
            reloadMessage: Strings.demarchesNotUpToDateMessage, onReload: viewModel.onRetry, emptyMessage: emptyMessage)
        : Empty(description: emptyMessage);
  }
}

class _CampagneCard extends StatelessWidget {
  final String title;
  final String description;

  _CampagneCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return CampagneCard(
      onTap: () {
        Navigator.push(context, CampagneDetailsPage.materialPageRoute());
      },
      titre: title,
      description: description,
    );
  }
}

class _AddDemarcheButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PrimaryActionButton(
        drawableRes: Drawables.icAdd,
        label: Strings.addADemarche,
        onPressed: () => Navigator.push(context, CreateDemarcheStep1Page.materialPageRoute()).then((value) {
          if (value != null) _showSnackBarWithDetail(context, value);
        }),
      ),
    );
  }

  void _showSnackBarWithDetail(BuildContext context, String demarcheCreatedId) {
    showSuccessfulSnackBar(
      context,
      Strings.createDemarcheSuccess,
      () => Navigator.push(
          context, DemarcheDetailPage.materialPageRoute(demarcheCreatedId, DemarcheStateSource.demarcheList)),
    );
  }
}
