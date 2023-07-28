import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/presentation/saved_search_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';

class ImmersionBottomSheetForm extends StatefulWidget {
  final SavedSearchViewModel<ImmersionSavedSearch> viewModel;

  ImmersionBottomSheetForm(this.viewModel);

  @override
  State<ImmersionBottomSheetForm> createState() => _ImmersionBottomSheetFormState();
}

class _ImmersionBottomSheetFormState extends State<ImmersionBottomSheetForm> {
  String? searchTitle;

  @override
  void initState() {
    super.initState();
    searchTitle = widget.viewModel.searchModel.title.isNotEmpty ? widget.viewModel.searchModel.title : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              _savedSearchTitle(widget.viewModel.searchModel),
              SizedBox(height: Margins.spacing_m),
              _savedSearchFilters(widget.viewModel.searchModel),
              SizedBox(height: Margins.spacing_m),
              _savedSearchInfo(),
            ],
          ),
        ),
        _createButton(widget.viewModel),
      ],
    );
  }

  Widget _createButton(ImmersionSavedSearchViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryActionButton(
          label: Strings.createSavedSearchButton,
          icon: AppIcons.notifications_rounded,
          iconSize: Dimens.icon_size_base,
          onPressed: (_isFormValid())
              ? () {
                  viewModel.createSavedSearch(searchTitle!);
                  PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.createSavedSearchImmersion);
                }
              : null,
        ),
        if (viewModel.savingFailure()) _createError(),
      ],
    );
  }

  bool _isFormValid() => searchTitle != null && searchTitle!.isNotEmpty;

  Widget _savedSearchTitle(ImmersionSavedSearch searchViewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.savedSearchTitle, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        _textField(
          initialValue: searchViewModel.title,
          onChanged: _updateTitle,
          isMandatory: true,
          mandatoryError: Strings.mandatorySavedSearchTitleError,
          textInputAction: TextInputAction.next,
          isEnabled: true,
        ),
      ],
    );
  }

  void _updateTitle(String value) {
    setState(() {
      searchTitle = value;
    });
  }

  TextFormField _textField({
    required ValueChanged<String>? onChanged,
    bool isMandatory = false,
    String? mandatoryError,
    TextInputAction? textInputAction,
    required bool isEnabled,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      enabled: isEnabled,
      minLines: 1,
      maxLines: 1,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          errorText: (searchTitle != null && searchTitle!.isEmpty) ? mandatoryError : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimens.radius_base),
            borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
          )),
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: textInputAction,
      style: TextStyles.textSBold,
      validator: (value) {
        if (isMandatory && (value == null || value.isEmpty)) return mandatoryError;
        return null;
      },
      onChanged: onChanged,
    );
  }

  Widget _savedSearchFilters(ImmersionSavedSearch searchViewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.savedSearchFilters, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        _buildDataTags([
          TagInfo(Strings.savedSearchImmersionTag, false),
          TagInfo(searchViewModel.metier, false),
          TagInfo(searchViewModel.ville, true),
        ]),
      ],
    );
  }

  Widget _buildDataTags(List<TagInfo> nonEmptyDataTags) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(spacing: 16, runSpacing: 16, children: nonEmptyDataTags.map(_buildTag).toList()),
    );
  }

  Widget _buildTag(TagInfo tagInfo) {
    return DataTag(
      label: tagInfo.label,
      icon: tagInfo.withIcon ? AppIcons.location_on_rounded : null,
    );
  }

  Widget _savedSearchInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(padding: EdgeInsets.fromLTRB(6, 2, 6, 2), child: _setInfo(Strings.savedSearchInfo)),
        SizedBox(height: Margins.spacing_base),
        Padding(padding: EdgeInsets.fromLTRB(6, 2, 6, 2), child: _setInfo(Strings.searchNotificationInfo)),
      ],
    );
  }

  Widget _setInfo(String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                AppIcons.info_rounded,
                size: Dimens.icon_size_base,
                color: AppColors.primary,
              ),
            )),
        SizedBox(
          width: 270,
          child: Text(
            label,
            style: TextStyles.textSRegular(),
          ),
        ),
      ],
    );
  }

  Widget _createError() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        Strings.creationSavedSearchError,
        textAlign: TextAlign.center,
        style: TextStyles.textSRegular(color: AppColors.warning),
      ),
    );
  }
}

class TagInfo {
  final String label;
  final bool withIcon;

  TagInfo(this.label, this.withIcon);
}
