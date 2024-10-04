import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_detail_bottom_sheet.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_card_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';

class DemarcheCard extends StatelessWidget {
  final String demarcheId;
  final Function() onTap;

  const DemarcheCard({
    required this.demarcheId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DemarcheCardViewModel>(
      converter: (store) => DemarcheCardViewModel.create(store: store, demarcheId: demarcheId),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, DemarcheCardViewModel viewModel) {
    // A11y : to read "Démarche" + category + title + status
    return Semantics(
      label: Strings.accueilDemarcheSingular,
      child: Column(
        children: [
          BaseCard(
            onTap: onTap,
            onLongPress: () => DemarcheDetailsBottomSheet.show(context, demarcheId),
            title: viewModel.title,
            tag: viewModel.categoryText != null
                ? CardTag(
                    icon: AppIcons.emploi,
                    text: viewModel.categoryText!,
                    contentColor: AppColors.primary,
                    backgroundColor: AppColors.primaryLighten,
                  )
                : null,
            pillule: viewModel.pillule.toDemarcheCardPillule(excludeSemantics: true),
          ),
          Semantics(label: Strings.a11yStatus + viewModel.pillule.toSemanticLabel()),
        ],
      ),
    );
  }
}
