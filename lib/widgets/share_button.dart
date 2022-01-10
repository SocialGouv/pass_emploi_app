import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final String textToShare;
  final String? subjectForEmail;
  final VoidCallback? onPressed;

  const ShareButton(this.textToShare, this.subjectForEmail, this.onPressed) : super();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(side: BorderSide(color: AppColors.nightBlue)),
        child: InkWell(
          onTap: () {
            if (onPressed != null) onPressed!();
            Share.share(textToShare, subject: subjectForEmail);
          },
          child: Container(
            width: 48,
            height: 48,
            child: Center(child: SvgPicture.asset(Drawables.icShare, width: 18, color: AppColors.nightBlue)),
          ),
        ),
      ),
    );
  }
}
