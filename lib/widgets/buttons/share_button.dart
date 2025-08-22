import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_icon_button.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final String textToShare;
  final String semanticsLabel;
  final String? subjectForEmail;
  final VoidCallback? onPressed;

  const ShareButton({
    required this.textToShare,
    required this.semanticsLabel,
    required this.subjectForEmail,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SecondaryIconButton(
      icon: AppIcons.ios_share,
      iconSize: Dimens.icon_size_m,
      tooltip: semanticsLabel,
      onTap: () {
        if (onPressed != null) onPressed!();
        SharePlus.instance.share(
          ShareParams(
            text: textToShare,
            subject: subjectForEmail,
          ),
        );
      },
    );
  }
}
