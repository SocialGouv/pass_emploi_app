import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/offre_emploi/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/presentation/offre_suivie_form_viewmodel.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_radio_buttons.dart';

class OffreSuivieForm extends StatelessWidget {
  const OffreSuivieForm({
    super.key,
    required this.offreId,
    required this.showOffreDetails,
  });

  final bool showOffreDetails;
  final String offreId;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreSuivieFormViewmodel>(
        converter: (store) => OffreSuivieFormViewmodel.create(store, offreId, showOffreDetails),
        distinct: true,
        builder: (context, viewModel) {
          return CardContainer(
            backgroundColor: AppColors.primary,
            child: AnimatedSwitcher(
              duration: AnimationDurations.fast,
              child: viewModel.showConfirmation ? _Confirmation(viewModel) : _Content(viewModel, offreId),
            ),
          );
        });
  }
}

class _Confirmation extends StatelessWidget {
  const _Confirmation(this.viewModel);
  final OffreSuivieFormViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(AppIcons.check_circle_outline_rounded, color: Colors.white),
        SizedBox(height: Margins.spacing_s),
        Text(
          Strings.merciPourVotreReponse,
          textAlign: TextAlign.center,
          style: TextStyles.textBaseRegular.copyWith(color: Colors.white),
        ),
        if (viewModel.confirmationMessage != null) ...[
          SizedBox(height: Margins.spacing_s),
          Text(
            viewModel.confirmationMessage!,
            textAlign: TextAlign.center,
            style: TextStyles.textSRegular().copyWith(color: Colors.white),
          ),
        ],
        SizedBox(height: Margins.spacing_s),
        SizedBox(height: Margins.spacing_s),
        SecondaryButton(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          label: viewModel.confirmationButton,
          onPressed: () => viewModel.onHideForever(),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(
    this.viewModel,
    this.offreId,
  );
  final OffreSuivieFormViewmodel viewModel;
  final String offreId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...[
          Text(viewModel.dateConsultation, style: TextStyles.textSRegular().copyWith(color: Colors.white)),
          SizedBox(height: Margins.spacing_s),
        ],
        if (viewModel.offreLien != null) ...[
          _OffreLien(
            offreId: offreId,
            fromAlternance: viewModel.fromAlternance,
            offreLien: viewModel.offreLien!,
          ),
          SizedBox(height: Margins.spacing_s),
        ],
        Text(Strings.ouEnEtesVous, style: TextStyles.textBaseBold.copyWith(color: Colors.white)),
        SizedBox(height: Margins.spacing_s),
        _Options(viewModel),
      ],
    );
  }
}

class _OffreLien extends StatelessWidget {
  const _OffreLien({required this.offreId, required this.fromAlternance, required this.offreLien});
  final String offreId;
  final String offreLien;
  final bool fromAlternance;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: () =>
          Navigator.of(context).push(OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: fromAlternance)),
      child: Text(
        offreLien,
        style: TextStyles.textBaseMedium.copyWith(
          color: Colors.white,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
        ),
      ),
    );
  }
}

enum _OffreSuivieStatus { applied, interested, notInterested }

class _Options extends StatefulWidget {
  const _Options(this.viewModel);
  final OffreSuivieFormViewmodel viewModel;

  @override
  State<_Options> createState() => _OptionsState();
}

class _OptionsState extends State<_Options> {
  _OffreSuivieStatus? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Margins.spacing_s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimens.radius_base),
      ),
      child: Column(
        children: [
          PassEmploiRadio<_OffreSuivieStatus?>(
            title: Strings.jaiPostule,
            value: _OffreSuivieStatus.applied,
            groupValue: _selectedValue,
            onPressed: (status) {
              selectValue(status);
              widget.viewModel.onPostule();
            },
          ),
          PassEmploiRadio<_OffreSuivieStatus?>(
            title: Strings.caMinteresse,
            value: _OffreSuivieStatus.interested,
            groupValue: _selectedValue,
            onPressed: (status) {
              selectValue(status);
              widget.viewModel.onInteresse();
            },
          ),
          PassEmploiRadio<_OffreSuivieStatus?>(
            title: Strings.caNeMinteressePas,
            value: _OffreSuivieStatus.notInterested,
            groupValue: _selectedValue,
            onPressed: (status) {
              selectValue(status);
              widget.viewModel.onNotInterested();
            },
          ),
        ],
      ),
    );
  }

  void selectValue(_OffreSuivieStatus? value) {
    setState(() {
      _selectedValue = value;
    });
  }
}
