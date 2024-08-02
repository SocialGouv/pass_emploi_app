import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_step1.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_step2.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_step3.dart';
import 'package:pass_emploi_app/pages/user_action/create/widgets/user_action_stepper.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_stepper.dart';

class CreateUserActionForm extends StatefulWidget {
  const CreateUserActionForm({super.key, required this.onSubmit, required this.onAbort});

  final void Function(CreateUserActionFormViewModel viewModel) onSubmit;
  final void Function() onAbort;

  @override
  State<CreateUserActionForm> createState() => _CreateUserActionFormState();
}

class _CreateUserActionFormState extends State<CreateUserActionForm> {
  late final CreateUserActionFormViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CreateUserActionFormViewModel();
    _viewModel.addListener(_onFormStateChanged);
  }

  void _onFormStateChanged() {
    if (_viewModel.isAborted) {
      widget.onAbort();
    } else if (_viewModel.isSubmitted) {
      widget.onSubmit(_viewModel);
    } else if (_viewModel.isDescriptionConfirmation) {
      showDialog(context: context, builder: (_) => _PopUpConfirmationDescription(viewModel: _viewModel));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: SecondaryAppBar(
        title: Strings.createActionAppBarTitle,
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: _viewModel.shouldDisplayNavigationButtons,
        child: _NavButtons(
          displayState: _viewModel.displayState,
          onGoBackPressed: () => _viewModel.viewChangedBackward(),
          onGoForwardPressed: _viewModel.canGoForward ? () => _viewModel.viewChangedForward() : null,
        ),
      ),
      body: _CreateUserActionForm(_viewModel),
    );
  }
}

class _NavButtons extends StatelessWidget {
  const _NavButtons({
    required this.displayState,
    required this.onGoBackPressed,
    required this.onGoForwardPressed,
  });

  final CreateUserActionDisplayState displayState;
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
            child: _NextButton(
              label: displayState.nextLabel,
              onPressed: onGoForwardPressed,
            ),
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
  const _NextButton({required this.onPressed, required this.label});

  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      label: label,
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
    return Column(
      children: [
        const SizedBox(height: Margins.spacing_base),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: PassEmploiStepperProgressBar(
            stepCount: CreateUserActionDisplayState.stepCount,
            currentStep: formState.displayState.stepIndex,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Margins.spacing_s),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
                  child: UserActionStepperTexts(
                    displayState: formState.displayState,
                    category: formState.step1.actionCategory?.label ?? "",
                  ),
                ),
                switch (formState.displayState) {
                  CreateUserActionDisplayState.step1 => CreateUserActionFormStep1(
                      onActionTypeSelected: (type) => formState.userActionTypeSelected(type),
                    ),
                  CreateUserActionDisplayState.step2 => CreateUserActionFormStep2(
                      actionType: formState.step1.actionCategory!,
                      viewModel: formState.step2,
                      onTitleChanged: (titleSource) => formState.titleChanged(titleSource),
                      onDescriptionChanged: (description) => formState.descriptionChanged(description),
                    ),
                  CreateUserActionDisplayState.step3 ||
                  CreateUserActionDisplayState.descriptionConfimation =>
                    CreateUserActionFormStep3(
                      viewModel: formState.step3,
                      onStatusChanged: (estTerminee) => formState.statusChanged(estTerminee),
                      onDateChanged: (dateSource) => formState.dateChanged(dateSource),
                      withRappelChanged: (withRappel) => formState.withRappelChanged(withRappel),
                    ),
                  _ => const SizedBox.shrink(),
                },
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PopUpConfirmationDescription extends StatelessWidget {
  final CreateUserActionFormViewModel viewModel;

  const _PopUpConfirmationDescription({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(Margins.spacing_m),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.close_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox.square(
            dimension: 100,
            child: Illustration.grey(AppIcons.checklist_rounded),
          ),
          SizedBox(height: Margins.spacing_m),
          Text(Strings.userActionDescriptionConfirmationTitle,
              style: TextStyles.textBaseBold, textAlign: TextAlign.center),
          SizedBox(height: Margins.spacing_m),
          Text(Strings.userActionDescriptionConfirmationSubtitle,
              style: TextStyles.textBaseRegular, textAlign: TextAlign.center),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: PrimaryActionButton(
            label: Strings.userActionDescriptionConfirmationConfirmButton,
            onPressed: () {
              _trackActionDescriptionConfirmation(AnalyticsEventNames.createActionWithoutDescriptionAddDescription);
              Navigator.pop(context);
              viewModel.goBackToStep2();
            },
          ),
        ),
        const SizedBox(height: Margins.spacing_s),
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(
            label: Strings.userActionDescriptionConfirmationGoToDescriptionButton,
            onPressed: () {
              _trackActionDescriptionConfirmation(AnalyticsEventNames.createActionWithoutDescription);
              Navigator.pop(context);
              viewModel.confirmDescription();
            },
          ),
        ),
      ],
    );
  }

  void _trackActionDescriptionConfirmation(String action) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.actionWithoutDescriptionCategory,
      action: action,
    );
  }
}
