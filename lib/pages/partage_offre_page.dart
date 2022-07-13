import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/partage_offre_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class PartageOffrePage extends TraceableStatefulWidget {
  final OffreType type;

  PartageOffrePage._({required this.type}) : super(name: AnalyticsScreenNames.emploiPartagePage);

  @override
  _PartageOffrePageState createState() => _PartageOffrePageState();

  static MaterialPageRoute<void> materialPageRoute(OffreType type) {
    return MaterialPageRoute(builder: (context) {
      return PartageOffrePage._(type: type);
    });
  }
}

class _PartageOffrePageState extends State<PartageOffrePage> {
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController(text: Strings.partageOffreDefaultMessage);
    return StoreConnector<AppState, PartageOffrePageViewModel>(
      converter: (store) => PartageOffrePageViewModel.create(store),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      onWillChange: (_, viewModel) => _displaySnackBar(viewModel),
      distinct: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Scaffold _scaffold(BuildContext context, PartageOffrePageViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(
        label: _setTitle(),
        context: context,
        withBackButton: true,
      ),
      body: _body(context, viewModel),
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
    if (viewModel.snackbarState == DisplayState.LOADING) {
      return Center(child: CircularProgressIndicator(color: AppColors.nightBlue));
    } else {
      return PrimaryActionButton(
        label: _setButtonTitle(),
        onPressed: () => viewModel.onPartagerOffre(_controller.text, widget.type),
      );
    }
  }

  String _setTitle() =>
      widget.type == OffreType.alternance ? Strings.partageOffreAlternanceNavTitle : Strings.partageOffreNavTitle;

  String _setButtonTitle() =>
      widget.type == OffreType.alternance ? Strings.partagerOffreAlternance : Strings.partagerOffreEmploi;


  void _displaySnackBar(PartageOffrePageViewModel viewModel) {
    switch (viewModel.snackbarState) {
      case DisplayState.EMPTY:
      case DisplayState.LOADING:
        return;
      case DisplayState.CONTENT:
        MatomoTracker.trackScreenWithName(AnalyticsScreenNames.emploiPartagePageSuccess, "");
        showSuccessfulSnackBar(context, Strings.partageOffreSuccess);
        viewModel.snackbarDisplayed();
        Navigator.pop(context);
        return;
      case DisplayState.FAILURE:
        showFailedSnackBar(context, Strings.miscellaneousErrorRetry);
        viewModel.snackbarDisplayed();
        return;
    }
  }
}
