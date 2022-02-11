import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/tags/status_tag.dart';

import '../../presentation/user_action_view_model.dart';

class UserActionCard extends StatelessWidget {
  final VoidCallback onTap;
  final UserActionViewModel viewModel;

  const UserActionCard({Key? key, required this.onTap, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
        Shadows.boxShadow,
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: this.onTap,
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.tag != null) _buildStatut(viewModel.tag!),
                  Text(viewModel.title, style: TextStyles.textBaseBold),
                  if (viewModel.withSubtitle) _buildSousTitre(),
                  _buildDerniereModification(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSousTitre() {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_s),
      child: Text(viewModel.subtitle, style: TextStyles.textSRegular(color: AppColors.contentColor)),
    );
  }

  Widget _buildStatut(UserActionTagViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_base),
      child: StatutTag(viewModel: viewModel),
    );
  }

  Widget _buildDerniereModification() {
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
        Text(viewModel.lastUpdate, style: TextStyles.textSRegular(color: AppColors.contentColor)),
      ],
    );
  }
}
