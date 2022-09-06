import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_card_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/date_echeance_in_card.dart';
import 'package:pass_emploi_app/widgets/tags/status_tag.dart';

class UserActionCard extends StatelessWidget {
  final VoidCallback onTap;
  final UserActionCardViewModel viewModel;
  final bool simpleCard;

  const UserActionCard({
    Key? key,
    required this.onTap,
    required this.viewModel,
    this.simpleCard = false,
  }) : super(key: key);

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
            onTap: onTap,
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.tag != null) _buildStatut(viewModel.tag!),
                  Text(viewModel.title, style: TextStyles.textBaseBold),
                  if (viewModel.withSubtitle && simpleCard == false) _buildSousTitre(),
                  if (viewModel.dateEcheanceViewModel != null && simpleCard == false)
                    DateEcheanceInCard(
                      formattedTexts: viewModel.dateEcheanceViewModel!.formattedTexts,
                      color: viewModel.dateEcheanceViewModel!.color,
                    ),
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
      child: StatutTag(
        backgroundColor: viewModel.backgroundColor,
        textColor: viewModel.textColor,
        title: viewModel.title,
      ),
    );
  }
}
