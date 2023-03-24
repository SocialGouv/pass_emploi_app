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
  bool _isFormValid = false;

  late final TextEditingController _userEmailController;
  late final TextEditingController _userFirstNameController;
  late final TextEditingController _userLastNameController;
  late final TextEditingController _messageController;

  late final FocusNode _userEmailFocus;
  late final FocusNode _userFirstNameFocus;
  late final FocusNode _userLastNameFocus;
  late final FocusNode _messageFocus;

  @override
  void initState() {
    _userEmailController = TextEditingController(text: widget.viewModel.userEmailInitialValue)
      ..addListener(_onAnyFieldChanged);
    _userFirstNameController = TextEditingController(text: widget.viewModel.userFirstNameInitialValue)
      ..addListener(_onAnyFieldChanged);
    _userLastNameController = TextEditingController(text: widget.viewModel.userLastNameInitialValue)
      ..addListener(_onAnyFieldChanged);
    _messageController = TextEditingController(text: widget.viewModel.messageInitialValue)
      ..addListener(_onAnyFieldChanged);
    _userEmailFocus = FocusNode()..addListener(_onFocusChanged);
    _userFirstNameFocus = FocusNode()..addListener(_onFocusChanged);
    _userLastNameFocus = FocusNode()..addListener(_onFocusChanged);
    _messageFocus = FocusNode()..addListener(_onFocusChanged);
    _isFormValid = _isFormFieldsValid();
    super.initState();
  }

  bool _isFormFieldsValid() {
    return _isEmailValid() && _isFirstNameValid() && _isLastNameValid() && _isMessageValid();
  }

  bool _isEmailValid() {
    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final value = _userEmailController.text;
    return emailRegex.hasMatch(value) && !_isEmailEmpty();
  }

  bool _isEmailEmpty() {
    return _userEmailController.text.isEmpty;
  }

  bool _isFirstNameValid() {
    return _userFirstNameController.text.isNotEmpty;
  }

  bool _isLastNameValid() {
    return _userLastNameController.text.isNotEmpty;
  }

  bool _isMessageValid() {
    return _messageController.text.isNotEmpty;
  }

  void _onAnyFieldChanged() {
    setState(() {
      _isFormValid = _isFormFieldsValid();
    });
  }

  void _onFocusChanged() {
    setState(() {});
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
              onPressed: _isFormValid ? () {} : null,
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
                  mandatoryError: _isEmailValid()
                      ? null
                      : _isEmailEmpty()
                          ? "Renseignez votre adresse email"
                          : "Veuillez renseigner une adresse email valide au format exemple@email.com",
                  controller: _userEmailController,
                  focusNode: _userEmailFocus,
                  label: Strings.immersitionContactFormEmailHint,
                ),
                SizedBox(height: Margins.spacing_m),
                ImmersionTextFormField(
                  isMandatory: true,
                  mandatoryError: _isFirstNameValid() ? null : "Renseignez votre prénom",
                  controller: _userFirstNameController,
                  focusNode: _userFirstNameFocus,
                  label: Strings.immersitionContactFormSurnameHint,
                ),
                SizedBox(height: Margins.spacing_m),
                ImmersionTextFormField(
                  isMandatory: true,
                  mandatoryError: _isLastNameValid() ? null : "Renseignez votre nom",
                  controller: _userLastNameController,
                  focusNode: _userLastNameFocus,
                  label: Strings.immersitionContactFormNameHint,
                ),
                SizedBox(height: Margins.spacing_m),
                ImmersionTextFormField(
                  isMandatory: true,
                  mandatoryError: _isMessageValid() ? null : "Champ obligatoire",
                  maxLines: 10,
                  controller: _messageController,
                  focusNode: _messageFocus,
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

  const ImmersionTextFormField({
    Key? key,
    required this.isMandatory,
    this.mandatoryError,
    this.onChanged,
    required this.label,
    this.maxLines = 1,
    required this.controller,
    required this.focusNode,
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
