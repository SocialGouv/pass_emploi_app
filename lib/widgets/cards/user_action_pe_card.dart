import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_pe/user_action_pe_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/tags/status_tag.dart';

class UserActionPECard extends StatelessWidget {
  final UserActionPEViewModel viewModel;

  const UserActionPECard({required this.viewModel}) : super();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
        Shadows.boxShadow,
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.tag != null) _buildStatut(viewModel.tag!),
                  Text(viewModel.title, style: TextStyles.textBaseBold),
                  if (viewModel.createdByAdvisor) _buildCreatorText(),
                  _buildDate(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatut(UserActionTagViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_base),
      child: StatutTag(
        backgroundColor: viewModel.backgroundColor,
        textColor: viewModel.textColor,
        title: viewModel.title,
      ),
    );
  }

  Widget _buildCreatorText() {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_base),
      child: Text(Strings.createByAdvisor, style: TextStyles.textSRegularWithColor(AppColors.primary)),
    );
  }

  Widget _buildDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Margins.spacing_base),
          child: Container(
            height: 1,
            color: AppColors.primaryLighten,
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(Drawables.icClock, color: viewModel.getDateColor()),
            SizedBox(width: Margins.spacing_s),
            Text(viewModel.formattedDate, style: TextStyles.textSRegularWithColor(viewModel.getDateColor())),
          ],
        ),
      ],
    );
  }
}
