import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class TitleSection extends StatelessWidget {
  final String label;

  const TitleSection({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(Drawables.icOnePoint, color: AppColors.primary),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(label, style: TextStyles.textMBold),
        )
      ],
    );
  }
}
