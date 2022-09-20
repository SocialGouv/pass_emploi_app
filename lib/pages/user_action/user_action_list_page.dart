import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/campagne/campagne_details_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/user_action_create_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/campagne_card.dart';
import 'package:pass_emploi_app/widgets/cards/user_action_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/empty_page.dart';
import 'package:pass_emploi_app/widgets/loader.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class UserActionListPage extends StatefulWidget {
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
        onDidChange: (previousViewModel, viewModel) {
          _openDeeplinkIfNeeded(viewModel, context);
        },
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
    if (viewModel.withLoading) return loader();
    if (viewModel.withFailure) return Center(child: Retry(Strings.actionsError, () => viewModel.onRetry()));
    if (viewModel.withEmptyMessage) return Empty(description: Strings.noActionsYet);
    return _userActionsList(context, viewModel);
  }

  Widget _userActionsList(BuildContext context, UserActionListPageViewModel viewModel) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: viewModel.items.length,
      itemBuilder: (context, i) => _listItem(context, viewModel.items[i], viewModel),
      separatorBuilder: (context, i) => _listSeparator(),
    );
  }

  Container _listSeparator() => Container(height: Margins.spacing_base);

  Widget _listItem(BuildContext context, UserActionListPageItem item, UserActionListPageViewModel viewModel) {
    if (item is SubtitleItem) {
      return Padding(
        padding: const EdgeInsets.only(top: Margins.spacing_base),
        child: Text(item.title, style: TextStyles.textMBold),
      );
    } else if (item is CampagneItem) {
      return _CampagneCard(title: item.titre, description: item.description);
    } else {
      final actionId = (item as IdItem).userActionId;
      return UserActionCard(
        userActionId: actionId,
        stateSource: UserActionStateSource.list,
        onTap: () {
          context.trackEvent(EventType.ACTION_DETAIL);
          Navigator.push(
            context,
            UserActionDetailPage.materialPageRoute(actionId, UserActionStateSource.list),
          );
        },
      );
    }
  }

  Widget _createUserActionButton(UserActionListPageViewModel viewModel) {
    return PrimaryActionButton(
      label: Strings.addAnAction,
      drawableRes: Drawables.icAdd,
      rippleColor: AppColors.primaryDarken,
      onPressed: () => showPassEmploiBottomSheet(
        context: context,
        builder: (context) => CreateUserActionBottomSheet(),
      ).then((value) => _onCreateUserActionDismissed(viewModel)),
    );
  }

  void _onCreateUserActionDismissed(UserActionListPageViewModel viewModel) {
    viewModel.onCreateUserActionDismissed();
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
