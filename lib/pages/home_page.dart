import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/pages/chat_page.dart';
import 'package:pass_emploi_app/pages/loader_page.dart';
import 'package:pass_emploi_app/presentation/home_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/action_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      converter: (store) => HomeViewModel.create(store),
      builder: (context, viewModel) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _body(context, viewModel),
        );
      },
    );
  }

  _body(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.withLoading) return LoaderPage(screenHeight: MediaQuery.of(context).size.height);
    if (viewModel.withFailure) return _failure(viewModel);
    return _actions(context, viewModel);
  }

  _failure(HomeViewModel viewModel) {
    return Scaffold(
      appBar: _appBar(viewModel.title),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Erreur lors de la récupérations des actions"),
            TextButton(onPressed: () => viewModel.onRetry(), child: Text("Réessayer", style: TextStyles.textLgMedium)),
          ],
        ),
      ),
    );
  }

  _actions(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      appBar: _appBar(viewModel.title),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Margins.medium),
                    child: Text("Mes actions en cours", style: TextStyles.textLgMedium),
                  ),
                  if (viewModel.withoutActionsTodo)
                    Padding(
                      padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
                      child: Text("Tu n’as pas encore d’actions en cours.", style: TextStyles.textSmRegular()),
                    ),
                  for (final todoAction in viewModel.todoActions)
                    Padding(
                      padding: EdgeInsets.only(left: Margins.medium, top: 4, right: Margins.medium, bottom: 4),
                      child: ActionWidget(
                        action: todoAction,
                        onTap: () => viewModel.onTapTodoAction(todoAction.id),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(Margins.medium),
                    child: Text("Mes actions terminées", style: TextStyles.textLgMedium),
                  ),
                  if (viewModel.withoutActionsDone)
                    Padding(
                      padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
                      child: Text("Tu n’as pas encore terminé d’actions.", style: TextStyles.textSmRegular()),
                    ),
                  for (final doneAction in viewModel.doneActions)
                    Padding(
                      padding: EdgeInsets.only(left: Margins.medium, top: 4, right: Margins.medium, bottom: 4),
                      child: ActionWidget(
                        action: doneAction,
                        onTap: () => viewModel.onTapDoneAction(doneAction.id),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.bluePurple,
        child: SvgPicture.asset("assets/ic_envelope.svg"),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage())),
      ),
    );
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
