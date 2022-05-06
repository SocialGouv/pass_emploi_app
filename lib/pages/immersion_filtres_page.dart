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
import 'package:pass_emploi_app/widgets/slider/distance_slider.dart';

class ImmersionFiltresPage extends TraceableStatefulWidget {
  const ImmersionFiltresPage()
      : super(name: AnalyticsScreenNames.immersionFiltres);

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (_) => ImmersionFiltresPage());
  }

  @override
  State<ImmersionFiltresPage> createState() => _ImmersionFiltresPageState();
}

class _ImmersionFiltresPageState extends State<ImmersionFiltresPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ImmersionFiltresViewModel>(
      converter: (store) => ImmersionFiltresViewModel.create(store),
      builder: (context, viewModel) => _scaffold(viewModel),
      distinct: true,
      onWillChange: (previousVM, newVM) {
        if (previousVM?.displayState == DisplayState.LOADING &&
            newVM.displayState == DisplayState.CONTENT) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _scaffold(ImmersionFiltresViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(
          label: Strings.offresEmploiFiltresTitle,
          context: context,
          withBackButton: true),
      body: _content(context, viewModel),
    );
  }
}

double _sliderValueToDisplay(ImmersionFiltresViewModel viewModel) =>
    _currentSliderValue != null
        ? _currentSliderValue!
        : viewModel.initialDistanceValue.toDouble();

class _Content extends StatelessWidget {
  final ImmersionFiltresViewModel viewModel;

  _Content({required this.viewModel});

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  var _hasFormChanged = false;
  double? _currentSliderValue;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: Margins.spacing_l),
          DistanceSlider(
            initialDistanceValue:
                widget.viewModel.initialDistanceValue.toDouble(),
            onValueChange: (value) => _setDistanceFilterState(value),
          ),
          SepLineWithPadding(),
          if (_isError(widget.viewModel))
            ErrorText(widget.viewModel.errorMessage),
          Padding(
            padding: const EdgeInsets.all(Margins.spacing_m),
            child: FilterButton(
                isEnabled: _isButtonEnabled(viewModel),
                onPressed: () => _onButtonClick(viewModel)),
          ),
        ],
      ),
    );
  }

  void _setDistanceFilterState(double value) {
    setState(() {
      _hasFormChanged = true;
      _currentSliderValue = value;
    });
  }

  bool _isButtonEnabled(ImmersionFiltresViewModel viewModel) =>
      _hasFormChanged && viewModel.displayState != DisplayState.LOADING;

  void _onButtonClick(ImmersionFiltresViewModel viewModel) =>
      viewModel.updateFiltres(_sliderValueToDisplay(viewModel).toInt());

  bool _isError(ImmersionFiltresViewModel viewModel) {
    return viewModel.displayState == DisplayState.FAILURE ||
        viewModel.displayState == DisplayState.EMPTY;
  }

  double _sliderValueToDisplay(ImmersionFiltresViewModel viewModel) =>
      _currentSliderValue != null
          ? _currentSliderValue!
          : viewModel.initialDistanceValue.toDouble();
}
