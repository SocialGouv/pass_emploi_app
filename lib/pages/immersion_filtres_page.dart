import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/filter_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/slider/slider_caption.dart';
import 'package:pass_emploi_app/widgets/slider/slider_value.dart';

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
      builder: (context, viewModel) => _scaffold(viewModel),
      distinct: true,
      onWillChange: (previousVM, newVM) {
        if (previousVM?.displayState == DisplayState.LOADING && newVM.displayState == DisplayState.CONTENT) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _scaffold(ImmersionFiltresViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.offresEmploiFiltresTitle, context: context, withBackButton: true),
      body: _content(context, viewModel),
    );
  }

  Widget _content(ImmersionFiltresViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: Margins.spacing_l),
          _distanceSlider(viewModel),
          SepLineWithPadding(),
          if (_isError(viewModel)) ErrorText(viewModel.errorMessage),
          Padding(
            padding: const EdgeInsets.all(Margins.spacing_m),
            child: FilterButton(isEnabled: _isButtonEnabled(viewModel), onPressed: () => _onButtonClick(viewModel)),
          ),
        ],
      ),
    );
  }

  Column _distanceSlider(ImmersionFiltresViewModel viewModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SliderValue(value: _sliderValueToDisplay(viewModel).toInt()),
        ),
        _slider(viewModel),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SliderCaption(),
        ),
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

  bool _isButtonEnabled(ImmersionFiltresViewModel viewModel) =>
      _hasFormChanged && viewModel.displayState != DisplayState.LOADING;

  void _onButtonClick(ImmersionFiltresViewModel viewModel) =>
    viewModel.updateFiltres(_sliderValueToDisplay(viewModel).toInt());

  bool _isError(ImmersionFiltresViewModel viewModel) {
    return viewModel.displayState == DisplayState.FAILURE || viewModel.displayState == DisplayState.EMPTY;
  }
}
