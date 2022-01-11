import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/widgets/secondary_icon_button.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final String textToShare;
  final String? subjectForEmail;

  const ShareButton(this.textToShare, this.subjectForEmail) : super();

  @override
  Widget build(BuildContext context) {
    return SecondaryIconButton(
      drawableRes: Drawables.icShare,
      onTap: () => Share.share(textToShare, subject: subjectForEmail),
    );
  }
}
