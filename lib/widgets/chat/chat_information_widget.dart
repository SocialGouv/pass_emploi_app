import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class ChatInformationWidget extends StatelessWidget {
  final String title;
  final String description;

  const ChatInformationWidget(this.title, this.description, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Margins.spacing_s),
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            SizedBox(height: Margins.spacing_s),
            _description(),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(Margins.spacing_xs),
          child: SvgPicture.asset(Drawables.icInfo, color: AppColors.primary),
        ),
        SizedBox(width: Margins.spacing_s),
        Flexible(
          child: Text(
            title,
            style: TextStyles.textBaseBoldWithColor(AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _description() {
    return Text(
      description,
      style: TextStyles.textBaseRegularWithColor(AppColors.primary),
    );
  }
}
