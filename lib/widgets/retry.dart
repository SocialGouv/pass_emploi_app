import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/media_sizes.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class Retry extends StatelessWidget {
  final String text;
  final VoidCallback onRetry;
  final String? buttonLabel;

  const Retry(this.text, this.onRetry, {this.buttonLabel});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Margins.spacing_base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: height < MediaSizes.height_xs ? 60 : 180,
              child: Illustration.grey(
                AppIcons.warning_rounded,
                withWhiteBackground: true,
              ),
            ),
            SizedBox(height: height < MediaSizes.height_xs ? Margins.spacing_base : Margins.spacing_l),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(Strings.error, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
                SizedBox(height: Margins.spacing_base),
                Text(text, style: TextStyles.textBaseRegular, textAlign: TextAlign.center),
                SizedBox(height: Margins.spacing_l),
                PrimaryActionButton(
                  label: buttonLabel ?? Strings.retry,
                  onPressed: onRetry,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
