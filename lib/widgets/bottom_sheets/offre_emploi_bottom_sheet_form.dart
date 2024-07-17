import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/presentation/alerte_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/immersion_bottom_sheet_form.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/info_card.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class OffreEmploiBottomSheetForm extends StatefulWidget {
  final AlerteViewModel<OffreEmploiAlerte> viewModel;
  final bool onlyAlternance;

  OffreEmploiBottomSheetForm(this.viewModel, this.onlyAlternance);

  @override
  State<OffreEmploiBottomSheetForm> createState() => _OffreEmploiBottomSheetFormState();
}

class _OffreEmploiBottomSheetFormState extends State<OffreEmploiBottomSheetForm> {
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
        SizedBox(height: Margins.spacing_base),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              _alerteTitle(widget.viewModel.searchModel),
              SizedBox(height: Margins.spacing_m),
              _alerteFilters(widget.viewModel.searchModel),
              SizedBox(height: Margins.spacing_m),
              InfoCard(message: '${Strings.alerteInfo}\n${Strings.searchNotificationInfo}'),
            ],
          ),
        ),
        _createButton(widget.viewModel),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }

  Widget _createButton(OffreEmploiAlerteViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryActionButton(
          label: Strings.createAlert,
          icon: AppIcons.notifications_rounded,
          iconSize: Dimens.icon_size_m,
          onPressed: (_isFormValid())
              ? () {
                  viewModel.createAlerte(searchTitle!);
                  PassEmploiMatomoTracker.instance.trackScreen(
                    widget.onlyAlternance
                        ? AnalyticsActionNames.createAlerteAlternance
                        : AnalyticsActionNames.createAlerteEmploi,
                  );
                }
              : null,
        ),
        if (viewModel.savingFailure()) _createError(),
      ],
    );
  }

  bool _isFormValid() => searchTitle != null && searchTitle!.isNotEmpty;

  Widget _alerteTitle(OffreEmploiAlerte searchViewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.alerteTitle, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        BaseTextField(
          initialValue: searchViewModel.title,
          minLines: 1,
          maxLines: 1,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.next,
          errorText: (searchTitle != null && searchTitle!.isEmpty) ? Strings.mandatoryAlerteTitleError : null,
          onChanged: _updateTitle,
        )
      ],
    );
  }

  void _updateTitle(String value) {
    setState(() {
      searchTitle = value;
    });
  }

  Widget _alerteFilters(OffreEmploiAlerte searchViewModel) {
    final List<TagInfo> tags = [TagInfo(searchViewModel.getAlerteTagLabel(), false)];
    final String? keyWords = searchViewModel.keyword;
    final String? location = searchViewModel.location?.libelle;
    if (keyWords != null && keyWords.isNotEmpty) tags.add(TagInfo(keyWords, false));
    if (location != null && location.isNotEmpty) tags.add(TagInfo(location, true));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.alerteFilters, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        _buildDataTags(tags),
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
      icon: tagInfo.withIcon ? AppIcons.place_outlined : null,
    );
  }

  Widget _createError() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        Strings.creationAlerteError,
        textAlign: TextAlign.center,
        style: TextStyles.textSRegular(color: AppColors.warning),
      ),
    );
  }
}
