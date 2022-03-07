import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class ImmersionFiltresPage extends TraceableStatefulWidget {
  const ImmersionFiltresPage() : super(name: AnalyticsScreenNames.immersionFiltres);

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (_) => ImmersionFiltresPage());
  }

  @override
  State<ImmersionFiltresPage> createState() => _ImmersionFiltresPageState();
}

class _ImmersionFiltresPageState extends State<ImmersionFiltresPage> {
  double? _currentSliderValue;
  var _hasFormChanged = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ImmersionFiltresViewModel>(
      converter: (store) => ImmersionFiltresViewModel.create(store),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      distinct: true,
      onWillChange: (previousVM, newVM) {
        if (previousVM?.displayState == DisplayState.LOADING && newVM.displayState == DisplayState.CONTENT) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _scaffold(BuildContext context, ImmersionFiltresViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.offresEmploiFiltresTitle, withBackButton: true),
      body: _content(context, viewModel),
    );
  }

  Widget _content(BuildContext context, ImmersionFiltresViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: Margins.spacing_l),
          _distanceSlider(context, viewModel),
          _sepLine(),
          if (_isError(viewModel)) ErrorText(viewModel.errorMessage),
          Padding(
            padding: const EdgeInsets.all(Margins.spacing_m),
            child: _stretchedButton(context, viewModel),
          ),
        ],
      ),
    );
  }

  Column _distanceSlider(BuildContext context, ImmersionFiltresViewModel viewModel) {
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
      ],
    );
  }

  Widget _sliderValue(ImmersionFiltresViewModel viewModel) {
    return Row(
      children: [
        Text(Strings.searchRadius, style: TextStyles.textBaseBold),
        Text(Strings.kmFormat(_sliderValueToDisplay(viewModel).toInt()), style: TextStyles.textBaseBold),
      ],
    );
  }

  Widget _slider(ImmersionFiltresViewModel viewModel) {
    return Slider(
      value: _sliderValueToDisplay(viewModel),
      min: 0,
      max: 100,
      divisions: 10,
      onChanged: (value) {
        if (value > 0) {
          setState(() {
            _currentSliderValue = value;
            _hasFormChanged = true;
          });
        }
      },
    );
  }

  double _sliderValueToDisplay(ImmersionFiltresViewModel viewModel) =>
      _currentSliderValue != null ? _currentSliderValue! : viewModel.initialDistanceValue.toDouble();

  Widget _sliderCaption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(Strings.kmFormat(0), style: TextStyles.textSBold),
        Text(Strings.kmFormat(100), style: TextStyles.textSBold),
      ],
    );
  }

  Widget _stretchedButton(BuildContext context, ImmersionFiltresViewModel viewModel) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: PrimaryActionButton(
        onPressed: _hasFormChanged && viewModel.displayState != DisplayState.LOADING
            ? () => viewModel.updateFiltres(
                  _sliderValueToDisplay(viewModel).toInt(),
                )
            : null,
        label: Strings.applyFiltres,
      ),
    );
  }

  Widget _sepLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SepLine(24, 24),
    );
  }

  bool _isError(ImmersionFiltresViewModel viewModel) {
    return viewModel.displayState == DisplayState.FAILURE || viewModel.displayState == DisplayState.EMPTY;
  }
}
