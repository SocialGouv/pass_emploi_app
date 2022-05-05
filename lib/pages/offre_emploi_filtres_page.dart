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
import 'package:pass_emploi_app/widgets/slider/slider_caption.dart';
import 'package:pass_emploi_app/widgets/slider/slider_value.dart';

class OffreEmploiFiltresPage extends TraceableStatefulWidget {
  OffreEmploiFiltresPage(bool fromAlternance)
      : super(name: fromAlternance ? AnalyticsScreenNames.alternanceFiltres : AnalyticsScreenNames.emploiFiltres);

  static MaterialPageRoute<bool> materialPageRoute(bool fromAlternance) {
    return MaterialPageRoute(builder: (_) => OffreEmploiFiltresPage(fromAlternance));
  }

  @override
  State<OffreEmploiFiltresPage> createState() => _OffreEmploiFiltresPageState();
}

class _OffreEmploiFiltresPageState extends State<OffreEmploiFiltresPage> {
  double? _currentSliderValue;
  List<CheckboxValueViewModel<ExperienceFiltre>>? _currentExperienceFiltres;
  List<CheckboxValueViewModel<ContratFiltre>>? _currentContratFiltres;
  List<CheckboxValueViewModel<DureeFiltre>>? _currentDureeFiltres;
  var _hasFormChanged = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiFiltresViewModel>(
      onInitialBuild: (viewModel) {
        _currentExperienceFiltres = viewModel.experienceFiltres.where((element) => element.isInitiallyChecked).toList();
        _currentContratFiltres = viewModel.contratFiltres.where((element) => element.isInitiallyChecked).toList();
        _currentDureeFiltres = viewModel.dureeFiltres.where((element) => element.isInitiallyChecked).toList();
      },
      converter: (store) => OffreEmploiFiltresViewModel.create(store),
      builder: (context, viewModel) => _scaffold(viewModel),
      distinct: true,
      onWillChange: (previousVM, newVM) {
        if (previousVM?.displayState == DisplayState.LOADING && newVM.displayState == DisplayState.CONTENT) {
          Navigator.pop(context, true);
        }
      },
    );
  }

  Widget _scaffold(OffreEmploiFiltresViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.offresEmploiFiltresTitle, context: context, withBackButton: true),
      body: _content(context, viewModel),
    );
  }

  Widget _content(OffreEmploiFiltresViewModel viewModel) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _offersList(viewModel),
        Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: FilterButton(isEnabled: _isButtonEnabled(viewModel), onPressed: () => _onButtonClick(viewModel)),
        ),
      ],
    );
  }

  Widget _offersList(OffreEmploiFiltresViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: Margins.spacing_l),
          if (viewModel.shouldDisplayDistanceFiltre) ...[
            _distanceSlider(viewModel),
            SepLineWithPadding(),
          ],
          if (viewModel.shouldDisplayNonDistanceFiltres) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: CheckBoxGroup<ExperienceFiltre>(
                title: Strings.experienceSectionTitle,
                options: viewModel.experienceFiltres,
                onSelectedOptionsUpdated: (selectedOptions) {
                  setState(() {
                    _hasFormChanged = true;
                    _currentExperienceFiltres = selectedOptions as List<CheckboxValueViewModel<ExperienceFiltre>>;
                  });
                },
              ),
            ),
            SizedBox(
              height: Margins.spacing_m,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: CheckBoxGroup<ContratFiltre>(
                title: Strings.contratSectionTitle,
                options: viewModel.contratFiltres,
                onSelectedOptionsUpdated: (selectedOptions) {
                  setState(() {
                    _hasFormChanged = true;
                    _currentContratFiltres = selectedOptions as List<CheckboxValueViewModel<ContratFiltre>>;
                  });
                },
              ),
            ),
            SizedBox(
              height: Margins.spacing_l,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: CheckBoxGroup<DureeFiltre>(
                title: Strings.dureeSectionTitle,
                options: viewModel.dureeFiltres,
                onSelectedOptionsUpdated: (selectedOptions) {
                  setState(() {
                    _hasFormChanged = true;
                    _currentDureeFiltres = selectedOptions as List<CheckboxValueViewModel<DureeFiltre>>;
                  });
                },
              ),
            ),
          ],
          if (_isError(viewModel)) ErrorText(viewModel.errorMessage),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Column _distanceSlider(OffreEmploiFiltresViewModel viewModel) {
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

  Widget _slider(OffreEmploiFiltresViewModel viewModel) {
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

  double _sliderValueToDisplay(OffreEmploiFiltresViewModel viewModel) =>
      _currentSliderValue != null ? _currentSliderValue! : viewModel.initialDistanceValue.toDouble();


  bool _isButtonEnabled(OffreEmploiFiltresViewModel viewModel) =>
      _hasFormChanged && viewModel.displayState != DisplayState.LOADING;

  void _onButtonClick(OffreEmploiFiltresViewModel viewModel) {
    viewModel.updateFiltres(
      _sliderValueToDisplay(viewModel).toInt(),
      _currentExperienceFiltres ?? [],
      _currentContratFiltres ?? [],
      _currentDureeFiltres ?? [],
    );
  }

  bool _isError(OffreEmploiFiltresViewModel viewModel) {
    return viewModel.displayState == DisplayState.FAILURE || viewModel.displayState == DisplayState.EMPTY;
  }
}
