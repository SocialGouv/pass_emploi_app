import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_confirmation_page.dart';
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

sealed class CreateActionFormResult {}

class CreateNewUserAction extends CreateActionFormResult {}

class NavigateToUserActionDetails extends CreateActionFormResult {
  final String userActionId;
  final UserActionStateSource source;

  NavigateToUserActionDetails(this.userActionId, this.source);
}

class CreateUserActionFormPage extends StatelessWidget {
  const CreateUserActionFormPage(this.source);

  final UserActionStateSource source;

  // NavigatorState is used rather than context, as it may not be available anymore in callbacks.
  static void pushUserActionCreationTunnel(NavigatorState navigator, UserActionStateSource source) {
    navigator
        .push(_route(source)) //
        .then((result) => _handleResult(navigator, result, source));
  }

  static Route<CreateActionFormResult> _route(UserActionStateSource source) {
    return MaterialPageRoute<CreateActionFormResult>(
      fullscreenDialog: true,
      builder: (_) => CreateUserActionFormPage(source),
    );
  }

  static void _handleResult(NavigatorState navigator, CreateActionFormResult? result, UserActionStateSource source) {
    if (result is CreateNewUserAction) {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.createActionv2EventCategory,
        action: AnalyticsEventNames.createActionResultAnotherAction,
      );
      pushUserActionCreationTunnel(navigator, source);
    } else if (result is NavigateToUserActionDetails) {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.createActionv2EventCategory,
        action: AnalyticsEventNames.createActionResultDetailsAction,
      );
      _openDetails(navigator, result.userActionId, result.source);
    } else {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.createActionv2EventCategory,
        action: AnalyticsEventNames.createActionResultDismissAction,
      );
    }
  }

  static void _openDetails(NavigatorState navigator, String userActionId, UserActionStateSource source) {
    navigator.push(UserActionDetailPage.materialPageRoute(userActionId, source));
  }

  static void showSnackBarForOfflineCreation(BuildContext context) {
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
      onWillChange: (previousVm, newVm) => _handleDisplayState(context, newVm),
      distinct: true,
    );
  }

  Future<void> _handleDisplayState(BuildContext context, UserActionCreateViewModel viewModel) async {
    final displayState = viewModel.displayState;
    if (displayState is DismissWithFailure) {
      showSnackBarForOfflineCreation(context);
      Navigator.pop(context);
    } else if (displayState is ShowConfirmationPage) {
      Navigator.push(
        context,
        CreateUserActionConfirmationPage.route(
          displayState.userActionCreatedId,
          source,
        ),
      ).then((result) {
        if (context.mounted) Navigator.pop(context, result);
      });
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
