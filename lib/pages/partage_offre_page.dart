import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/partage_offre_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class PartageOffrePage extends TraceableStatelessWidget {

  late TextEditingController _controller;

  PartageOffrePage._() : super(name: AnalyticsScreenNames.emploiPartagePage);

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) {
      return PartageOffrePage._();
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController();
    return StoreConnector<AppState, PartageOffrePageViewModel>(
      converter: (store) => PartageOffrePageViewModel.create(store),
      builder: (context, viewModel) => _scaffold(_body(context, viewModel), context),
      distinct: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  Scaffold _scaffold(Widget body, BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.partageOffreNavTitle, context: context, withBackButton: true),
      body: body,
    );
  }

  Widget _body(BuildContext context, PartageOffrePageViewModel viewModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Strings.souhaitDePartagerOffre, style: TextStyles.textBaseBold),
            SizedBox(height: Margins.spacing_base),
            _offre(viewModel),
            SizedBox(height: Margins.spacing_l),
            Text(Strings.messagePourConseiller, style: TextStyles.textBaseMedium),
            SizedBox(height: Margins.spacing_base),
            _textField(),
            SizedBox(height: Margins.spacing_l),
            _infoPartage(),
            SizedBox(height: Margins.spacing_l),
            _shareButton(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _offre(PartageOffrePageViewModel viewModel) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey100, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(viewModel.offreTitle, style: TextStyles.textBaseBold),
      ),
    );
  }

  Widget _textField() {
    return TextField(
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
        ),
      ),
      maxLines: null,
      controller: _controller,
    );
  }

  Widget _infoPartage() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          Strings.offrePartageChat,
          style: TextStyles.textBaseBoldWithColor(AppColors.primary),
        ),
      ),
    );
  }

  Widget _shareButton(BuildContext context, PartageOffrePageViewModel viewModel) {
    return PrimaryActionButton(
      label: Strings.partagerOffreEmploi,
      onPressed: () => {_partagerOffre(context, viewModel)},
    );
  }

  _partagerOffre(BuildContext context, PartageOffrePageViewModel viewModel) {
    viewModel.onPartagerOffre(_controller.text);
    MatomoTracker.trackScreenWithName(AnalyticsScreenNames.emploiPartagePageSuccess, "");
    Navigator.pop(context);
  }
}
