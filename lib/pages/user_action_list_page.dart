import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/user_action_details_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/user_action_create_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/user_action_details_bottom_sheet.dart';

enum UserActionListPageResult { UPDATED, UNCHANGED }

class UserActionListPage extends TraceableStatefulWidget {
  final String userId;

  UserActionListPage(this.userId) : super(name: AnalyticsScreenNames.userActionList);

  static MaterialPageRoute materialPageRoute(String userId) {
    return MaterialPageRoute(builder: (context) => UserActionListPage(userId));
  }

  @override
  State<UserActionListPage> createState() => _UserActionListPageState();
}

class _UserActionListPageState extends State<UserActionListPage> {
  var _result = UserActionListPageResult.UNCHANGED;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionListPageViewModel>(
      onInit: (store) => store.dispatch(RequestUserActionsAction(widget.userId)),
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _result);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBlue,
        appBar: _appBar(context, viewModel),
        body: body,
      ),
    );
  }

  _appBar(BuildContext context, UserActionListPageViewModel viewModel) => FlatDefaultAppBar(
        title: Text(Strings.myActions, style: TextStyles.h3Semi),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              iconSize: 42,
              onPressed: () => showUserActionBottomSheet(
                context: context,
                builder: (context) => CreateUserActionBottomSheet(),
              ).then((value) => _onCreateUserActionDismissed(value, viewModel)),
              tooltip: Strings.addAnAction,
              icon: SvgPicture.asset("assets/ic_add_circle.svg"),
            ),
          ),
        ],
      );

  Widget _body(BuildContext context, UserActionListPageViewModel viewModel) {
    if (viewModel.withLoading) return _loader();
    if (viewModel.withFailure) return _failure(viewModel);
    if (viewModel.withEmptyMessage) return _empty();
    return _userActions(context, viewModel);
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

  _empty() => Center(child: Text(Strings.noActionsYet, style: TextStyles.textSmRegular()));

  Widget _userActions(BuildContext context, UserActionListPageViewModel viewModel) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      itemCount: viewModel.items.length,
      itemBuilder: (context, i) => _tapListener(context, viewModel.items[i], viewModel),
      separatorBuilder: (context, i) => _listSeparator(),
    );
  }

  Container _listSeparator() => Container(height: 1, color: AppColors.bluePurpleAlpha20);

  Widget _tapListener(BuildContext context, UserActionViewModel item, UserActionListPageViewModel viewModel) {
    return Container(
      color: Colors.white,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => showUserActionBottomSheet(
            context: context,
            builder: (context) => UserActionDetailsBottomSheet(item),
          ).then((value) => _onUserActionDetailsDismissed(context, value, viewModel)),
          splashColor: AppColors.bluePurple,
          child: _listItem(item, viewModel),
        ),
      ),
    );
  }

  Widget _listItem(UserActionViewModel item, UserActionListPageViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (item.tag != null)
            _tagPadding(
              tag: _tag(
                  title: item.tag!.title, backgroundColor: item.tag!.backgroundColor, textColor: item.tag!.textColor),
            ),
          if (item.tag != null) SizedBox(height: 4),
          Text(
            item.content,
            style: TextStyles.textSmMedium(),
          ),
          SizedBox(height: 4),
          if (item.withComment) Text(item.comment, style: TextStyles.textSmRegular())
        ],
      ),
    );
  }

  Padding _tagPadding({required Widget tag}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Align(alignment: Alignment.centerLeft, child: tag),
    );
  }

  Container _tag({required String title, required Color backgroundColor, required Color textColor}) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
          child: Text(
            title,
            style: TextStyles.textSmMedium(color: textColor),
          )),
    );
  }

  _onUserActionDetailsDismissed(BuildContext context, dynamic value, UserActionListPageViewModel viewModel) {
    if (value != null) {
      _result = UserActionListPageResult.UPDATED;
      if (value == UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.deleteActionSuccess)));
      }
    }
    viewModel.onUserActionDetailsDismissed();
  }

  _onCreateUserActionDismissed(dynamic value, UserActionListPageViewModel viewModel) {
    if (value != null) {
      _result = UserActionListPageResult.UPDATED;
    }
    viewModel.onCreateUserActionDismissed();
  }
}
