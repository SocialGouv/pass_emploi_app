import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

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
        if (previousViewModel?.displayState == OffreEmploiFiltresDisplayState.LOADING &&
            newViewModel.displayState == OffreEmploiFiltresDisplayState.SUCCESS) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _scaffold(BuildContext context, OffreEmploiFiltresViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: _content(context, viewModel),
    );
  }

  Widget _content(BuildContext context, OffreEmploiFiltresViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 32),
          if (viewModel.shouldDisplayDistanceFiltre) _distanceSlider(context, viewModel)
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
          child: _sliderLegende(),
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

  FlatDefaultAppBar _appBar() {
    return FlatDefaultAppBar(
      title: Text(Strings.offresEmploiFiltresTitle, style: TextStyles.textLgMedium),
    );
  }

  Widget _sliderValue(OffreEmploiFiltresViewModel viewModel) {
    return Row(
      children: [
        Text("Dans un rayon de : ", style: TextStyles.textMdRegular),
        Text("${_sliderValueToDisplay(viewModel).toInt()} km", style: TextStyles.textMdMedium),
      ],
    );
  }

  Widget _slider(OffreEmploiFiltresViewModel viewModel) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 6.0,
        activeTrackColor: AppColors.nightBlue,
        inactiveTrackColor: AppColors.bluePurple,
        thumbColor: AppColors.nightBlue,
        activeTickMarkColor: AppColors.nightBlue,
        inactiveTickMarkColor: AppColors.bluePurple,
      ),
      child: Slider(
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
      ),
    );
  }

  double _sliderValueToDisplay(OffreEmploiFiltresViewModel viewModel) =>
      _currentSliderValue != null ? _currentSliderValue! : viewModel.initialDistanceValue.toDouble();

  Widget _sliderLegende() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("0km", style: TextStyles.textSmMedium()),
        Text("100km", style: TextStyles.textSmMedium()),
      ],
    );
  }

  Widget _stretchedButton(BuildContext context, OffreEmploiFiltresViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        primaryActionButton(
          onPressed: _hasFormChanged && viewModel.displayState == OffreEmploiFiltresDisplayState.SUCCESS
              ? () => viewModel.updateFiltres(_sliderValueToDisplay(viewModel).toInt())
              : null,
          label: "Appliquer les filtres",
        ),
      ],
    );
  }
}
