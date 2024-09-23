import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_page.dart';
import 'package:pass_emploi_app/pages/user_action/duplicate/widgets/duplicate_user_action_confirmation_page.dart';
import 'package:pass_emploi_app/pages/user_action/edit/edit_user_action_form.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/presentation/user_action/duplicate_form/duplicate_user_action_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_create_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class DuplicateUserActionPage extends StatelessWidget {
  final UserActionStateSource source;
  final String userActionId;

  const DuplicateUserActionPage({super.key, required this.source, required this.userActionId});

  static MaterialPageRoute<void> route(UserActionStateSource source, String userActionId) {
    return MaterialPageRoute<void>(
      builder: (_) => DuplicateUserActionPage(source: source, userActionId: userActionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.userActionDuplicate,
      child: StoreConnector<AppState, DuplicateUserActionViewModel>(
        converter: (store) => DuplicateUserActionViewModel.create(store, source, userActionId),
        builder: (context, viewModel) => _Body(viewModel),
        onWillChange: (previousVm, newVm) => _handleDisplayState(context, newVm),
        distinct: true,
      ),
    );
  }

  Future<void> _handleDisplayState(BuildContext context, DuplicateUserActionViewModel viewModel) async {
    final displayState = viewModel.displayState;
    if (displayState is DismissWithFailure) {
      CreateUserActionFormPage.showSnackBarForOfflineCreation(context);
      Navigator.pop(context);
    } else if (displayState is ShowConfirmationPage) {
      Navigator.push(
        context,
        DuplicateUserActionConfirmationPage.route(
          displayState.userActionCreatedId,
          source,
        ),
      ).then((result) {
        if (!context.mounted) return;
        Navigator.pop(context);
        if (result is NavigateToUserActionDetails) {
          Navigator.push(context, UserActionDetailPage.materialPageRoute(result.userActionId, result.source));
        }
      });
    }
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel);

  final DuplicateUserActionViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    const bgColor = Colors.white;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: bgColor,
          appBar: SecondaryAppBar(
            title: Strings.duplicateUserAction,
            backgroundColor: bgColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: EditUserActionForm(
              confirmationLabel: Strings.duplicateUserAction,
              requireUpdate: false,
              actionDto: EditUserActionFormDto(
                date: viewModel.date,
                title: viewModel.title,
                description: viewModel.description,
                type: viewModel.type,
              ),
              onSaved: (actionDto) => viewModel.duplicate(
                actionDto.date,
                actionDto.title,
                actionDto.description,
                actionDto.type,
              ),
            ),
          ),
        ),
        if (viewModel.showLoading)
          ColoredBox(
            color: Colors.white.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
