import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/suppression_compte_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/accessibility_utils.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class DeleteAlertDialog extends StatefulWidget {
  @override
  State<DeleteAlertDialog> createState() => _DeleteAlertDialogState();
}

class _DeleteAlertDialogState extends State<DeleteAlertDialog> {
  final TextEditingController _inputController = TextEditingController();
  String? _fieldContent;
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SuppressionCompteViewModel>(
      converter: (store) => SuppressionCompteViewModel.create(store),
      builder: (context, viewModel) => _build(context, viewModel),
    );
  }

  Widget _build(BuildContext context, SuppressionCompteViewModel viewModel) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _DeleteAlertCrossButton(),
              Center(
                child: SizedBox.square(
                  dimension: 100,
                  child: Illustration.red(AppIcons.delete),
                ),
              ),
              SizedBox(height: Margins.spacing_m),
              Text(
                Strings.lastWarningBeforeSuppression,
                style: TextStyles.textBaseBold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Margins.spacing_m),
              _DeleteAlertTextField(
                controller: _inputController,
                getFieldContent: () => _fieldContent,
                onChanged: (value) {
                  setState(() {
                    _fieldContent = value;
                    _showError = false;
                  });
                },
                showError: _showError,
              ),
              SizedBox(height: Margins.spacing_m),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: Strings.cancelLabel,
                      fontSize: FontSizes.medium,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: Margins.spacing_base),
                  Expanded(
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _inputController,
                      builder: (context, value, child) => PrimaryActionButton(
                        label: Strings.suppressionLabel,
                        textColor: AppColors.warning,
                        backgroundColor: AppColors.warningLighten,
                        disabledBackgroundColor: AppColors.warningLighten,
                        rippleColor: AppColors.warningLighten,
                        withShadow: true,
                        onPressed: _canDeleteAccount(viewModel)
                            ? () {
                                viewModel.onDeleteUser();
                                Navigator.pop(context);
                              }
                            : () {
                                setState(() {
                                  _showError = true;
                                  A11yUtils.announce(Strings.mandatorySuppressionLabelError);
                                });
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canDeleteAccount(SuppressionCompteViewModel viewModel) {
    return _isStringValid() && viewModel.displayState != DisplayState.LOADING;
  }

  bool _isStringValid() {
    if (!_isFormValid()) return false;
    final stringToCheck = _fieldContent!.toLowerCase().trim();
    return stringToCheck == Strings.suppressionLabel.toLowerCase();
  }

  bool _isFormValid() => _fieldContent != null && _fieldContent!.isNotEmpty;
}

class _DeleteAlertCrossButton extends StatelessWidget {
  const _DeleteAlertCrossButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        tooltip: Strings.closeDialog,
        icon: Padding(
          padding: const EdgeInsets.all(Margins.spacing_s),
          child: Icon(
            AppIcons.close_rounded,
            color: AppColors.contentColor,
          ),
        ),
      ),
    );
  }
}

class _DeleteAlertTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function() getFieldContent;
  final Function(String) onChanged;
  final bool showError;

  const _DeleteAlertTextField({
    required this.controller,
    required this.getFieldContent,
    required this.onChanged,
    required this.showError,
  });

  @override
  State<_DeleteAlertTextField> createState() => _DeleteAlertTextFieldState();
}

class _DeleteAlertTextFieldState extends State<_DeleteAlertTextField> {
  @override
  Widget build(BuildContext context) {
    final displayErorr = _isNotValid() && widget.showError;
    return BaseTextField(
      controller: widget.controller,
      errorText: (displayErorr) ? Strings.mandatorySuppressionLabelError : null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        setState(() {
          widget.onChanged(value);
        });
      },
    );
  }

  bool _isNotValid() {
    final fieldContent = widget.getFieldContent();
    if (fieldContent != null) {
      if (fieldContent.isEmpty) return true;
      final stringToCheck = fieldContent.toLowerCase().trim();
      return stringToCheck != Strings.suppressionLabel.toLowerCase();
    }
    return false;
  }
}
