import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/checkbox_group.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';

class OffreEmploiFiltresPage extends TraceableStatefulWidget {
  OffreEmploiFiltresPage() : super(name: AnalyticsScreenNames.offreEmploiFiltres);

  static MaterialPageRoute materialPageRoute() => MaterialPageRoute(builder: (_) => OffreEmploiFiltresPage());

  @override
  State<OffreEmploiFiltresPage> createState() => _OffreEmploiFiltresPageState();
}

class _OffreEmploiFiltresPageState extends State<OffreEmploiFiltresPage> {
  double? _currentSliderValue;
  var _hasFormChanged = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiFiltresViewModel>(
      converter: (store) => OffreEmploiFiltresViewModel.create(store),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      distinct: true,
      onWillChange: (previousViewModel, newViewModel) {
        if (previousViewModel?.displayState == DisplayState.LOADING &&
            newViewModel.displayState == DisplayState.CONTENT) {
          Navigator.pop(context, true);
        }
      },
    );
  }

  Widget _scaffold(BuildContext context, OffreEmploiFiltresViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FlatDefaultAppBar(title: Text(Strings.offresEmploiFiltresTitle, style: TextStyles.textLgMedium)),
      body: _content(context, viewModel),
    );
  }

  Widget _content(BuildContext context, OffreEmploiFiltresViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 32),
          if (viewModel.shouldDisplayDistanceFiltre) _distanceSlider(context, viewModel),
          CheckBoxGroup(
            title: "Expérience",
            options: ["De 0 à 1 an", "De 1 an à 3 ans", "3 ans et +"],
            onSelectedOptionsUpdated: (selectedOptions) => debugPrint("🥏 ${selectedOptions.length}"),
          ),
          CheckBoxGroup(
            title: "Type de contrat",
            options: ["CDI", "CDD - intérim - saisonnier", "Autres"],
            onSelectedOptionsUpdated: (selectedOptions) => debugPrint("🏓 ${selectedOptions.length}"),
          ),
          CheckBoxGroup(
            title: "Temps de travail",
            options: ["Temps plein", "Temps partiel"],
            onSelectedOptionsUpdated: (selectedOptions) => debugPrint("🛷 ${selectedOptions.length}"),
          ),
        ],
      ),
    );
  }

  Column _distanceSlider(BuildContext context, OffreEmploiFiltresViewModel viewModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _sliderValue(viewModel),
        ),
        _slider(viewModel),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _sliderCaption(),
        ),
        SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(height: 1, color: AppColors.bluePurple),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: _stretchedButton(context, viewModel),
        ),
      ],
    );
  }

  Widget _sliderValue(OffreEmploiFiltresViewModel viewModel) {
    return Row(
      children: [
        Text(Strings.searchRadius, style: TextStyles.textMdRegular),
        Text(Strings.kmFormat(_sliderValueToDisplay(viewModel).toInt()), style: TextStyles.textMdMedium),
      ],
    );
  }

  Widget _slider(OffreEmploiFiltresViewModel viewModel) {
    return Slider(
      value: _sliderValueToDisplay(viewModel),
      min: 0,
      max: 100,
      divisions: 10,
      onChanged: (value) {
        if (value > 0)
          setState(() {
            _currentSliderValue = value;
            _hasFormChanged = true;
          });
      },
    );
  }

  double _sliderValueToDisplay(OffreEmploiFiltresViewModel viewModel) =>
      _currentSliderValue != null ? _currentSliderValue! : viewModel.initialDistanceValue.toDouble();

  Widget _sliderCaption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(Strings.kmFormat(0), style: TextStyles.textSmMedium()),
        Text(Strings.kmFormat(100), style: TextStyles.textSmMedium()),
      ],
    );
  }

  Widget _stretchedButton(BuildContext context, OffreEmploiFiltresViewModel viewModel) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: PrimaryActionButton.simple(
        onPressed: _hasFormChanged && viewModel.displayState == DisplayState.CONTENT
            ? () => viewModel.updateFiltres(_sliderValueToDisplay(viewModel).toInt())
            : null,
        label: Strings.applyFiltres,
      ),
    );
  }
}
