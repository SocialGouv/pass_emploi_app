import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/presentation/saved_search_view_model.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';

import '../models/saved_search/offre_emploi_saved_search.dart';
import '../ui/app_colors.dart';
import '../ui/drawables.dart';
import '../ui/margins.dart';
import '../ui/strings.dart';
import '../ui/text_styles.dart';
import 'bottom_sheets/bottom_sheets.dart';
import 'buttons/primary_action_button.dart';
import 'immersion_bottom_sheet_form.dart';

class OffreEmploiBottomSheetForm extends StatefulWidget {
  final SavedSearchViewModel<OffreEmploiSavedSearch> viewModel;
  final bool onlyAlternance;

  OffreEmploiBottomSheetForm(this.viewModel, this.onlyAlternance);

  @override
  State<OffreEmploiBottomSheetForm> createState() =>
      _OffreEmploiBottomSheetFormState(viewModel.searchModel.title.isNotEmpty ? viewModel.searchModel.title : null);
}

class _OffreEmploiBottomSheetFormState extends State<OffreEmploiBottomSheetForm> {
  String? searchTitle;

  _OffreEmploiBottomSheetFormState(this.searchTitle);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        userActionBottomSheetHeader(context, title: Strings.createSavedSearchTitle),
        userActionBottomSheetSeparator(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              _savedSearchTitle(widget.viewModel.searchModel),
              _savedSearchFilters(widget.viewModel.searchModel),
              _savedSearchInfo(),
            ],
          ),
        ),
        _createButton(widget.viewModel),
      ],
    );
  }

  Widget _createButton(OffreEmploiSavedSearchViewModel viewModel) {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryActionButton(
            label: Strings.create,
            onPressed: (_isFormValid()) ? () => {viewModel.createSavedSearch(searchTitle!)} : null,
          ),
        ],
      ),
    );
  }

  bool _isFormValid() => searchTitle != null && searchTitle!.isNotEmpty;

  Widget _savedSearchTitle(OffreEmploiSavedSearch searchViewModel) {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
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
      ),
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
            borderRadius: BorderRadius.circular(8.0),
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

  Widget _savedSearchFilters(OffreEmploiSavedSearch searchViewModel) {
    List<TagInfo> _tags = widget.onlyAlternance
        ? [TagInfo(Strings.savedSearchAlternanceTag, false)]
        : [TagInfo(Strings.savedSearchEmploiTag, false)];
    String? _keyWords = searchViewModel.keywords;
    String? _location = searchViewModel.location?.libelle;
    if (_keyWords != null && _keyWords.isNotEmpty) _tags.add(TagInfo(_keyWords, false));
    if (_location != null && _location.isNotEmpty) _tags.add(TagInfo(_location, true));
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.savedSearchFilters, style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_base),
          _buildDataTags(_tags),
        ],
      ),
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
      drawableRes: tagInfo.withIcon ? Drawables.icPlace : null,
    );
  }

  Widget _savedSearchInfo() {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: EdgeInsets.fromLTRB(6, 2, 6, 2), child: _setInfo(Strings.savedSearchInfo)),
          SizedBox(height: Margins.spacing_base),
          Padding(padding: EdgeInsets.fromLTRB(6, 2, 6, 2), child: _setInfo(Strings.searchNotificationInfo)),
        ],
      ),
    );
  }

  Widget _setInfo(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.asset(
                Drawables.icInfoBlue,
                height: 18,
                width: 18,
              ),
            )),
        SizedBox(
          width: 270,
          child: Text(
            label,
            style: TextStyles.textXsRegular(),
          ),
        ),
      ],
    );
  }
}
