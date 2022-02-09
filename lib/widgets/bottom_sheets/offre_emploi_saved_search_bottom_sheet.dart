import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/presentation/saved_search_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';
import 'package:redux/redux.dart';

import 'bottom_sheets.dart';

class OffreEmploiSavedSearchBottomSheet extends AbstractSavedSearchBottomSheet<OffreEmploiSavedSearch> {
  final bool onlyAlternance;
  final _formKey = GlobalKey<FormState>();
  String? _searchTitle;

  OffreEmploiSavedSearchBottomSheet({required this.onlyAlternance})
      : super(
          selectState: (store) => store.state.offreEmploiSavedSearchState,
          analyticsScreenName:
              onlyAlternance ? AnalyticsScreenNames.alternanceResearch : AnalyticsScreenNames.emploiResearch,
          key: ValueKey(onlyAlternance),
        );

  @override
  SavedSearchViewModel<OffreEmploiSavedSearch> converter(Store<AppState> store) {
    return SavedSearchViewModel.createForOffreEmploi(store, onlyAlternance: onlyAlternance);
  }

  @override
  Widget buildSaveSearch(BuildContext context, OffreEmploiSavedSearchViewModel viewModel) {
    _searchTitle = viewModel.searchModel.title;
    return _buildForm(context, viewModel);
  }

  Form _buildForm(BuildContext context, OffreEmploiSavedSearchViewModel viewModel) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: FractionallySizedBox(
        heightFactor: 0.90,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            userActionBottomSheetHeader(context, title: Strings.createSavedSearchTitle),
            userActionBottomSheetSeparator(),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _savedSearchTitle(viewModel.searchModel),
                  _savedSearchFilters(viewModel.searchModel),
                  _savedSearchInfo(),
                ],
              ),
            ),
            _createButton(viewModel),
          ],
        ),
      ),
    );
  }

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
            onChanged: (value) {
              _updateSearchTitle(value);
            },
            isMandatory: true,
            mandatoryError: Strings.mandatorySavedSearchTitleError,
            textInputAction: TextInputAction.next,
            isEnabled: true,
          ),
        ],
      ),
    );
  }

  void _updateSearchTitle(String value) {
     setState(() =>_searchTitle = value);
  }

  Widget _savedSearchFilters(OffreEmploiSavedSearch searchViewModel) {
    List<String> _tags = onlyAlternance ? [Strings.savedSearchAlternanceTag] : [Strings.savedSearchEmploiTag];
    String? _keyWords = searchViewModel.keywords;
    String? _location = searchViewModel.location?.libelle;
    if (_keyWords != null && _keyWords.isNotEmpty) _tags.add(_keyWords);
    if (_location != null && _location.isNotEmpty) _tags.add(_location);
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

  Widget _createButton(OffreEmploiSavedSearchViewModel viewModel) {
    return Padding(
      padding: userActionBottomSheetContentPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryActionButton(
            label: Strings.create,
            onPressed: ((_searchTitle != null && _searchTitle!.isNotEmpty) || _isFormValid())
                ? () => {viewModel.createSavedSearch(_searchTitle)}
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDataTags(List<String> nonEmptyDataTags) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(spacing: 16, runSpacing: 16, children: nonEmptyDataTags.map(_buildTag).toList()),
    );
  }

  Widget _buildTag(String tag) {
    return DataTag(label: tag);
  }

  bool _isFormValid() => _formKey.currentState?.validate() == true;

  @override
  dismissBottomSheetIfNeeded(BuildContext context, OffreEmploiSavedSearchViewModel viewModel) {
    if (viewModel.displayState == CreateSavedSearchDisplayState.TO_DISMISS) {
      Navigator.pop(context);
    }
  }
}
