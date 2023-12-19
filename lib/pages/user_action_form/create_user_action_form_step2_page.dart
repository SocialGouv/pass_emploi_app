import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_chip.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class CreateUserActionFormStep2 extends StatelessWidget {
  CreateUserActionFormStep2({
    required this.state,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  final CreateUserActionStep2ViewModel state;
  final void Function(CreateActionTitleSource) onTitleChanged;
  final void Function(String) onDescriptionChanged;

  final descriptionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: Margins.spacing_m),
        Text(Strings.mandatoryFields, style: TextStyles.textSRegular()),
        const SizedBox(height: Margins.spacing_m),
        Text(Strings.user_action_subtitle_step_2, style: TextStyles.textBaseBold),
        const SizedBox(height: Margins.spacing_m),
        _SugestionTagWrap(titleSource: state.titleSource, onSelected: onTitleChanged),
        if (state.titleSource.isFromUserInput) ...[
          const SizedBox(height: Margins.spacing_m),
          Text(Strings.user_action_title_textfield_step_2, style: TextStyles.textBaseBold),
          const SizedBox(height: Margins.spacing_s),
          BaseTextField(
            initialValue: state.titleSource.title,
            onChanged: (value) => onTitleChanged(CreateActionTitleFromUserInput(value)),
          ),
        ],
        const SizedBox(height: Margins.spacing_m),
        Text(
          Strings.user_action_description_textfield_step_2,
          key: descriptionKey,
          style: TextStyles.textBaseBold,
        ),
        const SizedBox(height: Margins.spacing_s),
        BaseTextField(
          initialValue: state.description,
          maxLines: 5,
          onChanged: (value) {
            onDescriptionChanged(value);
            _scrollToDescription(context);
          },
        ),
      ],
    );
  }

  Future<void> _scrollToDescription(BuildContext context) {
    return Scrollable.ensureVisible(
      descriptionKey.currentContext ?? context,
      duration: AnimationDurations.fast,
    );
  }
}

class _SugestionTagWrap extends StatelessWidget {
  const _SugestionTagWrap({required this.titleSource, required this.onSelected});
  final void Function(CreateActionTitleSource) onSelected;
  final CreateActionTitleSource titleSource;

  static List<String> suggestionList = [
    Strings.user_action_suggestion_titre_1,
    Strings.user_action_suggestion_titre_2,
    Strings.user_action_suggestion_titre_3,
    Strings.user_action_suggestion_titre_4,
    Strings.user_action_suggestion_titre_5,
    Strings.user_action_suggestion_titre_6,
    Strings.user_action_suggestion_titre_7,
    Strings.user_action_suggestion_titre_8,
    Strings.user_action_suggestion_titre_9,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Margins.spacing_s,
      runSpacing: Margins.spacing_s,
      children: switch (titleSource) {
        CreateActionTitleNotInitialized() => [
            ...suggestionList.map(
              (suggestion) => PassEmploiChip<String>(
                label: suggestion,
                value: suggestion,
                isSelected: false,
                onTagSelected: (value) => onSelected(CreateActionTitleFromSuggestions(value)),
                onTagDeleted: () => onSelected(CreateActionTitleNotInitialized()),
              ),
            ),
            PassEmploiChip<String>(
                label: Strings.user_action_other,
                value: "",
                isSelected: false,
                onTagSelected: (value) => onSelected(CreateActionTitleFromUserInput(value)),
                onTagDeleted: () => onSelected(CreateActionTitleNotInitialized()))
          ],
        CreateActionTitleFromSuggestions() => [
            PassEmploiChip<String>(
                label: titleSource.title,
                value: titleSource.title,
                isSelected: true,
                onTagSelected: (value) => onSelected(CreateActionTitleFromUserInput(value)),
                onTagDeleted: () => onSelected(CreateActionTitleNotInitialized()))
          ],
        CreateActionTitleFromUserInput() => [
            PassEmploiChip<String>(
                label: Strings.user_action_other,
                value: "",
                isSelected: true,
                onTagSelected: (value) => onSelected(CreateActionTitleFromUserInput(value)),
                onTagDeleted: () => onSelected(CreateActionTitleNotInitialized()))
          ],
      },
    );
  }
}
