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
  late TextEditingController _userEmail;
  late TextEditingController _userFirstName;
  late TextEditingController _userLastName;
  late TextEditingController _message;
  bool _isFormValid = false;

  @override
  void initState() {
    _userEmail = TextEditingController(text: widget.viewModel.userEmailInitialValue)..addListener(_onAnyFieldChanged);
    _userFirstName = TextEditingController(text: widget.viewModel.userFirstNameInitialValue)
      ..addListener(_onAnyFieldChanged);
    _userLastName = TextEditingController(text: widget.viewModel.userLastNameInitialValue)
      ..addListener(_onAnyFieldChanged);
    _message = TextEditingController(text: widget.viewModel.messageInitialValue)..addListener(_onAnyFieldChanged);
    _isFormValid = _isFormFieldsValid();
    super.initState();
  }

  bool _isFormFieldsValid() {
    return _isEmailValid() && _isFirstNameValid() && _isLastNameValid() && _isMessageValid();
  }

  bool _isEmailValid() {
    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final value = _userEmail.text;
    return emailRegex.hasMatch(value) && !_isEmailEmpty();
  }

  bool _isEmailEmpty() {
    return _userEmail.text.isEmpty;
  }

  bool _isFirstNameValid() {
    return _userFirstName.text.isNotEmpty;
  }

  bool _isLastNameValid() {
    return _userLastName.text.isNotEmpty;
  }

  bool _isMessageValid() {
    return _message.text.isNotEmpty;
  }

  void _onAnyFieldChanged() {
    setState(() {
      _isFormValid = _isFormFieldsValid();
    });
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
                          ? "Champ obligatoire"
                          : "Email invalide",
                  controller: _userEmail,
                  label: Strings.immersitionContactFormEmailHint,
                ),
                SizedBox(height: Margins.spacing_m),
                ImmersionTextFormField(
                  isMandatory: true,
                  mandatoryError: _isFirstNameValid() ? null : "Champ obligatoire",
                  controller: _userFirstName,
                  label: Strings.immersitionContactFormSurnameHint,
                ),
                SizedBox(height: Margins.spacing_m),
                ImmersionTextFormField(
                  isMandatory: true,
                  mandatoryError: _isLastNameValid() ? null : "Champ obligatoire",
                  controller: _userLastName,
                  label: Strings.immersitionContactFormNameHint,
                ),
                SizedBox(height: Margins.spacing_m),
                ImmersionTextFormField(
                  isMandatory: true,
                  mandatoryError: _isMessageValid() ? null : "Champ obligatoire",
                  maxLines: 10,
                  controller: _message,
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
  final TextEditingController? controller;

  const ImmersionTextFormField({
    required this.isMandatory,
    this.mandatoryError,
    this.onChanged,
    required this.label,
    this.maxLines = 1,
    this.controller,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${isMandatory ? "*" : null}$label", style: TextStyles.textBaseMedium),
        SizedBox(height: Margins.spacing_base),
        TextFormField(
          minLines: 1,
          maxLines: maxLines,
          controller: controller,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(Dimens.radius_base),
              errorText: mandatoryError,
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
