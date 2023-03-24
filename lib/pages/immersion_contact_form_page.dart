import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/immersion_contact_form_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class ImmersionContactFormPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) => ImmersionContactFormPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ImmersionContactFormViewModel>(
      converter: (store) => ImmersionContactFormViewModel.create(store),
      builder: (context, viewModel) => _Content(viewModel),
      distinct: true,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SecondaryAppBar(title: Strings.immersitionContactFormTitle),
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: SizedBox(
            width: double.infinity,
            child: PrimaryActionButton(
              label: Strings.immersionContactFormButton,
              icon: AppIcons.outgoing_mail,
              onPressed: state.isFormValid ? () {} : null,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Margins.spacing_base),
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
        ));
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
    Key? key,
    required this.isMandatory,
    this.mandatoryError,
    this.onChanged,
    required this.label,
    this.maxLines = 1,
    required this.controller,
    required this.focusNode,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${isMandatory ? "*" : null}$label", style: TextStyles.textBaseMedium),
        SizedBox(height: Margins.spacing_base),
        TextFormField(
          focusNode: focusNode,
          minLines: 1,
          maxLength: maxLength,
          maxLines: maxLines,
          controller: controller,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(Dimens.radius_base),
              errorText: focusNode.hasFocus ? null : mandatoryError,
              errorMaxLines: 3,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radius_base),
                borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
              )),
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyles.textBaseMedium,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class ImmersionContactFormChangeNotifier extends ChangeNotifier {
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

  bool isFormValid = false;

  late final TextEditingController userEmailController;
  late final TextEditingController userFirstNameController;
  late final TextEditingController userLastNameController;
  late final TextEditingController messageController;

  late final FocusNode userEmailFocus;
  late final FocusNode userFirstNameFocus;
  late final FocusNode userLastNameFocus;
  late final FocusNode messageFocus;

  bool _isFormFieldsValid() {
    return isEmailValid() && isFirstNameValid() && isLastNameValid() && isMessageValid();
  }

  bool isEmailValid() {
    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
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
