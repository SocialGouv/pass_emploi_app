import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form_step1_page.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form_step2_page.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form_step3_page.dart';
import 'package:pass_emploi_app/pages/user_action_form/form_state/create_user_action_form_state.dart';
import 'package:pass_emploi_app/pages/user_action_form/widgets/user_action_stepper.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class CreateUserActionFromPage extends StatefulWidget {
  const CreateUserActionFromPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(builder: (_) => const CreateUserActionFromPage());
  }

  @override
  State<CreateUserActionFromPage> createState() => _CreateUserActionFromPageState();
}

class _CreateUserActionFromPageState extends State<CreateUserActionFromPage> {
  late final CreateUserActionFormState _formState;

  @override
  void initState() {
    super.initState();
    _formState = CreateUserActionFormState();
    _formState.addListener(_onFormStateChanged);
  }

  void _onFormStateChanged() {
    if (_formState.isAborted) {
      Navigator.of(context).pop();
    } else if (_formState.isSubmitted) {
      // TODO: onSubmit
      Navigator.of(context).pop();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: Strings.createActionAppBarTitle,
        leading: BackButton(onPressed: () => _formState.viewChangedBackward()),
      ),
      floatingActionButton: _formState.shouldDisplayNavigationButtons
          ? _NavButtons(
              onGoBackPressed: () => _formState.viewChangedBackward(),
              onGoForwardPressed: _formState.canGoForward ? () => _formState.viewChangedForward() : null,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _CreateUserActionForm(_formState),
    );
  }
}

class _NavButtons extends StatelessWidget {
  const _NavButtons({
    required this.onGoBackPressed,
    required this.onGoForwardPressed,
  });
  final void Function()? onGoBackPressed;
  final void Function()? onGoForwardPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: _BackButton(onPressed: onGoBackPressed),
          ),
          const SizedBox(width: Margins.spacing_base),
          Expanded(
            flex: 2,
            child: _NextButton(onPressed: onGoForwardPressed),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      label: Strings.user_action_back_button,
      onPressed: onPressed,
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      label: Strings.user_action_next_button,
      suffix: SizedBox.shrink(
        child: OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: Margins.spacing_base),
            child: Icon(Icons.arrow_forward_rounded),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class _CreateUserActionForm extends StatelessWidget {
  const _CreateUserActionForm(this.formState);
  final CreateUserActionFormState formState;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserActionStepper(view: formState.currentView),
            switch (formState.currentView) {
              CreateUserActionView.step1 => CreateUserActionFormStep1(onActionTypeSelected: (type) {
                  formState.userActionTypeSelected(type);
                }),
              CreateUserActionView.step2 => CreateUserActionFormStep2(
                  state: formState.step2,
                  onTitleChanged: (value) => formState.titleChanged(value),
                  onDescriptionChanged: (value) => formState.descriptionChanged(value),
                ),
              CreateUserActionView.step3 => CreateUserActionFormStep3(formState.step3),
              _ => const SizedBox.shrink(),
            }
          ],
        ),
      ),
    );
  }
}
