import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_create_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class CreateUserActionFormPage extends StatelessWidget {
  const CreateUserActionFormPage({super.key, required this.onPop});

  final void Function(UserActionCreateDisplayState displayState) onPop;

  static Route<dynamic> route({required void Function(UserActionCreateDisplayState displayState) onPop}) {
    return MaterialPageRoute<void>(
      builder: (_) => CreateUserActionFormPage(onPop: onPop),
    );
  }

  static void displaySnackBarOnResult(
    BuildContext context,
    UserActionCreateDisplayState? result,
    UserActionStateSource source,
    Function() onResult,
  ) {
    if (result is DismissWithSuccess) {
      _showSnackBarWithDetail(context, source, result.userActionCreatedId);
      onResult();
    } else if (result is DismissWithFailure) {
      _showSnackBarForOfflineCreation(context);
      onResult();
    }
  }

  static void _showSnackBarWithDetail(
    BuildContext context,
    UserActionStateSource source,
    String userActionId,
  ) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.createActionEventCategory,
      action: AnalyticsEventNames.createActionDisplaySnackBarAction,
    );
    showSnackBarWithSuccess(
      context,
      Strings.createActionSuccess,
      () {
        PassEmploiMatomoTracker.instance.trackEvent(
          eventCategory: AnalyticsEventNames.createActionEventCategory,
          action: AnalyticsEventNames.createActionClickOnSnackBarAction,
        );
        Navigator.push(context, UserActionDetailPage.materialPageRoute(userActionId, source));
      },
    );
  }

  static void _showSnackBarForOfflineCreation(BuildContext context) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.createActionEventCategory,
      action: AnalyticsEventNames.createActionOfflineAction,
    );
    showSnackBarWithSuccess(context, Strings.createActionPostponed);
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.createUserAction,
      child: StoreConnector<AppState, UserActionCreateViewModel>(
        converter: (state) => UserActionCreateViewModel.create(state),
        builder: (context, viewModel) => _Body(viewModel),
        onWillChange: (previousVm, newVm) => _shouldPop(context, newVm),
      ),
    );
  }

  void _shouldPop(BuildContext context, UserActionCreateViewModel viewModel) {
    final displayState = viewModel.displayState;
    if (displayState is DismissWithSuccess || displayState is DismissWithFailure) {
      onPop.call(displayState);
      Navigator.pop(context, displayState);
    }
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel);
  final UserActionCreateViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CreateUserActionForm(
          onSubmit: (state) => viewModel.createUserAction(state.toRequest),
          onAbort: () => Navigator.pop(context),
        ),
        if (viewModel.displayState.isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
