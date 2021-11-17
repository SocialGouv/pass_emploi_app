import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/loader_page.dart';
import 'package:pass_emploi_app/pages/rendezvous_page.dart';
import 'package:pass_emploi_app/pages/user_action_list_page.dart';
import 'package:pass_emploi_app/presentation/home_item.dart';
import 'package:pass_emploi_app/presentation/home_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/user_action_card.dart';

class HomePage extends TraceableStatelessWidget {
  final String userId;

  HomePage(this.userId) : super(name: AnalyticsScreenNames.home);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomePageViewModel>(
      onInit: (store) => store.dispatch(RequestHomeAction(userId)),
      converter: (store) => HomePageViewModel.create(store),
      builder: (context, viewModel) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _body(context, viewModel),
        );
      },
    );
  }

  Widget _body(BuildContext context, HomePageViewModel viewModel) {
    if (viewModel.withLoading) return LoaderPage(screenHeight: MediaQuery.of(context).size.height);
    if (viewModel.withFailure) return _failure(viewModel);
    return _home(context, viewModel);
  }

  Widget _failure(HomePageViewModel viewModel) {
    return Scaffold(
      appBar: _appBar(viewModel.title),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Strings.dashboardError),
            TextButton(
              onPressed: () => viewModel.onRetry(),
              child: Text(Strings.retry, style: TextStyles.textLgMedium),
            ),
            TextButton(
              onPressed: () => viewModel.onLogout(),
              child: Text(Strings.reconnect, style: TextStyles.textLgMedium),
            ),
          ],
        ),
      ),
    );
  }

  Widget _home(BuildContext context, HomePageViewModel viewModel) {
    return Scaffold(
      appBar: _appBar(viewModel.title),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
          children: viewModel.items.map((item) => _listItem(context, item, viewModel)).toList(),
        ),
      ),
    );
  }

  Widget _listItem(BuildContext context, HomeItem item, HomePageViewModel viewModel) {
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
    } else if (item is ActionItem) {
      return Padding(
        padding: EdgeInsets.only(top: 6, bottom: 6),
        child: UserActionCard(action: item.action, onTap: () => _pushUserActionPage(context, viewModel)),
      );
    } else if (item is AllActionsButtonItem) {
      return Padding(
        padding: EdgeInsets.only(top: 6, bottom: 6),
        child: _allActionsButton(context, viewModel),
      );
    } else if (item is RendezvousItem) {
      return Padding(
        padding: EdgeInsets.only(top: 6, bottom: 6),
        child: RendezvousCard(
          rendezvous: item.rendezvous,
          onTap: () => Navigator.push(context, RendezvousPage.materialPageRoute(item.rendezvous)),
        ),
      );
    }
    return Container();
  }

  AppBar _appBar(String title) {
    return DefaultAppBar(
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.h3Semi),
          SizedBox(height: 4),
          Text(Strings.dashboardWelcome, style: TextStyles.textSmMedium()),
        ],
      ),
    );
  }

  Widget _allActionsButton(BuildContext context, HomePageViewModel viewModel) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(color: AppColors.nightBlue, borderRadius: BorderRadius.all(Radius.circular(8))),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          onTap: () => _pushUserActionPage(context, viewModel),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(child: Text(Strings.seeAllActions, style: TextStyles.textSmMedium(color: Colors.white))),
          ),
        ),
      ),
    );
  }

  Future<Null> _pushUserActionPage(BuildContext context, HomePageViewModel viewModel) {
    return Navigator.push(
      context,
      UserActionListPage.materialPageRoute(viewModel.userId),
    ).then((value) {
      if (value == UserActionListPageResult.UPDATED) viewModel.onRetry();
    });
  }
}
