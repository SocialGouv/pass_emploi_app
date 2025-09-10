import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_actions.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_contact_form_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/loading_overlay.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class ImmersionContactFormBottomSheet extends StatelessWidget {
  static Future<void> show(BuildContext context) {
    return showPassEmploiBottomSheet(
      context: context,
      builder: (context) => ImmersionContactFormBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.immersionForm,
      child: StoreConnector<AppState, ImmersionContactFormViewModel>(
        converter: (store) => ImmersionContactFormViewModel.create(store),
        builder: (context, viewModel) => _Content(viewModel),
        onDidChange: (previousVm, newVm) => _pageNavigationHandling(newVm, context),
        distinct: true,
        onDispose: ((store) => store.dispatch(ContactImmersionResetAction())),
      ),
    );
  }

  void _pageNavigationHandling(ImmersionContactFormViewModel viewModel, BuildContext context) {
    if (viewModel.sendingState.isFailure()) {
      PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.immersionFormSent(false));
      showSnackBarWithSystemError(context);
      viewModel.resetSendingState();
    } else if (viewModel.sendingState.isAlreadyDone()) {
      PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.immersionFormSent(false));
      showSnackBarWithUserError(context, Strings.contactImmersionAlreadyDone);
      viewModel.resetSendingState();
    } else if (viewModel.sendingState.isSuccess()) {
      PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.immersionFormSent(true));
      Navigator.pop(context);
      showSnackBarWithSuccess(context, Strings.immersionContactSucceed);
    }
  }
}

class _Content extends StatefulWidget {
  final ImmersionContactFormViewModel viewModel;
  const _Content(this.viewModel);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late final ImmersionContactFormChangeNotifier state;

  @override
  void initState() {
    state = ImmersionContactFormChangeNotifier(
      userEmailInitialValue: widget.viewModel.userEmailInitialValue,
      userFirstNameInitialValue: widget.viewModel.userFirstNameInitialValue,
      userLastNameInitialValue: widget.viewModel.userLastNameInitialValue,
      messageInitialValue: widget.viewModel.messageInitialValue,
    )..addListener(() => setState(() {}));
    super.initState();
  }

  void _submitForm() {
    final email = state.userEmailController.text;
    final firstName = state.userFirstNameController.text;
    final lastName = state.userLastNameController.text;
    final message = state.messageController.text;
    final userInput = ImmersionContactUserInput(
      email: email,
      firstName: firstName,
      lastName: lastName,
      message: message,
    );
    widget.viewModel.onFormSubmitted(userInput);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      title: Strings.immersitionContactFormTitle,
      padding: EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      body: Scaffold(
        floatingActionButton: SizedBox(
          width: double.infinity,
          child: PrimaryActionButton(
            label: Strings.immersionContactFormButton,
            icon: AppIcons.outgoing_mail,
            onPressed: state.isFormValid && widget.viewModel.sendingState.isLoading() == false ? _submitForm : null,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Margins.spacing_base),
                  Text(
                    Strings.immersitionContactFormSubtitle,
                    style: TextStyles.textBaseRegular,
                  ),
                  SizedBox(height: Margins.spacing_m),
                  Text(
                    Strings.immersitionContactFormHint,
                    style: TextStyles.textBaseBold,
                  ),
                  SizedBox(height: Margins.spacing_m),
                  ImmersionTextFormField(
                    isMandatory: true,
                    mandatoryError: state.isEmailValid()
                        ? null
                        : state.isEmailEmpty()
                            ? Strings.immersionContactFormEmailEmpty
                            : Strings.immersionContactFormEmailInvalid,
                    controller: state.userEmailController,
                    focusNode: state.userEmailFocus,
                    label: Strings.immersitionContactFormEmailHint,
                  ),
                  SizedBox(height: Margins.spacing_m),
                  ImmersionTextFormField(
                    isMandatory: true,
                    mandatoryError: state.isFirstNameValid() ? null : Strings.immersionContactFormFirstNameInvalid,
                    controller: state.userFirstNameController,
                    focusNode: state.userFirstNameFocus,
                    label: Strings.immersitionContactFormSurnameHint,
                  ),
                  SizedBox(height: Margins.spacing_m),
                  ImmersionTextFormField(
                    isMandatory: true,
                    mandatoryError: state.isLastNameValid() ? null : Strings.immersionContactFormLastNameInvalid,
                    controller: state.userLastNameController,
                    focusNode: state.userLastNameFocus,
                    label: Strings.immersitionContactFormNameHint,
                  ),
                  SizedBox(height: Margins.spacing_m),
                  ImmersionTextFormField(
                    isMandatory: true,
                    mandatoryError: state.isMessageValid() ? null : Strings.immersionContactFormMessageInvalid,
                    maxLength: 512,
                    maxLines: 10,
                    controller: state.messageController,
                    focusNode: state.messageFocus,
                    label: Strings.immersitionContactFormMessageHint,
                  ),
                  SizedBox(height: Margins.spacing_huge * 2),
                ],
              ),
            ),
            if (widget.viewModel.sendingState.isLoading()) LoadingOverlay(),
          ],
        ),
      ),
    );
  }
}

class ImmersionTextFormField extends StatelessWidget {
  final String label;
  final bool isMandatory;
  final String? mandatoryError;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final TextEditingController controller;
  final FocusNode focusNode;
  final int? maxLength;

  const ImmersionTextFormField({
    super.key,
    required this.isMandatory,
    this.mandatoryError,
    this.onChanged,
    required this.label,
    this.maxLines = 1,
    required this.controller,
    required this.focusNode,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${isMandatory ? "*" : null}$label", style: TextStyles.textBaseMedium),
        SizedBox(height: Margins.spacing_base),
        BaseTextField(
          focusNode: focusNode,
          minLines: 1,
          maxLength: maxLength,
          maxLines: maxLines,
          controller: controller,
          errorText: focusNode.hasFocus ? null : mandatoryError,
          keyboardType: TextInputType.multiline,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class ImmersionContactFormChangeNotifier extends ChangeNotifier {
  bool isFormValid = false;

  late final TextEditingController userEmailController;
  late final TextEditingController userFirstNameController;
  late final TextEditingController userLastNameController;
  late final TextEditingController messageController;

  late final FocusNode userEmailFocus;
  late final FocusNode userFirstNameFocus;
  late final FocusNode userLastNameFocus;
  late final FocusNode messageFocus;

  ImmersionContactFormChangeNotifier({
    required String userEmailInitialValue,
    required String userFirstNameInitialValue,
    required String userLastNameInitialValue,
    required String messageInitialValue,
  }) {
    userEmailController = TextEditingController(text: userEmailInitialValue)..addListener(onAnyFieldChanged);
    userFirstNameController = TextEditingController(text: userFirstNameInitialValue)..addListener(onAnyFieldChanged);
    userLastNameController = TextEditingController(text: userLastNameInitialValue)..addListener(onAnyFieldChanged);
    messageController = TextEditingController(text: messageInitialValue)..addListener(onAnyFieldChanged);

    userEmailFocus = FocusNode()..addListener(onFocusChanged);
    userFirstNameFocus = FocusNode()..addListener(onFocusChanged);
    userLastNameFocus = FocusNode()..addListener(onFocusChanged);
    messageFocus = FocusNode()..addListener(onFocusChanged);

    isFormValid = _isFormFieldsValid();
  }

  bool _isFormFieldsValid() {
    return isEmailValid() && isFirstNameValid() && isLastNameValid() && isMessageValid();
  }

  bool isEmailValid() {
    // simplified RFC 5322 standard
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    final value = userEmailController.text;
    return emailRegex.hasMatch(value) && !isEmailEmpty();
  }

  bool isEmailEmpty() {
    return userEmailController.text.isEmpty;
  }

  bool isFirstNameValid() {
    return userFirstNameController.text.isNotEmpty;
  }

  bool isLastNameValid() {
    return userLastNameController.text.isNotEmpty;
  }

  bool isMessageValid() {
    return messageController.text.isNotEmpty;
  }

  void onAnyFieldChanged() {
    isFormValid = _isFormFieldsValid();
    notifyListeners();
  }

  void onFocusChanged() {
    notifyListeners();
  }
}
