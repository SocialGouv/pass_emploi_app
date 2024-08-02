import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/user_action/edit/edit_user_action_form.dart';
import 'package:pass_emploi_app/presentation/user_action/update_form/update_user_action_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class UpdateUserActionPage extends StatelessWidget {
  final UserActionStateSource source;
  final String userActionId;

  const UpdateUserActionPage({super.key, required this.source, required this.userActionId});

  static MaterialPageRoute<void> route(UserActionStateSource source, String userActionId) {
    return MaterialPageRoute<void>(
      builder: (_) => UpdateUserActionPage(source: source, userActionId: userActionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.userActionUpdate,
      child: StoreConnector<AppState, UpdateUserActionViewModel>(
        converter: (store) => UpdateUserActionViewModel.create(store, source, userActionId),
        builder: (context, viewModel) => _Body(viewModel),
        onDidChange: (previousViewModel, viewModel) => _popOnUpdateSuccess(context, previousViewModel, viewModel),
        distinct: true,
      ),
    );
  }

  void _popOnUpdateSuccess(
      BuildContext context, UpdateUserActionViewModel? previousViewModel, UpdateUserActionViewModel viewModel) {
    if (viewModel.shouldPop && (previousViewModel?.shouldPop != viewModel.shouldPop)) {
      showSnackBarWithSuccess(context, Strings.updateUserActionConfirmation);
      Navigator.of(context).pop();
    }
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel);

  final UpdateUserActionViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    const bgColor = Colors.white;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: bgColor,
          appBar: SecondaryAppBar(
            title: Strings.updateUserActionPageTitle,
            backgroundColor: bgColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: EditUserActionForm(
              requireUpdate: true,
              confirmationLabel: Strings.updateUserActionSaveButton,
              actionDto: EditUserActionFormDto(
                date: viewModel.date,
                title: viewModel.title,
                description: viewModel.description,
                type: viewModel.type,
              ),
              onSaved: (actionDto) => viewModel.save(
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
