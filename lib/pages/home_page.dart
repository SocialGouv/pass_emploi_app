import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/loader_page.dart';
import 'package:pass_emploi_app/presentation/home_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/action_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var storeConnector = StoreConnector<AppState, HomeViewModel>(
      converter: (store) => HomeViewModel.create(store),
      builder: (context, viewModel) => _body(context, viewModel),
    );
    StoreProvider.of<AppState>(context).dispatch(BootstrapAction());
    return storeConnector;
  }

  _body(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.withLoading) return LoaderPage(screenHeight: MediaQuery.of(context).size.height);
    if (viewModel.withFailure) return _failure(viewModel);
    return _actions(viewModel);
  }

  _failure(HomeViewModel viewModel) {
    return Scaffold(
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

  _actions(HomeViewModel viewModel) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 122,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.blue, AppColors.purple],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: Margins.medium, top: 68),
                child: Text("Vos actions", style: TextStyles.h3Semi),
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Margins.medium),
                    child: Text("Mes actions en cours", style: TextStyles.textLgSemi),
                  ),
                  if (viewModel.withoutActionsTodo)
                    Padding(
                      padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
                      child: Text("Vous n’avez pas encore d’actions en cours.", style: TextStyles.textSmRegular),
                    ),
                  for (final todoAction in viewModel.todoActions)
                    Padding(
                      padding: EdgeInsets.only(
                        left: Margins.medium,
                        top: 4,
                        right: Margins.medium,
                        bottom: 4,
                      ),
                      child: ActionWidget(
                        action: todoAction,
                        onTap: () => viewModel.onTapTodoAction(todoAction.id),
                        borderColor: AppColors.borderGrey,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(Margins.medium),
                    child: Text("Mes actions terminées", style: TextStyles.textLgSemi),
                  ),
                  if (viewModel.withoutActionsDone)
                    Padding(
                      padding: const EdgeInsets.only(left: Margins.medium, right: Margins.medium),
                      child: Text("Vous n’avez pas encore d’actions terminées.", style: TextStyles.textSmRegular),
                    ),
                  for (final doneAction in viewModel.doneActions)
                    Padding(
                      padding: EdgeInsets.only(
                        left: Margins.medium,
                        top: 4,
                        right: Margins.medium,
                        bottom: 4,
                      ),
                      child: ActionWidget(
                        action: doneAction,
                        onTap: () => viewModel.onTapDoneAction(doneAction.id),
                        borderColor: AppColors.nightBlue,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
