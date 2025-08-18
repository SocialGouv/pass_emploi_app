import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_confirmation_page.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form.dart';
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

class NavigateToMonSuivi extends CreateActionFormResult {}

class CreateUserActionFormPage extends StatefulWidget {
  const CreateUserActionFormPage(this.source);

  final UserActionStateSource source;

  // NavigatorState is used rather than context, as it may not be available anymore in callbacks.
  static void pushUserActionCreationTunnel(
      BuildContext context, NavigatorState navigator, UserActionStateSource source) {
    navigator
        .push(_route(source)) //
        .then((result) {
      if (context.mounted) _handleResult(context, navigator, result, source);
    });
  }

  static Route<CreateActionFormResult> _route(UserActionStateSource source) {
    return MaterialPageRoute<CreateActionFormResult>(
      fullscreenDialog: true,
      builder: (_) => CreateUserActionFormPage(source),
    );
  }

  static void _handleResult(
      BuildContext context, NavigatorState navigator, CreateActionFormResult? result, UserActionStateSource source) {
    if (result is CreateNewUserAction) {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.createActionv2EventCategory,
        action: AnalyticsEventNames.createActionResultAnotherAction,
      );
      pushUserActionCreationTunnel(context, navigator, source);
    } else if (result is NavigateToUserActionDetails) {
      PassEmploiMatomoTracker.instance.trackEvent(
        eventCategory: AnalyticsEventNames.createActionv2EventCategory,
        action: AnalyticsEventNames.createActionResultDetailsAction,
      );
      _openDetails(navigator, result.userActionId, result.source);
    } else if (result is NavigateToMonSuivi) {
      StoreProvider.of<AppState>(context).dispatch(
        HandleDeepLinkAction(
          MonSuiviDeepLink(),
          DeepLinkOrigin.inAppNavigation,
        ),
      );
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
  State<CreateUserActionFormPage> createState() => _CreateUserActionFormPageState();
}

class _CreateUserActionFormPageState extends State<CreateUserActionFormPage> {
  bool multipleActions = false;
  bool successShown = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionCreateViewModel>(
      converter: (state) => UserActionCreateViewModel.create(state),
      builder: (context, viewModel) => _Body(viewModel, (numberOfActions) {
        if (numberOfActions > 1) {
          multipleActions = true;
        }
      }),
      onWillChange: (previousVm, newVm) => _handleDisplayState(context, newVm),
      distinct: true,
    );
  }

  Future<void> _handleDisplayState(BuildContext context, UserActionCreateViewModel viewModel) async {
    final displayState = viewModel.displayState;
    if (displayState is DismissWithFailure) {
      CreateUserActionFormPage.showSnackBarForOfflineCreation(context);
      Navigator.pop(context);
    } else if (displayState is ShowConfirmationPage) {
      if (successShown) return;
      Navigator.push(
        context,
        CreateUserActionConfirmationPage.route(widget.source, multipleActions: multipleActions),
      ).then((result) {
        if (context.mounted) Navigator.pop(context, result);
      });
      successShown = true;
    }
  }
}

class _Body extends StatelessWidget {
  final UserActionCreateViewModel _viewModel;
  final void Function(int numberOfActions) _onSubmit;

  const _Body(this._viewModel, this._onSubmit);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CreateUserActionForm(
          onSubmit: (viewModel) {
            final requests = viewModel.toRequests;
            _viewModel.createUserActions(requests);
            _trackActionSubmitted(viewModel, requests.length);
            _onSubmit(requests.length);
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

void _trackActionSubmitted(CreateUserActionFormViewModel viewModel, int numberOfActions) {
  for (var i = 0; i < numberOfActions; i++) {
    final category = viewModel.step1.actionCategory;
    if (category != null) _trackCategorySelected(category);
    _trackTitleSelected(viewModel.step2.titleSource);
  }
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
