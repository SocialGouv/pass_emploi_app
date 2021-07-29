import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pass_emploi_app/presentation/home_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/action_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var storeConnector = StoreConnector<AppState, HomeViewModel>(
      converter: (store) => HomeViewModel.create(store),
      builder: (context, viewModel) => _body(viewModel),
    );
    StoreProvider.of<AppState>(context).dispatch(BootstrapAction());
    return storeConnector;
  }

  _body(HomeViewModel viewModel) {
    if (viewModel.withLoading) return _loader();
    if (viewModel.withFailure) return _failure();
    if (viewModel.withoutAnyActions) return _withoutAnyActions();
    return _actions(viewModel);
  }

  _loader() {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  _failure() {
    return Scaffold(body: Center(child: Text("Failure"))); // TODO add retry button
  }

  _withoutAnyActions() {
    return Scaffold(body: Center(child: Text("Aucune actions en cours")));
  }

  _actions(HomeViewModel viewModel) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 140,
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
                child: Text(
                  "Mes actions",
                  style: GoogleFonts.rubik(
                    color: AppColors.nightBlue,
                    fontSize: FontSizes.huge,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            Container(
              height: 700,
              color: Colors.white,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.withActionsTodo)
                    Padding(
                      padding: const EdgeInsets.all(Margins.medium),
                      child: Text(
                        "Mes actions à faire",
                        style: GoogleFonts.rubik(
                          color: AppColors.nightBlue,
                          fontSize: FontSizes.large,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
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
                      ),
                    ),
                  if (viewModel.withActionsDone)
                    Padding(
                      padding: const EdgeInsets.all(Margins.medium),
                      child: Text(
                        "Mes actions faites",
                        style: GoogleFonts.rubik(
                          color: AppColors.nightBlue,
                          fontSize: FontSizes.large,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
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
