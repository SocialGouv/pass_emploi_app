import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_2_from_referentiel_step_3_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step3_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker_suggestions.dart';

class CreateDemarche2FromThematiqueStep3Page extends StatelessWidget {
  const CreateDemarche2FromThematiqueStep3Page(this.formVm);
  final CreateDemarcheFormViewModel formVm;

  @override
  Widget build(BuildContext context) {
    final selectedThematique = formVm.step1ViewModel.selectedThematique;

    final selectedDemarche = formVm.thematiqueStep2ViewModel.selectedDemarcheVm;

    if (selectedThematique == null || selectedDemarche == null) {
      return const SizedBox();
    }

    return StoreConnector<AppState, CreateDemarche2FromReferentielStep3ViewModel>(
      onInit: (store) => store.dispatch(ThematiqueDemarcheRequestAction()),
      converter: (store) => CreateDemarche2FromReferentielStep3ViewModel.create(
        store,
        selectedDemarche.idDemarche,
        selectedThematique.id,
      ),
      builder: (context, storeVm) => Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: Margins.spacing_base),
                Text(selectedThematique.title, style: TextStyles.textMBold),
                const SizedBox(height: Margins.spacing_s),
                Text(selectedDemarche.quoi, style: TextStyles.textBaseBold),
                const SizedBox(height: Margins.spacing_s),
                Text(Strings.allMandatoryFields, style: TextStyles.textBaseRegular),
                const SizedBox(height: Margins.spacing_m),
                DatePickerSuggestions(
                  title: Strings.thematiquesDemarcheDateShort,
                  dateSource: formVm.fromThematiqueStep3ViewModel.dateSource,
                  onDateChanged: (date) {
                    formVm.dateDemarcheThematiqueChanged(date);
                    if (!date.isNone) {
                      Future.delayed(Duration(milliseconds: 50), () {
                        if (context.mounted) FocusScope.of(context).nextFocus();
                      });
                    }
                  },
                ),
                if (storeVm.isCommentMandatory) ...[
                  const SizedBox(height: Margins.spacing_m),
                  Text(Strings.selectMoyen, style: TextStyles.textBaseBold),
                  const SizedBox(height: Margins.spacing_base),
                  _MoyensList(
                    storeVm: storeVm,
                    onCommentSelected: (comment) => formVm.commentChanged(comment),
                    selectedComment: formVm.fromThematiqueStep3ViewModel.commentItem,
                  ),
                ],
                SizedBox(height: Margins.spacing_xl * 2),
              ],
            ),
          ),
          if (formVm.fromThematiqueStep3ViewModel.isValid(storeVm.isCommentMandatory))
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              left: Margins.spacing_base,
              right: Margins.spacing_base,
              child: PrimaryActionButton(
                label: Strings.validateLaDemarche,
                onPressed: () => formVm.submitDemarcheThematique(),
              ),
            )
        ],
      ),
    );
  }
}

class _MoyensList extends StatelessWidget {
  const _MoyensList({required this.storeVm, required this.onCommentSelected, this.selectedComment});
  final CreateDemarche2FromReferentielStep3ViewModel storeVm;
  final CommentItem? selectedComment;
  final void Function(CommentItem) onCommentSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: storeVm.comments.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_s),
      itemBuilder: (context, index) {
        final moyen = storeVm.comments[index];
        return Semantics(
          selected: moyen == selectedComment,
          child: CardContainer(
            onTap: () => onCommentSelected(moyen),
            backgroundColor: moyen == selectedComment ? AppColors.primaryDarken : Colors.white,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40),
              child: Center(
                child: Text(
                  moyen.label,
                  textAlign: TextAlign.center,
                  style: TextStyles.textSMedium().copyWith(
                    color: moyen == selectedComment ? Colors.white : AppColors.contentColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
