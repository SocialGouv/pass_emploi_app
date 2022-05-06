import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/filter_button.dart';
import 'package:pass_emploi_app/widgets/checkbox_group.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/slider/distance_slider.dart';

class OffreEmploiFiltresPage extends TraceableStatefulWidget {
  OffreEmploiFiltresPage(bool fromAlternance)
      : super(
            name: fromAlternance
                ? AnalyticsScreenNames.alternanceFiltres
                : AnalyticsScreenNames.emploiFiltres);

  static MaterialPageRoute<bool> materialPageRoute(bool fromAlternance) {
    return MaterialPageRoute(
        builder: (_) => OffreEmploiFiltresPage(fromAlternance));
  }

  @override
  State<OffreEmploiFiltresPage> createState() => _OffreEmploiFiltresPageState();
}

class _OffreEmploiFiltresPageState extends State<OffreEmploiFiltresPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiFiltresViewModel>(
      converter: (store) => OffreEmploiFiltresViewModel.create(store),
      builder: (context, viewModel) => _scaffold(viewModel),
      distinct: true,
      onWillChange: (previousVM, newVM) {
        if (previousVM?.displayState == DisplayState.LOADING &&
            newVM.displayState == DisplayState.CONTENT) {
          Navigator.pop(context, true);
        }
      },
    );
  }

  Widget _scaffold(OffreEmploiFiltresViewModel viewModel) {
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

class _Content extends StatefulWidget {
  final OffreEmploiFiltresViewModel viewModel;

  _Content({required this.viewModel});

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  double? _currentSliderValue;
  List<CheckboxValueViewModel<ExperienceFiltre>>? _currentExperienceFiltres;
  List<CheckboxValueViewModel<ContratFiltre>>? _currentContratFiltres;
  List<CheckboxValueViewModel<DureeFiltre>>? _currentDureeFiltres;
  var _hasFormChanged = false;

  @override
  void initState() {
    super.initState();
    _currentExperienceFiltres = widget.viewModel.experienceFiltres
        .where((element) => element.isInitiallyChecked)
        .toList();
    _currentContratFiltres = widget.viewModel.contratFiltres
        .where((element) => element.isInitiallyChecked)
        .toList();
    _currentDureeFiltres = widget.viewModel.dureeFiltres
        .where((element) => element.isInitiallyChecked)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _Filters(
          viewModel: widget.viewModel,
          onDistanceValueChange: (value) => _setDistanceFilterState(value),
          onExperienceValueChange: (selectedOptions) =>
              _setExperienceFilterState(selectedOptions),
          onContractValueChange: (selectedOptions) =>
              _setContractFilterState(selectedOptions),
          onDurationValueChange: (selectedOptions) =>
              _setContractDurationState(selectedOptions),
        ),
        Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: FilterButton(
            isEnabled: _isButtonEnabled(widget.viewModel.displayState),
            onPressed: () => _onButtonClick(widget.viewModel),
          ),
        ),
      ],
    );
  }

  void _setDistanceFilterState(double value) {
    setState(() {
      _hasFormChanged = true;
      _currentSliderValue = value;
    });
  }

  void _setExperienceFilterState(
      List<CheckboxValueViewModel<ExperienceFiltre>> selectedOptions) {
    setState(() {
      _hasFormChanged = true;
      _currentExperienceFiltres = selectedOptions;
    });
  }

  void _setContractFilterState(
      List<CheckboxValueViewModel<ContratFiltre>> selectedOptions) {
    setState(() {
      _hasFormChanged = true;
      _currentContratFiltres = selectedOptions;
    });
  }

  void _setContractDurationState(
      List<CheckboxValueViewModel<DureeFiltre>> selectedOptions) {
    setState(() {
      _hasFormChanged = true;
      _currentDureeFiltres = selectedOptions;
    });
  }

  double _sliderValueToDisplay(double initialDistanceValue) =>
      _currentSliderValue != null ? _currentSliderValue! : initialDistanceValue;

  bool _isButtonEnabled(DisplayState viewModelDisplayState) =>
      _hasFormChanged && viewModelDisplayState != DisplayState.LOADING;

  void _onButtonClick(OffreEmploiFiltresViewModel viewModel) {
    viewModel.updateFiltres(
      _sliderValueToDisplay(viewModel.initialDistanceValue.toDouble()).toInt(),
      _currentExperienceFiltres ?? [],
      _currentContratFiltres ?? [],
      _currentDureeFiltres ?? [],
    );
  }
}

class _Filters extends StatefulWidget {
  final OffreEmploiFiltresViewModel viewModel;
  final Function(double) onDistanceValueChange;
  final Function(List<CheckboxValueViewModel<ExperienceFiltre>>)
      onExperienceValueChange;
  final Function(List<CheckboxValueViewModel<ContratFiltre>>)
      onContractValueChange;
  final Function(List<CheckboxValueViewModel<DureeFiltre>>)
      onDurationValueChange;

  _Filters({
    required this.viewModel,
    required this.onDistanceValueChange,
    required this.onExperienceValueChange,
    required this.onContractValueChange,
    required this.onDurationValueChange,
  });

  @override
  State<_Filters> createState() => _FiltersState();
}

class _FiltersState extends State<_Filters> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: Margins.spacing_l),
          if (widget.viewModel.shouldDisplayDistanceFiltre) ...[
            DistanceSlider(
              initialDistanceValue:
                  widget.viewModel.initialDistanceValue.toDouble(),
              onValueChange: (value) => widget.onDistanceValueChange(value),
            ),
            SepLineWithPadding(),
          ],
          if (widget.viewModel.shouldDisplayNonDistanceFiltres) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: CheckBoxGroup<ExperienceFiltre>(
                title: Strings.experienceSectionTitle,
                options: widget.viewModel.experienceFiltres,
                onSelectedOptionsUpdated: (selectedOptions) =>
                    widget.onExperienceValueChange(selectedOptions
                        as List<CheckboxValueViewModel<ExperienceFiltre>>),
              ),
            ),
            SizedBox(
              height: Margins.spacing_m,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: CheckBoxGroup<ContratFiltre>(
                title: Strings.contratSectionTitle,
                options: widget.viewModel.contratFiltres,
                onSelectedOptionsUpdated: (selectedOptions) =>
                    widget.onContractValueChange(selectedOptions
                        as List<CheckboxValueViewModel<ContratFiltre>>),
              ),
            ),
            SizedBox(
              height: Margins.spacing_l,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: CheckBoxGroup<DureeFiltre>(
                title: Strings.dureeSectionTitle,
                options: widget.viewModel.dureeFiltres,
                onSelectedOptionsUpdated: (selectedOptions) =>
                    widget.onDurationValueChange(selectedOptions
                        as List<CheckboxValueViewModel<DureeFiltre>>),
              ),
            ),
          ],
          if (_isError(widget.viewModel.displayState))
            ErrorText(widget.viewModel.errorMessage),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  bool _isError(DisplayState viewModeDisplayState) {
    return viewModeDisplayState == DisplayState.FAILURE ||
        viewModeDisplayState == DisplayState.EMPTY;
  }
}
