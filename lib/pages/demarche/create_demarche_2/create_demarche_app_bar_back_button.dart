import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_display_state.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton(this.viewModel);
  final CreateDemarcheFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: switch (viewModel.displayState) {
        CreateDemarche2Step1() => () => Navigator.pop(context),
        _ => () => viewModel.onNavigateBackward(),
      },
      icon: switch (viewModel.displayState) {
        CreateDemarche2Step1() => Icon(Icons.close_rounded),
        _ => Icon(Icons.arrow_back_rounded),
      },
    );
  }
}
