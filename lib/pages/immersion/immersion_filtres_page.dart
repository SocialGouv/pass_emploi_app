import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/filter_button.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/slider/distance_slider.dart';

class ImmersionFiltresPage extends StatefulWidget {
  static Future<bool?> show(BuildContext context) {
    return showPassEmploiBottomSheet<bool>(
      context: context,
      builder: (context) => ImmersionFiltresPage(),
    );
  }

  @override
  State<ImmersionFiltresPage> createState() => _ImmersionFiltresPageState();
}

class _ImmersionFiltresPageState extends State<ImmersionFiltresPage> {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.immersionFiltres,
      child: StoreConnector<AppState, ImmersionFiltresViewModel>(
        converter: (store) => ImmersionFiltresViewModel.create(store),
        builder: (context, viewModel) => _scaffold(viewModel),
        distinct: true,
        onWillChange: (previousVM, newVM) {
          if (previousVM?.displayState == DisplayState.LOADING && newVM.displayState == DisplayState.CONTENT) {
            Navigator.pop(context, true);
          }
        },
      ),
    );
  }

  Widget _scaffold(ImmersionFiltresViewModel viewModel) {
    return BottomSheetWrapper(
      title: Strings.offresEmploiFiltresTitle,
      body: _Content(viewModel: viewModel),
    );
  }
}

class _Content extends StatefulWidget {
  final ImmersionFiltresViewModel viewModel;

  _Content({required this.viewModel});

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  double? _currentSliderValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: Margins.spacing_l),
            DistanceSlider(
              initialDistanceValue: widget.viewModel.initialDistanceValue.toDouble(),
              onValueChange: (value) => _setDistanceFilterState(value),
            ),
            if (_isError(widget.viewModel)) ErrorText(widget.viewModel.errorMessage),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FilterButton(
            isEnabled: _isButtonEnabled(widget.viewModel),
            onPressed: () => _onButtonClick(widget.viewModel),
          ),
        ),
      ],
    );
  }

  void _setDistanceFilterState(double value) {
    setState(() => _currentSliderValue = value);
  }

  bool _isButtonEnabled(ImmersionFiltresViewModel viewModel) => viewModel.displayState != DisplayState.LOADING;

  void _onButtonClick(ImmersionFiltresViewModel viewModel) =>
      viewModel.updateFiltres(_sliderValueToDisplay(viewModel).toInt());

  bool _isError(ImmersionFiltresViewModel viewModel) {
    return viewModel.displayState == DisplayState.FAILURE || viewModel.displayState == DisplayState.EMPTY;
  }

  double _sliderValueToDisplay(ImmersionFiltresViewModel viewModel) =>
      _currentSliderValue != null ? _currentSliderValue! : viewModel.initialDistanceValue.toDouble();
}
