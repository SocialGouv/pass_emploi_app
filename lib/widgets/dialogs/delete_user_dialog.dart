import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/presentation/profil/parameters_profil_page_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';

String? _fieldContent;

class DeleteAlertDialog extends StatelessWidget {
  final TextEditingController _inputController = TextEditingController();
  final ParametersProfilePageViewModel viewModel;

  DeleteAlertDialog({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _DeleteAlertCrossButton(),
          Center(child: SvgPicture.asset(Drawables.icDelete)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(Strings.lastWarningBeforeSuppression,
                style: TextStyles.textBaseRegular, textAlign: TextAlign.start),
          ),
          _DeleteAlertTextField(controller: _inputController),
        ],
      ),
      actions: [
        SecondaryButton(
          label: Strings.cancelLabel,
          fontSize: FontSizes.medium,
          onPressed: () => {
            _fieldContent = null,
            Navigator.pop(context),
          },
        ),
        ValueListenableBuilder<TextEditingValue>(
            valueListenable: _inputController,
            builder: (context, value, child) {
              return PrimaryActionButton(
                label: Strings.suppressionLabel,
                textColor: AppColors.warning,
                backgroundColor: AppColors.warningLighten,
                disabledBackgroundColor: AppColors.warningLight,
                rippleColor: AppColors.warningLight,
                withShadow: false,
                heightPadding: Margins.spacing_s,
                onPressed: (_isStringValid())
                    ? () {
                  _fieldContent = null;
                  viewModel.onDeleteUser();
                  Navigator.pop(context);
                }
                    : null,
              );
            })
      ],
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Margins.spacing_m)),
      actionsPadding: EdgeInsets.only(bottom: Margins.spacing_xl),
    );
  }

  bool _isFormValid() => _fieldContent != null && _fieldContent!.isNotEmpty;

  bool _isStringValid() {
    if (!_isFormValid()) return false;
    final stringToCheck = _fieldContent!.toLowerCase().trim();
    return stringToCheck == Strings.suppressionLabel.toLowerCase();
  }
}

class _DeleteAlertCrossButton extends StatelessWidget {
  const _DeleteAlertCrossButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.topRight,
      onPressed: () => {
        _fieldContent = null,
        Navigator.pop(context),
      },
      iconSize: 20,
      tooltip: Strings.close,
      icon: SvgPicture.asset(
        Drawables.icClose,
        color: AppColors.contentColor,
      ),
    );
  }
}

class _DeleteAlertTextField extends StatefulWidget {
  final TextEditingController controller;

  const _DeleteAlertTextField({required this.controller});

  @override
  State<_DeleteAlertTextField> createState() => _DeleteAlertTextFieldState();
}

class _DeleteAlertTextFieldState extends State<_DeleteAlertTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          errorText: (_isNotValid()) ? Strings.mandatorySuppressionLabelError : null,
          errorMaxLines: 3,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
          )),
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.none,
      textInputAction: TextInputAction.done,
      style: TextStyles.textSBold,
      onChanged: (value) {
        setState(() {
          _fieldContent = value;
        });
      },
    );
  }

  bool _isNotValid() {
    if (_fieldContent != null) {
      if (_fieldContent!.isEmpty) return true;
      final stringToCheck = _fieldContent!.toLowerCase().trim();
      return stringToCheck != Strings.suppressionLabel.toLowerCase();
    }
    return false;
  }
}
