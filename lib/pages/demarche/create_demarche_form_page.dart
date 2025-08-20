import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/create_demarche_batch/create_demarche_batch_actions.dart';
import 'package:pass_emploi_app/features/demarche/create_demarche_batch/create_demarche_batch_state.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche/create_demarche_success_page.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche/widgets/create_demarche_form.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_personnalisee_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_creation_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class CreateDemarcheFormPage extends StatelessWidget {
  const CreateDemarcheFormPage({super.key});

  static Route<String?> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const CreateDemarcheFormPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.createDemarcheHome,
      child: _CreateDemarcheBatchConnector(
          onCreateSuccess: () => onCreateDemarcheSuccess(context, CreateDemarcheSource.iaFt),
          onCreateFailure: () => _showError(context),
          builder: (context, createDemarcheBatchDisplayState) {
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
                        CreateDemarcheForm(
                          onCreateDemarchePersonnalisee: (createRequest) {
                            createDemarchePersonnaliseeVm.onCreateDemarche(
                                createRequest.commentaire, createRequest.dateEcheance);
                          },
                          onCreateDemarcheFromReferentiel: (createRequest) {
                            createDemarcheVm.onCreateDemarche(createRequest);
                          },
                          onCreateDemarcheIaFt: (createRequests) {
                            final store = StoreProvider.of<AppState>(context);
                            store.dispatch(CreateDemarcheBatchRequestAction(createRequests, genereParIA: true));
                          },
                        ),
                        if (createDemarchePersonnaliseeVm.displayState == DisplayState.LOADING ||
                            createDemarcheVm.displayState == DisplayState.LOADING ||
                            createDemarcheBatchDisplayState == DisplayState.LOADING)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                      ],
                    );
                  },
                );
              },
            );
          }),
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

class _CreateDemarcheBatchConnector extends StatelessWidget {
  const _CreateDemarcheBatchConnector(
      {required this.builder, required this.onCreateSuccess, required this.onCreateFailure});
  final Widget Function(BuildContext, DisplayState) builder;
  final void Function() onCreateSuccess;
  final void Function() onCreateFailure;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DisplayState>(
      builder: builder,
      converter: (store) => switch (store.state.createDemarcheBatchState) {
        CreateDemarcheBatchNotInitializedState() => DisplayState.EMPTY,
        CreateDemarcheBatchLoadingState() => DisplayState.LOADING,
        CreateDemarcheBatchSuccessState() => DisplayState.CONTENT,
        CreateDemarcheBatchFailureState() => DisplayState.FAILURE,
      },
      onDidChange: _onDidChange,
      distinct: true,
    );
  }

  void _onDidChange(
    DisplayState? oldVm,
    DisplayState newVm,
  ) {
    if (oldVm != DisplayState.CONTENT && newVm == DisplayState.CONTENT) {
      onCreateSuccess();
    }
    if (oldVm != DisplayState.FAILURE && newVm == DisplayState.FAILURE) {
      onCreateFailure();
    }
  }
}
