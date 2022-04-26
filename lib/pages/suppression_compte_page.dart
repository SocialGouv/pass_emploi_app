import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/profil/parameters_profil_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class SuppressionComptePage extends TraceableStatelessWidget {
  SuppressionComptePage._() : super(name: AnalyticsScreenNames.suppressionAccount);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ParametersProfilePageViewModel>(
      converter: (store) => ParametersProfilePageViewModel.create(store),
      builder: (context, viewModel) => _scaffold(context, viewModel),
    );
  }

  Widget _scaffold(BuildContext context, ParametersProfilePageViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.suppressionPageTitle, withBackButton: true),
      body: _body(viewModel),
    );
  }

  static MaterialPageRoute<void> materialPageRoute(String id) {
    return MaterialPageRoute(builder: (context) {
      return SuppressionComptePage._();
    });
  }

  Widget _body(ParametersProfilePageViewModel viewModel) {
    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Margins.spacing_m, Margins.spacing_m, Margins.spacing_m, 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text(Strings.warning, style: TextStyles.textMBold)),
              Spacer(),
              Text(Strings.warningInformationParagraph1, style: TextStyles.textSRegular()),
              Spacer(),
              if (!viewModel.error) ListedItems(list: viewModel.warningSuppressionFeatures!),
              Text(Strings.warningInformationParagraph2, style: TextStyles.textSRegular()),
              Spacer(),
              if (viewModel.isPoleEmploiLogin == null && viewModel.isPoleEmploiLogin!)
                Text(Strings.warningInformationPoleEmploi, style: TextStyles.textSRegular()),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: DeleteAccountButton()),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ]);
  }
}

class Spacer extends StatelessWidget {
  final double height;

  const Spacer({this.height = Margins.spacing_base});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class ListedItems extends StatelessWidget {
  final List<String> list;

  const ListedItems({required this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in list)
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_base),
            child: Text("· $item", style: TextStyles.textSRegular()),
          ),
      ],
    );
  }
}

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton();

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      onPressed: () => _showDeleteDialog(context),
      label: Strings.suppressionButtonLabel,
      textColor: AppColors.warning,
      fontSize: FontSizes.normal,
      backgroundColor: AppColors.warningLighten,
      disabledBackgroundColor: AppColors.warningLight,
      rippleColor: AppColors.warningLight,
      withShadow: false,
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DeleteAlertDialog(),
    ).then((result) {
      showSuccessfulSnackBar(context, Strings.savedSearchDeleteSuccess);
    });
  }
}

String? _fieldContent;

class DeleteAlertDialog extends StatelessWidget {
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          DeleteAlertCrossButton(),
          Center(child: SvgPicture.asset(Drawables.icDelete)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(Strings.lastWarningBeforeSuppression,
                style: TextStyles.textBaseRegular, textAlign: TextAlign.start),
          ),
          DeleteAlertTextField(controller: _inputController),
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

class DeleteAlertCrossButton extends StatelessWidget {
  const DeleteAlertCrossButton();

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

class DeleteAlertTextField extends StatefulWidget {
  final TextEditingController controller;

  const DeleteAlertTextField({required this.controller});

  @override
  State<DeleteAlertTextField> createState() => _DeleteAlertTextFieldState();
}

class _DeleteAlertTextFieldState extends State<DeleteAlertTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          errorText: (_isNotValid()) ? Strings.mandatorySuppressionLabelError : null,
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
