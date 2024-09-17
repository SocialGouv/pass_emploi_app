import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/mandatory_fields_label.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_chip.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class CreateUserActionFormStep2 extends StatefulWidget {
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

  @override
  State<CreateUserActionFormStep2> createState() => _CreateUserActionFormStep2State();
}

class _CreateUserActionFormStep2State extends State<CreateUserActionFormStep2> {
  final descriptionKey = GlobalKey();

  final descriptionFocusNode = FocusNode();
  late final TextEditingController descriptionController;

  @override
  void initState() {
    descriptionController = TextEditingController(text: widget.viewModel.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Tracker(
        tracking: AnalyticsScreenNames.createUserActionStep2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Margins.spacing_s),
              Text(Strings.userActionTitleStep2, style: TextStyles.textMBold.copyWith(color: AppColors.contentColor)),
              const SizedBox(height: Margins.spacing_m),
              Semantics(excludeSemantics: true, child: MandatoryFieldsLabel.some()),
              const SizedBox(height: Margins.spacing_m),
              Semantics(
                label: Strings.mandatoryField,
                child: Text(
                  Strings.userActionSubtitleStep2,
                  style: TextStyles.textBaseBold,
                ),
              ),
              const SizedBox(height: Margins.spacing_m),
              _SuggestionTagWrap(
                titleSource: widget.viewModel.titleSource,
                onSelected: (value) {
                  widget.onTitleChanged(value);
                  // ensure the description field is visible
                  if (!value.isFromUserInput) {
                    Future.delayed(AnimationDurations.fast, () {
                      descriptionFocusNode.requestFocus();
                      _scrollToDescription(context);
                    });
                  }
                },
                actionType: widget.actionType,
              ),
              if (widget.viewModel.titleSource.isFromUserInput) ...[
                const SizedBox(height: Margins.spacing_m),
                Semantics(
                  label: Strings.mandatoryField,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Strings.userActionTitleTextfieldStep2, style: TextStyles.textBaseBold),
                      const SizedBox(height: Margins.spacing_s),
                      BaseTextField(
                        initialValue: widget.viewModel.titleSource.title,
                        onChanged: (value) => widget.onTitleChanged(CreateActionTitleFromUserInput(value)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: Margins.spacing_m),
              AnimatedSwitcher(
                duration: AnimationDurations.fast,
                child: widget.viewModel.titleSource.isNone
                    ? SizedBox.shrink()
                    : Semantics(
                        container: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.userActionDescriptionTextfieldStep2,
                              key: descriptionKey,
                              style: TextStyles.textBaseBold,
                            ),
                            const SizedBox(height: Margins.spacing_s),
                            Text(
                              Strings.userActionDescriptionDescriptionfieldStep2,
                              style: TextStyles.textSRegular(),
                            ),
                            const SizedBox(height: Margins.spacing_base),
                            Stack(
                              children: [
                                BaseTextField(
                                  focusNode: descriptionFocusNode,
                                  controller: descriptionController,
                                  hintText: Strings.exampleHint + widget.viewModel.titleSource.descriptionHint,
                                  maxLines: 5,
                                  onChanged: (value) {
                                    widget.onDescriptionChanged(value);
                                    _scrollToDescription(context);
                                  },
                                ),
                                if (descriptionController.text.isNotEmpty)
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      tooltip: Strings.clear,
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        widget.onDescriptionChanged("");
                                        descriptionController.clear();
                                      },
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
              // To ensure scrolling is available, and hence closing of keyboard
              SizedBox(height: 600),
            ],
          ),
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
    final List<UserActionCategory> suggestionList = actionType.suggestionList;
    return Wrap(
      spacing: Margins.spacing_s,
      runSpacing: Margins.spacing_s,
      children: switch (titleSource) {
        CreateActionTitleNotInitialized() => [
            ...suggestionList.map(
              (suggestion) => PassEmploiChip<UserActionCategory>(
                label: suggestion.value,
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
