import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_action_form_view_models/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form_step1_page.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form_step2_page.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form_step3_page.dart';
import 'package:pass_emploi_app/pages/user_action_form/widgets/user_action_stepper.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class CreateUserActionForm extends StatefulWidget {
  const CreateUserActionForm({super.key, required this.onSubmit, required this.onAbort});
  final void Function(CreateUserActionFormViewModel state) onSubmit;
  final void Function() onAbort;

  @override
  State<CreateUserActionForm> createState() => _CreateUserActionFormState();
}

class _CreateUserActionFormState extends State<CreateUserActionForm> {
  late final CreateUserActionFormViewModel _formState;

  @override
  void initState() {
    super.initState();
    _formState = CreateUserActionFormViewModel();
    _formState.addListener(_onFormStateChanged);
  }

  void _onFormStateChanged() {
    if (_formState.isAborted) {
      widget.onAbort();
    } else if (_formState.isSubmitted) {
      widget.onSubmit(_formState);
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
      backgroundColor: Colors.white,
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
  final CreateUserActionFormViewModel formState;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserActionStepper(view: formState.currentView, category: formState.step1.actionCategory?.label ?? ""),
            switch (formState.currentView) {
              CreateUserActionDisplayState.step1 => CreateUserActionFormStep1(onActionTypeSelected: (type) {
                  formState.userActionTypeSelected(type);
                }),
              CreateUserActionDisplayState.step2 => CreateUserActionFormStep2(
                  state: formState.step2,
                  onTitleChanged: (value) => formState.titleChanged(value),
                  onDescriptionChanged: (value) => formState.descriptionChanged(value),
                ),
              CreateUserActionDisplayState.step3 => CreateUserActionFormStep3(
                  state: formState.step3,
                  onStatusChanged: (value) => formState.statusChanged(value),
                  onDateChanged: (value) => formState.dateChanged(value),
                  withRappelChanged: (value) => formState.withRappelChanged(value),
                ),
              _ => const SizedBox.shrink(),
            },
            SizedBox(height: Margins.spacing_huge),
          ],
        ),
      ),
    );
  }
}
