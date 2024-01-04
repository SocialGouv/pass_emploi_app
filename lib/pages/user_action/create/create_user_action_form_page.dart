import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_step1.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
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
      fullscreenDialog: true,
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
    return StoreConnector<AppState, UserActionCreateViewModel>(
      converter: (state) => UserActionCreateViewModel.create(state),
      builder: (context, viewModel) => _Body(viewModel),
      onWillChange: (previousVm, newVm) => _shouldPop(context, newVm),
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
  final UserActionCreateViewModel _viewModel;

  const _Body(this._viewModel);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CreateUserActionForm(
          onSubmit: (viewModel) {
            _viewModel.createUserAction(viewModel.toRequest);
            _trackActionSubmitted(viewModel);
          },
          onAbort: () => Navigator.pop(context),
        ),
        if (_viewModel.displayState.isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

void _trackActionSubmitted(CreateUserActionFormViewModel viewModel) {
  final category = viewModel.step1.actionCategory;
  if (category != null) _trackCategorySelected(category);
  _trackTitleSelected(viewModel.step2.titleSource);
  _trackStatusSelected(viewModel.step3.estTerminee);
  _trackRappelSelected(viewModel.step3.withRappel);
}

void _trackCategorySelected(UserActionReferentielType type) {
  PassEmploiMatomoTracker.instance.trackEvent(
    eventCategory: AnalyticsEventNames.createActionStep1CategoryCategory,
    action: AnalyticsEventNames.createActionStep1Action(type.label),
  );
}

void _trackTitleSelected(CreateActionTitleSource titleSource) {
  PassEmploiMatomoTracker.instance.trackEvent(
    eventCategory: AnalyticsEventNames.createActionStep2TitleCategory,
    action: titleSource.isFromSuggestions
        ? AnalyticsEventNames.createActionStep2TitleFromSuggestionAction
        : AnalyticsEventNames.createActionStep2TitleNotFromSuggestionAction,
  );
}

void _trackStatusSelected(bool estTerminee) {
  PassEmploiMatomoTracker.instance.trackEvent(
    eventCategory: AnalyticsEventNames.createActionStep3StatusCategory,
    action: estTerminee
        ? AnalyticsEventNames.createActionStep3TermineAction
        : AnalyticsEventNames.createActionStep3EnCoursAction,
  );
}

void _trackRappelSelected(bool withRappel) {
  PassEmploiMatomoTracker.instance.trackEvent(
    eventCategory: AnalyticsEventNames.createActionStep3RappelCategory,
    action: withRappel
        ? AnalyticsEventNames.createActionStep3AvecRappelAction
        : AnalyticsEventNames.createActionStep3SansRappelAction,
  );
}
