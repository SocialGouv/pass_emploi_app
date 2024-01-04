import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class BaseDeleteDialog extends StatelessWidget {
  const BaseDeleteDialog({
    super.key,
    required this.title,
    required this.subtitle,
    this.onDelete,
    this.withLoading = false,
    this.withError = false,
  });

  final String title;
  final String subtitle;
  final bool withLoading;
  final bool withError;
  final void Function()? onDelete;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => BaseDeleteDialog(
        title: title,
        subtitle: subtitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: Margins.spacing_m),
              SizedBox.square(
                dimension: 120,
                child: Illustration.red(AppIcons.delete),
              ),
              SizedBox(height: Margins.spacing_m),
              Text(title, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
              SizedBox(height: Margins.spacing_m),
              Text(subtitle, style: TextStyles.textBaseRegular, textAlign: TextAlign.center),
              if (withLoading) _Loader(),
              if (withError) _Error(),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close, color: AppColors.primaryDarken),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
      actions: [
        SecondaryButton(
          label: Strings.cancelLabel,
          onPressed: () => Navigator.pop(context, false),
        ),
        SizedBox(width: Margins.spacing_s),
        PrimaryActionButton(
          label: Strings.suppressionLabel,
          onPressed: withLoading ? null : () => _onDelete(context),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Margins.spacing_m)),
      actionsPadding: EdgeInsets.only(bottom: Margins.spacing_base),
    );
  }

  void _onDelete(BuildContext context) => onDelete != null ? onDelete!.call() : Navigator.pop(context, true);
}

class _Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_s),
      child: SizedBox(
        height: Margins.spacing_m,
        width: Margins.spacing_m,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_s),
      child: Text(
        Strings.alerteDeleteError,
        textAlign: TextAlign.center,
        style: TextStyles.textSRegular(color: AppColors.warning),
      ),
    );
  }
}
