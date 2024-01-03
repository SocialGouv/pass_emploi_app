import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/user_action/update_form/update_user_action_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class UpdateUserActionForm extends StatelessWidget {
  final UserActionStateSource source;
  final String userActionId;

  const UpdateUserActionForm({super.key, required this.source, required this.userActionId});

  static MaterialPageRoute<void> route(UserActionStateSource source, String userActionId) {
    return MaterialPageRoute<void>(
      builder: (_) => UpdateUserActionForm(source: source, userActionId: userActionId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UpdateUserActionViewModel>(
      converter: (store) => UpdateUserActionViewModel.create(store, source, userActionId),
      builder: (context, viewModel) => _Body(viewModel),
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel);
  final UpdateUserActionViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.updateUserActionPageTitle),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Margins.spacing_m),
            Text(
              Strings.mandatoryFields,
              style: TextStyles.textSRegular(),
            ),
          ],
        ),
      ),
    );
  }
}
