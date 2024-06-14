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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SuppressionCompteViewModel>(
      converter: (store) => SuppressionCompteViewModel.create(store),
      builder: (context, viewModel) => _build(context, viewModel),
    );
  }

  Widget _build(BuildContext context, SuppressionCompteViewModel viewModel) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      surfaceTintColor: Colors.white,
      title: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m, vertical: Margins.spacing_m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: Margins.spacing_m),
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
                  setFieldContent: (value) => _fieldContent = value,
                ),
              ],
            ),
          ),
          _DeleteAlertCrossButton(),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: Margins.spacing_m, right: Margins.spacing_m, bottom: Margins.spacing_m),
          child: Wrap(
            spacing: Margins.spacing_base,
            children: [
              SecondaryButton(
                label: Strings.cancelLabel,
                fontSize: FontSizes.medium,
                onPressed: () => Navigator.pop(context),
              ),
              ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _inputController,
                  builder: (context, value, child) {
                    return PrimaryActionButton(
                      label: Strings.suppressionLabel,
                      textColor: AppColors.warning,
                      backgroundColor: AppColors.warningLighten,
                      disabledBackgroundColor: AppColors.warningLighten,
                      rippleColor: AppColors.warningLighten,
                      withShadow: true,
                      onPressed: _shouldActivateButton(viewModel)
                          ? () {
                              viewModel.onDeleteUser();
                              Navigator.pop(context);
                            }
                          : null,
                    );
                  })
            ],
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Margins.spacing_m)),
      actionsPadding: EdgeInsets.only(bottom: Margins.spacing_base),
    );
  }

  bool _shouldActivateButton(SuppressionCompteViewModel viewModel) {
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
        tooltip: Strings.close,
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
  final Function(String) setFieldContent;

  const _DeleteAlertTextField({required this.controller, required this.getFieldContent, required this.setFieldContent});

  @override
  State<_DeleteAlertTextField> createState() => _DeleteAlertTextFieldState();
}

class _DeleteAlertTextFieldState extends State<_DeleteAlertTextField> {
  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      controller: widget.controller,
      errorText: (_isNotValid()) ? Strings.mandatorySuppressionLabelError : null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        setState(() {
          widget.setFieldContent(value);
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
