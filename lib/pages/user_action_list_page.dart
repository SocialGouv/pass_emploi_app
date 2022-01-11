import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/user_action_details_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/user_action_create_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/user_action_details_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/user_action_list_item.dart';

class UserActionListPage extends TraceableStatefulWidget {
  UserActionListPage() : super(name: AnalyticsScreenNames.userActionList);

  static MaterialPageRoute materialPageRoute(String userId) {
    return MaterialPageRoute(builder: (context) => UserActionListPage());
  }

  @override
  State<UserActionListPage> createState() => _UserActionListPageState();
}

class _UserActionListPageState extends State<UserActionListPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionListPageViewModel>(
      onInit: (store) => store.dispatch(RequestUserActionsAction()),
      builder: (context, viewModel) => _scaffold(context, viewModel, _body(context, viewModel)),
      converter: (store) => UserActionListPageViewModel.create(store),
    );
  }

  Widget _scaffold(BuildContext context, UserActionListPageViewModel viewModel, Widget body) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: Stack(
        children: [
          DefaultAnimatedSwitcher(child: body),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(padding: const EdgeInsets.only(bottom: 24), child: _createUserActionButton(viewModel)),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, UserActionListPageViewModel viewModel) {
    if (viewModel.withLoading) return _loader();
    if (viewModel.withFailure) return Center(child: Retry(Strings.actionsError, () => viewModel.onRetry()));
    if (viewModel.withEmptyMessage) return _empty();
    return _userActionsList(context, viewModel);
  }

  Widget _loader() => Center(child: CircularProgressIndicator(color: AppColors.nightBlue));

  Widget _empty() => Center(child: Text(Strings.noActionsYet, style: TextStyles.textSmRegular()));

  Widget _userActionsList(BuildContext context, UserActionListPageViewModel viewModel) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
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
          child: UserActionListItem(item: item),
        ),
      ),
    );
  }

  Widget _createUserActionButton(UserActionListPageViewModel viewModel) {
    return PrimaryActionButton.simple(
      label: Strings.addAnAction,
      drawableRes: Drawables.icAdd,
      onPressed: () => showUserActionBottomSheet(
        context: context,
        builder: (context) => CreateUserActionBottomSheet(),
      ).then((value) => _onCreateUserActionDismissed(viewModel)),
    );
  }

  void _onUserActionDetailsDismissed(BuildContext context, dynamic value, UserActionListPageViewModel viewModel) {
    if (value != null) {
      if (value == UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.deleteActionSuccess)));
      }
    }
    viewModel.onUserActionDetailsDismissed();
  }

  void _onCreateUserActionDismissed(UserActionListPageViewModel viewModel) {
    viewModel.onCreateUserActionDismissed();
  }
}
