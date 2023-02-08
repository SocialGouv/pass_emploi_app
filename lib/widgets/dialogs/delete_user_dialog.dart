import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/suppression_compte_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';

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
      onDidChange: (_, newVM) {
        if (newVM.displayState == DisplayState.FAILURE) {
          Navigator.pop(context, false);
        } else if (newVM.displayState == DisplayState.CONTENT) {
          Navigator.pop(context, true);
        }
      },
      distinct: true,
    );
  }

  Widget _build(BuildContext context, SuppressionCompteViewModel viewModel) {
    return AlertDialog(
      title: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(child: SvgPicture.asset(Drawables.deleteIllustration)),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  Strings.lastWarningBeforeSuppression,
                  style: TextStyles.textBaseRegular,
                  textAlign: TextAlign.start,
                ),
              ),
              _DeleteAlertTextField(
                controller: _inputController,
                getFieldContent: () => _fieldContent,
                setFieldContent: (value) => _fieldContent = value,
              ),
            ],
          ),
          _DeleteAlertCrossButton(),
        ],
      ),
      actions: [
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
                disabledBackgroundColor: AppColors.warningLight,
                rippleColor: AppColors.warningLight,
                withShadow: false,
                heightPadding: Margins.spacing_s,
                onPressed: _shouldActivateButton(viewModel) ? () => viewModel.onDeleteUser() : null,
              );
            })
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
        icon: Icon(
          AppIcons.close_rounded,
          color: AppColors.contentColor,
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
