import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_card_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/generic_card.dart';
import 'package:pass_emploi_app/widgets/date_echeance_in_card.dart';
import 'package:pass_emploi_app/widgets/tags/status_tag.dart';

class DemarcheCard extends StatelessWidget {
  final String demarcheId;
  final DemarcheStateSource stateSource;
  final bool simpleCard;
  final Function() onTap;

  const DemarcheCard({
    required this.demarcheId,
    required this.stateSource,
    required this.onTap,
    this.simpleCard = false,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DemarcheCardViewModel>(
      converter: (store) => DemarcheCardViewModel.create(
        store: store,
        stateSource: stateSource,
        demarcheId: demarcheId,
        simpleCard: simpleCard,
      ),
      builder: _build,
    );
  }

  Widget _build(BuildContext context, DemarcheCardViewModel viewModel) {
    return GenericCard(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.tag != null) _Tag(viewModel.tag!),
          Text(viewModel.titre, style: TextStyles.textBaseBold),
          if (viewModel.sousTitre != null) _SousTitre(viewModel.sousTitre!),
          if (viewModel.createdByAdvisor) _CreatorText(),
          if (viewModel.dateFormattedTexts != null)
            DateEcheanceInCard(
              formattedTexts: viewModel.dateFormattedTexts!,
              color: viewModel.dateColor,
            ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final UserActionTagViewModel viewModel;

  const _Tag(this.viewModel);

  @override
  Widget build(BuildContext context) {
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

class _SousTitre extends StatelessWidget {
  final String sousTitre;

  const _SousTitre(this.sousTitre);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_s),
      child: Text(
        sousTitre,
        style: TextStyles.textSRegular(color: AppColors.contentColor),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _CreatorText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_base),
      child: Text(Strings.createByAdvisor, style: TextStyles.textSRegularWithColor(AppColors.primary)),
    );
  }
}
