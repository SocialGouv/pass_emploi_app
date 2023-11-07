import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_actions_loading.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_create_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/user_action_create_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/user_action_card.dart';
import 'package:pass_emploi_app/widgets/cards/user_actions_postponed_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/empty_page.dart';
import 'package:pass_emploi_app/widgets/refresh_indicator_ext.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class UserActionListPage extends StatefulWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: SecondaryAppBar(title: Strings.actionsTabTitle),
          body: UserActionListPage(),
        );
      },
    );
  }

  @override
  State<UserActionListPage> createState() => _UserActionListPageState();
}

class _UserActionListPageState extends State<UserActionListPage> {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.userActionList,
      child: StoreConnector<AppState, UserActionListPageViewModel>(
        onInit: (store) => store.dispatch(UserActionListRequestAction()),
        builder: (context, viewModel) => _scaffold(context, viewModel),
        converter: (store) => UserActionListPageViewModel.create(store),
        distinct: true,
        onDidChange: (previousViewModel, viewModel) => _openDeeplinkIfNeeded(viewModel, context),
        onDispose: (store) => store.dispatch(UserActionListResetAction()),
      ),
    );
  }

  void _openDeeplinkIfNeeded(UserActionListPageViewModel viewModel, BuildContext context) {
    if (viewModel.deeplinkActionId != null) {
      Navigator.push(
        context,
        UserActionDetailPage.materialPageRoute(viewModel.deeplinkActionId!, UserActionStateSource.list),
      );
      viewModel.onDeeplinkUsed();
    }
  }

  Widget _scaffold(BuildContext context, UserActionListPageViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Stack(
        children: [
          DefaultAnimatedSwitcher(child: _animatedBody(context, viewModel)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(padding: const EdgeInsets.only(bottom: 24), child: _createUserActionButton(viewModel)),
          ),
        ],
      ),
    );
  }

  Widget _animatedBody(BuildContext context, UserActionListPageViewModel viewModel) {
    if (viewModel.withLoading) return UserActionsLoading();
    if (viewModel.withFailure) return Center(child: Retry(Strings.actionsError, () => viewModel.onRetry()));
    if (viewModel.withEmptyMessage) {
      return _Empty(
        pendingCreations: viewModel.pendingCreationCount,
        onRetry: () => viewModel.onRetry(),
      );
    }
    return _userActionsList(context, viewModel);
  }

  Widget _userActionsList(BuildContext context, UserActionListPageViewModel viewModel) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => viewModel.onRetry(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        itemCount: viewModel.items.length,
        itemBuilder: (context, i) => _listItem(context, viewModel.items[i], viewModel),
        separatorBuilder: (context, i) => _listSeparator(),
      ),
    );
  }

  Container _listSeparator() => Container(height: Margins.spacing_base);

  Widget _listItem(BuildContext context, UserActionListPageItem item, UserActionListPageViewModel viewModel) {
    return switch (item) {
      PendingActionCreationItem() => UserActionsPostponedCard(item.pendingCreationsCount),
      SubtitleItem() => Padding(
          padding: const EdgeInsets.only(top: Margins.spacing_base),
          child: Text(item.title, style: TextStyles.textMBold),
        ),
      IdItem() => UserActionCard(
          userActionId: item.userActionId,
          stateSource: UserActionStateSource.list,
          onTap: () {
            context.trackEvent(EventType.ACTION_DETAIL);
            Navigator.push(
              context,
              UserActionDetailPage.materialPageRoute(item.userActionId, UserActionStateSource.list),
            );
          },
        ),
    };
  }

  Widget _createUserActionButton(UserActionListPageViewModel viewModel) {
    return PrimaryActionButton(
      label: Strings.addAnAction,
      icon: AppIcons.add_rounded,
      rippleColor: AppColors.primaryDarken,
      onPressed: () => Navigator.push(
        context,
        CreateUserActionBottomSheet.materialPageRoute(),
      ).then((value) {
        if (value is DismissWithSuccess) {
          _showSnackBarWithDetail(value.userActionCreatedId);
          viewModel.onCreateUserActionDismissed();
        } else if (value is DismissWithFailure) {
          showSuccessfulSnackBar(context, Strings.createActionPostponed);
          viewModel.onCreateUserActionDismissed();
        }
      }),
    );
  }

  void _showSnackBarWithDetail(String userActionId) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.createActionEventCategory,
      action: AnalyticsEventNames.createActionDisplaySnackBarAction,
    );
    showSuccessfulSnackBar(
      context,
      Strings.createActionSuccess,
      () {
        PassEmploiMatomoTracker.instance.trackEvent(
          eventCategory: AnalyticsEventNames.createActionEventCategory,
          action: AnalyticsEventNames.createActionClickOnSnackBarAction,
        );
        Navigator.push(context, UserActionDetailPage.materialPageRoute(userActionId, UserActionStateSource.list));
      },
    );
  }
}

class _Empty extends StatelessWidget {
  final int? pendingCreations;
  final Function() onRetry;

  const _Empty({required this.pendingCreations, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicatorAddingScrollview(
      onRefresh: () async => onRetry(),
      child: Column(
        children: [
          if (pendingCreations != null)
            Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: UserActionsPostponedCard(pendingCreations!),
            ),
          Expanded(child: Empty(title: Strings.noActionsYet, subtitle: Strings.emptyContentSubtitle(Strings.action))),
        ],
      ),
    );
  }
}
