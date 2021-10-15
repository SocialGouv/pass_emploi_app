import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/user_action_item.dart';
import 'package:pass_emploi_app/presentation/user_action_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat_floating_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/user_action_widget.dart';

enum UserActionPageResult { UPDATED, UNCHANGED }

class UserActionPage extends StatefulWidget {
  final String userId;

  UserActionPage._(this.userId) : super();

  static MaterialPageRoute materialPageRoute(String userId) {
    return MaterialPageRoute(
      builder: (context) => UserActionPage._(userId),
      settings: AnalyticsRouteSettings.userAction(),
    );
  }

  @override
  _UserActionPageState createState() => _UserActionPageState();
}

class _UserActionPageState extends State<UserActionPage> {
  var _result = UserActionPageResult.UNCHANGED;

  @override
  Widget build(BuildContext context) {
    final storeConnector = StoreConnector<AppState, UserActionPageViewModel>(
      converter: (store) => UserActionPageViewModel.create(store),
      builder: (context, viewModel) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _scaffold(context, viewModel, _body(viewModel)),
        );
      },
    );
    StoreProvider.of<AppState>(context).dispatch(RequestUserActionsAction(widget.userId));
    return storeConnector;
  }

  _scaffold(BuildContext context, UserActionPageViewModel viewModel, Widget body) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _result);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: _appBar(viewModel.title),
        body: body,
        floatingActionButton: ChatFloatingActionButton(),
      ),
    );
  }

  _appBar(String title) {
    return DefaultAppBar(title: Text(title, style: TextStyles.h3Semi));
  }

  _body(UserActionPageViewModel viewModel) {
    if (viewModel.withLoading) return _loader();
    if (viewModel.withFailure) return _failure(viewModel);
    return _userActions(viewModel);
  }

  _loader() {
    return Center(child: CircularProgressIndicator(color: AppColors.nightBlue));
  }

  _failure(UserActionPageViewModel viewModel) {
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

  _userActions(UserActionPageViewModel viewModel) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
        children: viewModel.items.map((item) => _listItem(item, viewModel)).toList(),
      ),
    );
  }

  Widget _listItem(UserActionItem item, UserActionPageViewModel viewModel) {
    if (item is SectionItem) {
      return Padding(
        padding: const EdgeInsets.only(top: Margins.medium, bottom: Margins.medium),
        child: Text(item.title, style: TextStyles.textLgMedium),
      );
    } else if (item is MessageItem) {
      return Padding(
        padding: const EdgeInsets.only(top: Margins.medium, bottom: Margins.medium),
        child: Text(item.message, style: TextStyles.textSmRegular()),
      );
    } else if (item is TodoActionItem) {
      return Padding(
        padding: EdgeInsets.only(top: 4, bottom: 4),
        child: UserActionWidget(
          action: item.action,
          onTap: () {
            _result = UserActionPageResult.UPDATED;
            return viewModel.onTapTodoAction(item.action.id);
          },
        ),
      );
    } else if (item is DoneActionItem) {
      return Padding(
        padding: EdgeInsets.only(top: 4, bottom: 4),
        child: UserActionWidget(
          action: item.action,
          onTap: () {
            _result = UserActionPageResult.UPDATED;
            return viewModel.onTapDoneAction(item.action.id);
          },
        ),
      );
    }
    return Container();
  }
}
