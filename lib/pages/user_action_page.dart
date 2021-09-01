import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/pages/chat_page.dart';
import 'package:pass_emploi_app/pages/loader_page.dart';
import 'package:pass_emploi_app/presentation/user_action_item.dart';
import 'package:pass_emploi_app/presentation/user_action_page_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/user_action_widget.dart';

class UserActionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionPageViewModel>(
      converter: (store) => UserActionPageViewModel.create(store),
      builder: (context, viewModel) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _body(context, viewModel),
        );
      },
    );
  }

  _body(BuildContext context, UserActionPageViewModel viewModel) {
    if (viewModel.withLoading) return LoaderPage(screenHeight: MediaQuery.of(context).size.height);
    if (viewModel.withFailure) return _failure(viewModel);
    return _actions(context, viewModel);
  }

  _failure(UserActionPageViewModel viewModel) {
    return Scaffold(
      appBar: _appBar(viewModel.title),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Erreur lors de la récupérations des actions"),
            TextButton(
              onPressed: () => viewModel.onRetry(),
              child: Text("Réessayer", style: TextStyles.textLgMedium),
            ),
            TextButton(
              onPressed: () => viewModel.onLogout(),
              child: Text("Me reconnecter", style: TextStyles.textLgMedium),
            ),
          ],
        ),
      ),
    );
  }

  _actions(BuildContext context, UserActionPageViewModel viewModel) {
    return Scaffold(
      appBar: _appBar(viewModel.title),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
          children: viewModel.items.map((item) => _listItem(item, viewModel)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.bluePurple,
        child: SvgPicture.asset("assets/ic_envelope.svg"),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage())),
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
          onTap: () => viewModel.onTapTodoAction(item.action.id),
        ),
      );
    } else if (item is DoneActionItem) {
      return Padding(
        padding: EdgeInsets.only(top: 4, bottom: 4),
        child: UserActionWidget(
          action: item.action,
          onTap: () => viewModel.onTapDoneAction(item.action.id),
        ),
      );
    }
    return Container();
  }

  _appBar(String title) {
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.nightBlue),
      toolbarHeight: Dimens.appBarHeight,
      backgroundColor: Colors.white,
      elevation: 2,
      title: Text(title, style: TextStyles.h3Semi),
    );
  }
}
