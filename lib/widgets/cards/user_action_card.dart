import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_card_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/generic_card.dart';
import 'package:pass_emploi_app/widgets/date_echeance_in_card.dart';
import 'package:pass_emploi_app/widgets/tags/status_tag.dart';

class UserActionCard extends StatelessWidget {
  final String userActionId;
  final UserActionStateSource stateSource;
  final bool simpleCard;
  final VoidCallback onTap;

  const UserActionCard({
    Key? key,
    required this.userActionId,
    required this.stateSource,
    required this.onTap,
    this.simpleCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionCardViewModel>(
      converter: (store) => UserActionCardViewModel.create(
        store: store,
        stateSource: stateSource,
        actionId: userActionId,
        simpleCard: simpleCard,
      ),
      builder: _body,
    );
  }

  Widget _body(BuildContext context, UserActionCardViewModel viewModel) {
    return GenericCard(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.tag != null) _buildStatut(viewModel.tag!),
          Text(viewModel.title, style: TextStyles.textBaseBold),
          if (viewModel.withSubtitle) _buildSousTitre(viewModel),
          if (viewModel.dateEcheanceViewModel != null)
            DateEcheanceInCard(
              formattedTexts: viewModel.dateEcheanceViewModel!.formattedTexts,
              color: viewModel.dateEcheanceViewModel!.color,
            ),
        ],
      ),
    );
  }

  Widget _buildSousTitre(UserActionCardViewModel viewModel) {
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
