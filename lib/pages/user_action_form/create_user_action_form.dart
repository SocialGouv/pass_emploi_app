import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form_step1_page.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form_step2_page.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form_step3_page.dart';
import 'package:pass_emploi_app/pages/user_action_form/widgets/user_action_stepper.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: SecondaryAppBar(
        title: Strings.createActionAppBarTitle,
        leading: BackButton(onPressed: () => _formState.viewChangedBackward()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buttons(),
      body: _CreateUserActionForm(_formState),
    );
  }

  _NavButtons? _buttons() {
    return _formState.shouldDisplayNavigationButtons
        ? _NavButtons(
            onGoBackPressed: () => _formState.viewChangedBackward(),
            onGoForwardPressed: _formState.canGoForward ? () => _formState.viewChangedForward() : null,
          )
        : null;
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
      label: Strings.userActionBackButton,
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
      label: Strings.userActionNextButton,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        children: [
          UserActionStepper(
            displayState: formState.displayState,
            category: formState.step1.actionCategory?.label ?? "",
          ),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  switch (formState.displayState) {
                    CreateUserActionDisplayState.step1 => CreateUserActionFormStep1(onActionTypeSelected: (type) {
                        formState.userActionTypeSelected(type);
                      }),
                    CreateUserActionDisplayState.step2 => CreateUserActionFormStep2(
                        actionType: formState.step1.actionCategory!,
                        viewModel: formState.step2,
                        onTitleChanged: (value) => formState.titleChanged(value),
                        onDescriptionChanged: (value) => formState.descriptionChanged(value),
                      ),
                    CreateUserActionDisplayState.step3 => CreateUserActionFormStep3(
                        viewModel: formState.step3,
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
          ),
        ],
      ),
    );
  }
}
