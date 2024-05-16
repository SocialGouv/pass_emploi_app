import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step1_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_detail_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_list_loading.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/demarche_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/empty_page.dart';
import 'package:pass_emploi_app/widgets/not_up_to_date_message.dart';
import 'package:pass_emploi_app/widgets/refresh_indicator_ext.dart';
import 'package:pass_emploi_app/widgets/reloadable_page.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class DemarcheListPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(appBar: SecondaryAppBar(title: Strings.demarcheTabTitle), body: DemarcheListPage());
      },
    );
  }

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
    return switch (viewModel.displayState) {
      DisplayState.CONTENT => _userActionsList(context, viewModel),
      DisplayState.LOADING => DemarcheListLoading(),
      DisplayState.EMPTY => _emptyPage(context, viewModel),
      DisplayState.FAILURE => Retry(Strings.demarchesError, () => viewModel.onRetry()),
    };
  }

  Widget _userActionsList(BuildContext context, DemarcheListPageViewModel viewModel) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => viewModel.onRetry(),
      child: ListView.separated(
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
      ),
    );
  }

  Container _listSeparator() => Container(height: Margins.spacing_base);

  Widget _listItem(BuildContext context, DemarcheListItem item, DemarcheListPageViewModel viewModel) {
    if (item is DemarcheNotUpToDateItem) {
      return NotUpToDateMessage(message: Strings.demarchesNotUpToDateMessage, onRefresh: viewModel.onRetry);
    } else {
      final id = (item as IdItem).demarcheId;
      return DemarcheCard(
        demarcheId: id,
        source: DemarcheStateSource.demarcheList,
        onTap: () {
          context.trackEvent(EventType.ACTION_DETAIL);
          Navigator.push(context, DemarcheDetailPage.materialPageRoute(id, DemarcheStateSource.demarcheList));
        },
      );
    }
  }

  void _onDidChange(BuildContext context, DemarcheListPageViewModel? previous, DemarcheListPageViewModel current) {
    if (previous?.isReloading == true && _currentDemarchesAreUpToDate(current)) {
      showSnackBarWithInformation(context, Strings.demarchesUpToDate);
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
        : RefreshIndicatorAddingScrollview(
            onRefresh: () async => viewModel.onRetry(),
            child: Empty(
              title: emptyMessage,
              subtitle: Strings.emptyContentSubtitle(Strings.demarche),
            ),
          );
  }
}

class _AddDemarcheButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: PrimaryActionButton(
        icon: AppIcons.add_rounded,
        label: Strings.addADemarche,
        onPressed: () => Navigator.push(context, CreateDemarcheStep1Page.materialPageRoute()).then((value) {
          if (value != null) _showSnackBarWithDetail(context, value);
        }),
      ),
    );
  }

  void _showSnackBarWithDetail(BuildContext context, String demarcheCreatedId) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.createActionEventCategory,
      action: AnalyticsEventNames.createActionDisplaySnackBarAction,
    );
    showSnackBarWithSuccess(
      context,
      Strings.createDemarcheSuccess,
      () {
        PassEmploiMatomoTracker.instance.trackEvent(
          eventCategory: AnalyticsEventNames.createActionEventCategory,
          action: AnalyticsEventNames.createActionClickOnSnackBarAction,
        );
        Navigator.push(
          context,
          DemarcheDetailPage.materialPageRoute(
            demarcheCreatedId,
            DemarcheStateSource.demarcheList,
          ),
        );
      },
    );
  }
}
