import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_icon_button.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final String textToShare;
  final String? subjectForEmail;
  final VoidCallback? onPressed;

  const ShareButton(this.textToShare, this.subjectForEmail, this.onPressed) : super();

  @override
  Widget build(BuildContext context) {
    return SecondaryIconButton(
      icon: AppIcons.share_rounded,
      iconSize: Dimens.icon_size_base,
      onTap: () {
        if (onPressed != null) onPressed!();
        Share.share(textToShare, subject: subjectForEmail);
      },
    );
  }
}
