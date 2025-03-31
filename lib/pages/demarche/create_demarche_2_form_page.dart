import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_2/create_demarche_success_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_2/widgets/create_demarche_2_form.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_personnalisee_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_creation_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

// TODO: [01/04/2025 ] Rename all `create_demarche_2` at the end oh the A/B test

class CreateDemarche2FormPage extends StatelessWidget {
  const CreateDemarche2FormPage({super.key});

  static Route<String?> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const CreateDemarche2FormPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _CreateDemarchePersonnaliseeConnector(
      onCreateSuccess: () => onCreateDemarcheSuccess(context, CreateDemarcheSource.personnalisee),
      onCreateFailure: () => _showError(context),
      builder: (context, createDemarchePersonnaliseeVm) {
        return _CreateDemarcheConnector(
          onCreateSuccess: () => onCreateDemarcheSuccess(context, CreateDemarcheSource.fromReferentiel),
          onCreateFailure: () => _showError(context),
          builder: (context, createDemarcheVm) {
            return Stack(
              children: [
                CreateDemarche2Form(
                  onCreateDemarchePersonnalisee: (createRequest) {
                    createDemarchePersonnaliseeVm.onCreateDemarche(
                        createRequest.commentaire, createRequest.dateEcheance);
                  },
                  onCreateDemarcheFromReferentiel: (createRequest) {
                    createDemarcheVm.onCreateDemarche(createRequest);
                  },
                ),
                if (createDemarchePersonnaliseeVm.displayState == DisplayState.LOADING ||
                    createDemarcheVm.displayState == DisplayState.LOADING)
                  Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            );
          },
        );
      },
    );
  }

  void onCreateDemarcheSuccess(BuildContext context, CreateDemarcheSource source) {
    Navigator.of(context).pop();
    Navigator.of(context).push(CreateDemarcheSuccessPage.route(source));
  }

  void _showError(BuildContext context) {
    showSnackBarWithUserError(context, Strings.createDemarcheErreur);
  }
}

class _CreateDemarchePersonnaliseeConnector extends StatelessWidget {
  const _CreateDemarchePersonnaliseeConnector(
      {required this.builder, required this.onCreateSuccess, required this.onCreateFailure});
  final Widget Function(BuildContext, CreateDemarchePersonnaliseeViewModel) builder;
  final void Function() onCreateSuccess;
  final void Function() onCreateFailure;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateDemarchePersonnaliseeViewModel>(
      builder: builder,
      converter: (store) => CreateDemarchePersonnaliseeViewModel.create(store, false),
      onDidChange: _onDidChange,
      distinct: true,
    );
  }

  void _onDidChange(
    CreateDemarchePersonnaliseeViewModel? oldVm,
    CreateDemarchePersonnaliseeViewModel newVm,
  ) {
    if (oldVm?.demarcheCreationState is! DemarcheCreationSuccessState &&
        newVm.demarcheCreationState is DemarcheCreationSuccessState) {
      onCreateSuccess();
    }
    if (oldVm?.displayState != DisplayState.FAILURE && newVm.displayState == DisplayState.FAILURE) {
      onCreateFailure();
    }
  }
}

class _CreateDemarcheConnector extends StatelessWidget {
  const _CreateDemarcheConnector({required this.builder, required this.onCreateSuccess, required this.onCreateFailure});
  final Widget Function(BuildContext, CreateDemarcheViewModel) builder;
  final void Function() onCreateSuccess;
  final void Function() onCreateFailure;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateDemarcheViewModel>(
      builder: builder,
      converter: (store) => CreateDemarcheViewModel.create(store),
      onDidChange: _onDidChange,
      distinct: true,
    );
  }

  void _onDidChange(
    CreateDemarcheViewModel? oldVm,
    CreateDemarcheViewModel newVm,
  ) {
    if (oldVm?.demarcheCreationState is! DemarcheCreationSuccessState &&
        newVm.demarcheCreationState is DemarcheCreationSuccessState) {
      onCreateSuccess();
    }
    if (oldVm?.displayState != DisplayState.FAILURE && newVm.displayState == DisplayState.FAILURE) {
      onCreateFailure();
    }
  }
}
