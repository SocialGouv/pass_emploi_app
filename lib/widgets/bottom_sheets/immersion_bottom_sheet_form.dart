import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/presentation/alerte_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class ImmersionBottomSheetForm extends StatefulWidget {
  final AlerteViewModel<ImmersionAlerte> viewModel;

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
        SizedBox(height: Margins.spacing_base),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              _alerteTitle(widget.viewModel.searchModel),
              SizedBox(height: Margins.spacing_m),
              _alerteFilters(widget.viewModel.searchModel),
              SizedBox(height: Margins.spacing_m),
              _alerteInfo(),
            ],
          ),
        ),
        _createButton(widget.viewModel),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }

  Widget _createButton(ImmersionAlerteViewModel viewModel) {
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
                  PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.createAlerteImmersion);
                }
              : null,
        ),
        if (viewModel.savingFailure()) _createError(),
      ],
    );
  }

  bool _isFormValid() => searchTitle != null && searchTitle!.isNotEmpty;

  Widget _alerteTitle(ImmersionAlerte searchViewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.alerteTitle, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        BaseTextField(
          initialValue: searchViewModel.title,
          textInputAction: TextInputAction.next,
          minLines: 1,
          maxLines: 1,
          keyboardType: TextInputType.multiline,
          errorText: ((searchTitle != null && searchTitle!.isEmpty) ? Strings.mandatoryAlerteTitleError : null),
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

  Widget _alerteFilters(ImmersionAlerte searchViewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.alerteFilters, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        _buildDataTags([
          TagInfo(Strings.immersionTag, false),
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
      icon: tagInfo.withIcon ? AppIcons.place_outlined : null,
    );
  }

  Widget _alerteInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(padding: EdgeInsets.fromLTRB(6, 2, 6, 2), child: _setInfo(Strings.alerteInfo)),
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
