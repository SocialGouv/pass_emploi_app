import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/presentation/alerte_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/info_card.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class ServiceCiviqueBottomSheetForm extends StatefulWidget {
  final AlerteViewModel<ServiceCiviqueAlerte> viewModel;

  ServiceCiviqueBottomSheetForm(this.viewModel);

  @override
  State<ServiceCiviqueBottomSheetForm> createState() => _ServiceCiviqueBottomSheetFormState();
}

class _ServiceCiviqueBottomSheetFormState extends State<ServiceCiviqueBottomSheetForm> {
  String? searchTitle;

  @override
  void initState() {
    super.initState();
    searchTitle = widget.viewModel.searchModel.titre.isNotEmpty ? widget.viewModel.searchModel.titre : null;
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

  Widget _createButton(ServiceCiviqueAlerteViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryActionButton(
          label: Strings.createAlert,
          icon: AppIcons.notifications_rounded,
          iconSize: Dimens.icon_size_base,
          onPressed: (_isFormValid())
              ? () {
                  viewModel.createAlerte(searchTitle!);
                  PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.createAlerteServiceCivique);
                }
              : null,
        ),
        if (viewModel.savingFailure()) _createError(),
      ],
    );
  }

  bool _isFormValid() => searchTitle != null && searchTitle!.isNotEmpty;

  Widget _alerteTitle(ServiceCiviqueAlerte searchViewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.alerteTitle, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        BaseTextField(
          initialValue: searchViewModel.titre,
          minLines: 1,
          maxLines: 1,
          keyboardType: TextInputType.multiline,
          errorText: (searchTitle != null && searchTitle!.isEmpty) ? Strings.mandatoryAlerteTitleError : null,
          textInputAction: TextInputAction.next,
          onChanged: _updateTitle,
        ),
      ],
    );
  }

  void _updateTitle(String value) {
    setState(() {
      searchTitle = value;
    });
  }

  Widget _alerteFilters(ServiceCiviqueAlerte searchViewModel) {
    final domaine = searchViewModel.domaine?.titre;
    final ville = searchViewModel.ville;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.alerteFilters, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        _buildDataTags([
          TagInfo(Strings.serviceCiviqueTag, false),
          if (domaine != null && domaine.isNotEmpty) TagInfo(domaine, false),
          if (ville != null && ville.isNotEmpty) TagInfo(ville, true),
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
      iconSemantics:
          tagInfo.withIcon ? IconWithSemantics(AppIcons.place_outlined, Strings.iconAlternativeLocation) : null,
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

class TagInfo {
  final String label;
  final bool withIcon;

  TagInfo(this.label, this.withIcon);
}
