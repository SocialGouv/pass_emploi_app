import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_card_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';

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
      rebuildOnChange: false,
      converter: (store) => UserActionCardViewModel.create(
        store: store,
        stateSource: stateSource,
        actionId: userActionId,
      ),
      builder: _body,
    );
  }

  Widget _body(BuildContext context, UserActionCardViewModel viewModel) {
    return BaseCard(
      title: viewModel.title,
      onTap: onTap,
      pillule: viewModel.pillule?.toCardPillule(),
      body: viewModel.subtitle,
      complements: [
        if (viewModel.dateEcheance != null)
          viewModel.isLate
              ? CardComplement.dateLate(text: viewModel.dateEcheance!)
              : CardComplement.date(text: viewModel.dateEcheance!),
      ],
    );
  }
}
