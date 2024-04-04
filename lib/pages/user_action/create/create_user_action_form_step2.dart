import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/mandatory_fields_label.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_chip.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class CreateUserActionFormStep2 extends StatelessWidget {
  final UserActionReferentielType actionType;
  final CreateUserActionStep2ViewModel viewModel;
  final void Function(CreateActionTitleSource) onTitleChanged;
  final void Function(String) onDescriptionChanged;

  CreateUserActionFormStep2({
    required this.actionType,
    required this.viewModel,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  final descriptionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.createUserActionStep2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Margins.spacing_m),
            MandatoryFieldsLabel.some(),
            const SizedBox(height: Margins.spacing_m),
            Text(Strings.userActionSubtitleStep2, style: TextStyles.textBaseBold),
            const SizedBox(height: Margins.spacing_m),
            _SuggestionTagWrap(
              titleSource: viewModel.titleSource,
              onSelected: onTitleChanged,
              actionType: actionType,
            ),
            if (viewModel.titleSource.isFromUserInput) ...[
              const SizedBox(height: Margins.spacing_m),
              Text(Strings.userActionTitleTextfieldStep2, style: TextStyles.textBaseBold),
              const SizedBox(height: Margins.spacing_s),
              BaseTextField(
                initialValue: viewModel.titleSource.title,
                onChanged: (value) => onTitleChanged(CreateActionTitleFromUserInput(value)),
              ),
            ],
            const SizedBox(height: Margins.spacing_m),
            Text(
              Strings.userActionDescriptionTextfieldStep2,
              key: descriptionKey,
              style: TextStyles.textBaseBold,
            ),
            const SizedBox(height: Margins.spacing_s),
            BaseTextField(
              initialValue: viewModel.description,
              maxLines: 5,
              onChanged: (value) {
                onDescriptionChanged(value);
                _scrollToDescription(context);
              },
            ),
            const SizedBox(height: 500), // To ensure scrolling is available, and hence closing of keyboard
          ],
        ),
      ),
    );
  }

  Future<void> _scrollToDescription(BuildContext context) {
    return Scrollable.ensureVisible(
      descriptionKey.currentContext ?? context,
      duration: AnimationDurations.fast,
    );
  }
}

class _SuggestionTagWrap extends StatelessWidget {
  final void Function(CreateActionTitleSource) onSelected;
  final CreateActionTitleSource titleSource;
  final UserActionReferentielType actionType;

  const _SuggestionTagWrap({
    required this.titleSource,
    required this.onSelected,
    required this.actionType,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> suggestionList = actionType.suggestionList;
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
                label: Strings.userActionOther,
                value: '',
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
                label: Strings.userActionOther,
                value: '',
                isSelected: true,
                onTagSelected: (value) => onSelected(CreateActionTitleFromUserInput(value)),
                onTagDeleted: () => onSelected(CreateActionTitleNotInitialized()))
          ],
      },
    );
  }
}
