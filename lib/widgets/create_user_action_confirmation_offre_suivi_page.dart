import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_page.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/create_user_action_confirmation_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class CreateUserActionConfirmationOffreSuiviPage extends StatelessWidget {
  const CreateUserActionConfirmationOffreSuiviPage({super.key});

  static Route<CreateActionFormResult> route() {
    return MaterialPageRoute<CreateActionFormResult>(
      fullscreenDialog: true,
      builder: (_) => CreateUserActionConfirmationOffreSuiviPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateActionSuccessViewModel>(
        converter: (store) => CreateActionSuccessViewModel.create(store),
        builder: (context, viewModel) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: SecondaryAppBar(title: Strings.createActionAppBarTitle, backgroundColor: Colors.white),
            floatingActionButton: viewModel.displayState == DisplayState.CONTENT
                ? _Buttons(
                    onGoActionDetail: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                          UserActionDetailPage.materialPageRoute(viewModel.actionId, UserActionStateSource.noSource));
                    },
                  )
                : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            body: _Content(viewModel: viewModel),
          );
        });
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.viewModel});
  final CreateActionSuccessViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.displayState) {
      DisplayState.CONTENT => _Body(),
      DisplayState.FAILURE => Center(child: ErrorText(Strings.genericCreationError)),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Margins.spacing_xl),
            Center(
              child: SizedBox(
                height: 130,
                width: 130,
                child: Illustration.green(AppIcons.check_rounded),
              ),
            ),
            SizedBox(height: Margins.spacing_xl),
            Text(
              Strings.userActionConfirmationTitle,
              style: TextStyles.textMBold,
            ),
            SizedBox(height: Margins.spacing_s),
            Text(
              Strings.userActionConfirmationSubtitle,
              style: TextStyles.textSRegular(),
            ),
            SizedBox(height: Margins.spacing_xx_huge),
          ],
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({required this.onGoActionDetail});

  final void Function() onGoActionDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AutoFocusA11y(
            child: PrimaryActionButton(
              label: Strings.userActionConfirmationSeeDetailButton,
              onPressed: onGoActionDetail,
            ),
          ),
        ],
      ),
    );
  }
}
