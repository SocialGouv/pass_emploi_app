import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_card_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/date_echeance_in_card.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';
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
      rebuildOnChange: false,
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
    return CardContainer(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.tag != null)
            Align(
              alignment: Alignment.centerRight,
              child: _StatusTags(viewModel.tag!),
            ),
          SizedBox(height: Margins.spacing_base),
          _Title(viewModel.title),
          SizedBox(height: Margins.spacing_base),
          if (viewModel.withSubtitle) ...[
            _Subtitle(viewModel.subtitle),
            SizedBox(height: Margins.spacing_base),
          ],
          if (viewModel.dateEcheanceViewModel != null) ...[
            DateEcheanceInCard(
              formattedTexts: viewModel.dateEcheanceViewModel!.formattedTexts,
              color: viewModel.dateEcheanceViewModel!.color,
            ),
            SizedBox(height: Margins.spacing_base),
          ],
          PressedTip(Strings.voirLeDetailCard)
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyles.textMBold);
  }
}

class _StatusTags extends StatelessWidget {
  const _StatusTags(this.tagViewModel);
  final UserActionTagViewModel tagViewModel;

  @override
  Widget build(BuildContext context) {
    return StatutTag(
      backgroundColor: tagViewModel.backgroundColor,
      textColor: tagViewModel.textColor,
      title: tagViewModel.title,
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyles.textSRegular(color: AppColors.contentColor));
  }
}
