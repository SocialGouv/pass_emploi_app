import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/user_action/user_action_detail_bottom_sheet.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_card_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';

class UserActionCard extends StatelessWidget {
  final String userActionId;
  final UserActionStateSource source;
  final VoidCallback onTap;

  const UserActionCard({
    super.key,
    required this.userActionId,
    required this.source,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserActionCardViewModel>(
      converter: (store) => UserActionCardViewModel.create(store: store, stateSource: source, actionId: userActionId),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, UserActionCardViewModel viewModel) {
    // A11y : to read "Action" + category + title + status
    return Semantics(
      label: Strings.accueilActionSingular,
      child: Column(
        children: [
          BaseCard(
            onTap: onTap,
            onLongPress: () => UserActionDetailsBottomSheet.show(context, source, viewModel.id),
            title: viewModel.title,
            tag: CardTag(
              icon: viewModel.categoryIcon,
              text: viewModel.categoryText,
              contentColor: viewModel.isLate ? AppColors.warning : AppColors.primary,
              backgroundColor: viewModel.isLate ? AppColors.warningLighten : AppColors.primaryLighten,
            ),
            pillule: viewModel.pillule.toActionCardPillule(excludeSemantics: true),
          ),
          Semantics(label: Strings.a11yStatus + viewModel.pillule.toSemanticLabel()),
        ],
      ),
    );
  }
}
