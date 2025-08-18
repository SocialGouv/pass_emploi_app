import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_page.dart';
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
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class CreateUserActionConfirmationPage extends StatelessWidget {
  final UserActionStateSource source;
  final bool multipleActions;

  const CreateUserActionConfirmationPage({
    super.key,
    required this.source,
    required this.multipleActions,
  });

  static Route<CreateActionFormResult> route(UserActionStateSource source, {required bool multipleActions}) {
    return MaterialPageRoute<CreateActionFormResult>(
      fullscreenDialog: true,
      builder: (_) => CreateUserActionConfirmationPage(
        source: source,
        multipleActions: multipleActions,
      ),
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
                    onGoActionDetail: () =>
                        Navigator.pop(context, NavigateToUserActionDetails(viewModel.actionId, source)),
                    onCreateMore: () => Navigator.pop(context, CreateNewUserAction()),
                    multipleActions: multipleActions,
                    onGoToMonSuivi: () => Navigator.pop(context, NavigateToMonSuivi()),
                  )
                : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            body: _Content(viewModel: viewModel, multipleActions: multipleActions),
          );
        });
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.viewModel, required this.multipleActions});
  final CreateActionSuccessViewModel viewModel;
  final bool multipleActions;

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.displayState) {
      DisplayState.CONTENT => _Body(multipleActions: multipleActions),
      DisplayState.FAILURE => Center(child: ErrorText(Strings.genericCreationError)),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.multipleActions});
  final bool multipleActions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Center(
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
                multipleActions
                    ? Strings.userActionConfirmationTitlePlural
                    : Strings.userActionConfirmationTitleSingular,
                style: TextStyles.textMBold,
              ),
              SizedBox(height: Margins.spacing_s),
              Text(
                multipleActions ? Strings.userActionConfirmationSubtitlePlural : Strings.userActionConfirmationSubtitle,
                style: TextStyles.textSRegular(),
              ),
              SizedBox(height: Margins.spacing_xx_huge),
            ],
          ),
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons(
      {required this.onGoActionDetail,
      required this.onCreateMore,
      required this.multipleActions,
      required this.onGoToMonSuivi});

  final void Function() onGoActionDetail;
  final void Function() onCreateMore;
  final void Function() onGoToMonSuivi;
  final bool multipleActions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (multipleActions)
            AutoFocusA11y(
              child: PrimaryActionButton(
                label: Strings.goToMonSuivi,
                onPressed: onGoToMonSuivi,
              ),
            )
          else
            AutoFocusA11y(
              child: PrimaryActionButton(
                label: Strings.userActionConfirmationSeeDetailButton,
                onPressed: onGoActionDetail,
              ),
            ),
          const SizedBox(height: Margins.spacing_base),
          SecondaryButton(
            label: Strings.userActionConfirmationCreateMoreButton,
            onPressed: onCreateMore,
          ),
        ],
      ),
    );
  }
}
