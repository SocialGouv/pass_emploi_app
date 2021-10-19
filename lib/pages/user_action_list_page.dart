import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/user_action_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat_floating_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/user_action_details_bottom_sheet.dart';

class UserActionListPage extends StatelessWidget {
  final String userId;

  const UserActionListPage._(this.userId) : super();

  static MaterialPageRoute materialPageRoute(String userId) {
    return MaterialPageRoute(
      builder: (context) => UserActionListPage._(userId),
      settings: AnalyticsRouteSettings.userAction(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionListPageViewModel>(
      onInit: (store) => store.dispatch(RequestUserActionsAction(userId)),
      builder: (context, viewModel) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _scaffold(context, viewModel, _body(context, viewModel)),
        );
      },
      converter: (store) => UserActionListPageViewModel.create(store),
    );
  }

  Widget _scaffold(BuildContext context, UserActionListPageViewModel viewModel, Widget body) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: _appBar(),
      body: body,
      floatingActionButton: ChatFloatingActionButton(),
    );
  }

  _appBar() => DefaultAppBar(title: Text(Strings.myActions, style: TextStyles.h3Semi));

  Widget _body(BuildContext context, UserActionListPageViewModel viewModel) {
    if (viewModel.withLoading) return _loader();
    if (viewModel.withFailure) return _failure(viewModel);
    return Container(
      child: _userActions(context, viewModel),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    );
  }

  _loader() => Center(child: CircularProgressIndicator(color: AppColors.nightBlue));

  _failure(UserActionListPageViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Strings.actionsError),
          TextButton(onPressed: () => viewModel.onRetry(), child: Text(Strings.retry, style: TextStyles.textLgMedium)),
        ],
      ),
    );
  }

  Widget _userActions(BuildContext context, UserActionListPageViewModel viewModel) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        itemCount: viewModel.items.length,
        itemBuilder: (context, i) => _tapListener(context, viewModel.items[i], viewModel),
        separatorBuilder: (context, i) => Divider(
          thickness: 1,
          color: AppColors.bluePurpleAlpha20,
        ),
      ),
    );
  }

  Widget _tapListener(BuildContext context, UserActionViewModel item, UserActionListPageViewModel viewModel) {
    return InkWell(
        onTap: () => showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              builder: (context) => UserActionDetailsBottomSheet(viewModel, item),
              isScrollControlled: true,
            ),
        child: _listItem(item, viewModel));
  }

  Widget _listItem(UserActionViewModel item, UserActionListPageViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._addTagIfDone(item),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              item.content,
              style: TextStyles.textSmMedium(),
            ),
          ),
          ..._addCommentIfPresent(item),
        ],
      ),
    );
  }

  List<Widget> _addCommentIfPresent(UserActionViewModel item) {
    if (item.withComment) {
      return [Text(item.comment, style: TextStyles.textSmRegular())];
    } else {
      return [];
    }
  }

  List<Widget> _addTagIfDone(UserActionViewModel item) {
    if (item.isDone) {
      return [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Align(alignment: Alignment.centerLeft, child: _doneTag()),
        )
      ];
    } else {
      return [];
    }
  }

  Container _doneTag() => Container(
        decoration: BoxDecoration(
          color: AppColors.blueGrey,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
            child: Text(
              Strings.actionDone,
              style: TextStyles.textSmMedium(),
            )),
      );
}
