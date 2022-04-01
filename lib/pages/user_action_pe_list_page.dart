import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/presentation/user_action_pe/user_action_pe_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/user_action_pe_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/empty_content.dart';

class UserActionPEListPage extends TraceableStatelessWidget {
  final ScrollController _scrollController = ScrollController();

  UserActionPEListPage() : super(name: AnalyticsScreenNames.userActionList);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionPEListPageViewModel>(
      onInit: (store) => store.dispatch(UserActionPEListRequestAction()),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      converter: (store) => UserActionPEListPageViewModel.create(store),
      distinct: true,
      onDidChange: (previousViewModel, viewModel) {
        if (_scrollController.hasClients) _scrollController.jumpTo(0);
      },
      onDispose: (store) => store.dispatch(UserActionPEListResetAction()),
    );
  }

  Widget _scaffold(BuildContext context, UserActionPEListPageViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Stack(
        children: [
          DefaultAnimatedSwitcher(child: _animatedBody(context, viewModel)),
        ],
      ),
    );
  }

  Widget _animatedBody(BuildContext context, UserActionPEListPageViewModel viewModel) {
    if (viewModel.withLoading) return _loader();
    if (viewModel.withFailure) return Center(child: Retry(Strings.actionsError, () => viewModel.onRetry()));
    if (viewModel.withEmptyMessage) return _empty();
    return _userActionsList(context, viewModel);
  }

  Widget _loader() => Center(child: CircularProgressIndicator(color: AppColors.primary));

  Widget _empty() =>  EmptyContent(contentType: ContentType.ACTIONS);

  Widget _userActionsList(BuildContext context, UserActionPEListPageViewModel viewModel) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: viewModel.items.length,
      itemBuilder: (context, i) => _listItem(context, viewModel.items[i], viewModel),
      separatorBuilder: (context, i) => _listSeparator(),
    );
  }

  Container _listSeparator() => Container(height: Margins.spacing_base);

  Widget _listItem(BuildContext context, UserActionPEListPageItem item, UserActionPEListPageViewModel viewModel) {
    return UserActionPECard(viewModel: (item as UserActionPEListItemViewModel).viewModel);
  }
}
