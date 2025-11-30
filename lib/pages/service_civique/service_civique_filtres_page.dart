import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/service_civique/service_civique_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/filter_button.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker.dart';
import 'package:pass_emploi_app/widgets/radio_list_tile.dart';
import 'package:pass_emploi_app/widgets/slider/distance_slider.dart';
import 'package:pass_emploi_app/widgets/toggles/date_toggle.dart';

class ServiceCiviqueFiltresPage extends StatefulWidget {
  static Future<bool?> show(BuildContext context) {
    return showPassEmploiBottomSheet<bool>(
      context: context,
      builder: (context) => ServiceCiviqueFiltresPage(),
    );
  }

  @override
  State<ServiceCiviqueFiltresPage> createState() => _ServiceCiviqueFiltresPageState();
}

class _ServiceCiviqueFiltresPageState extends State<ServiceCiviqueFiltresPage> {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.serviceCiviqueFiltres,
      child: StoreConnector<AppState, ServiceCiviqueFiltresViewModel>(
        converter: (store) => ServiceCiviqueFiltresViewModel.create(store),
        builder: (context, viewModel) => _scaffold(context, viewModel),
        distinct: true,
      ),
    );
  }

  Widget _scaffold(BuildContext context, ServiceCiviqueFiltresViewModel viewModel) {
    return BottomSheetWrapper(
      title: Strings.serviceCiviqueFiltresTitle,
      body: _Content(viewModel: viewModel),
    );
  }
}

class _Content extends StatefulWidget {
  final ServiceCiviqueFiltresViewModel viewModel;

  _Content({required this.viewModel});

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  double? _currentSliderValue;
  DateTime? _currentStartDate;
  Domaine? _currentDomainValue;

  @override
  void initState() {
    super.initState();
    _currentStartDate = widget.viewModel.initialStartDateValue;
    _currentDomainValue = widget.viewModel.initialDomainValue;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _Filters(
          viewModel: widget.viewModel,
          onDistanceValueChange: (distance) => _setDistanceFilterState(distance),
          onStartDateValueChange: (date, isActive) => _setStartDateFilterState(date, isActive),
          onDomainValueChange: (domain) => _setDomainFilterState(domain),
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

  void _setStartDateFilterState(DateTime? date, bool isActive) {
    setState(() => _currentStartDate = isActive ? date : null);
  }

  void _setDomainFilterState(Domaine? domain) {
    setState(() => _currentDomainValue = domain);
  }

  bool _isButtonEnabled(ServiceCiviqueFiltresViewModel viewModel) => viewModel.displayState != DisplayState.LOADING;

  void _onButtonClick(ServiceCiviqueFiltresViewModel viewModel) {
    viewModel.updateFiltres(
      _sliderValueToDisplay(viewModel.initialDistanceValue),
      _currentDomainValue,
      _currentStartDate,
    );
    Navigator.pop(context, true);
  }

  int _sliderValueToDisplay(int viewModelInitialDistanceValue) =>
      _currentSliderValue != null ? _currentSliderValue!.toInt() : viewModelInitialDistanceValue;
}

class _Filters extends StatefulWidget {
  final ServiceCiviqueFiltresViewModel viewModel;
  final Function(double) onDistanceValueChange;
  final Function(DateTime?, bool) onStartDateValueChange;
  final Function(Domaine) onDomainValueChange;

  _Filters({
    required this.viewModel,
    required this.onDistanceValueChange,
    required this.onStartDateValueChange,
    required this.onDomainValueChange,
  });

  @override
  State<_Filters> createState() => _FiltersState();
}

class _FiltersState extends State<_Filters> {
  bool _isActiveDate = false;
  DateTime? _currentStartDate;
  Domaine? _currentDomainValue;

  @override
  void initState() {
    super.initState();
    _currentStartDate = widget.viewModel.initialStartDateValue ?? DateTime.now();
    _isActiveDate = widget.viewModel.initialStartDateValue != null;
    _currentDomainValue = widget.viewModel.initialDomainValue;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: Margins.spacing_l),
          if (widget.viewModel.shouldDisplayDistanceFiltre) ...[
            DistanceSlider(
              initialDistanceValue: widget.viewModel.initialDistanceValue.toDouble(),
              onValueChange: (value) => widget.onDistanceValueChange(value),
            ),
            SizedBox(height: Margins.spacing_l),
          ],
          _StartDateFilters(
            initialDateValue: _isActiveDate ? _currentStartDate : null,
            onIsActiveChange: _onIsActiveChange,
            onDateChange: _onDateChange,
            isActiveDate: _isActiveDate,
          ),
          SizedBox(height: Margins.spacing_l),
          _DomainFilters(
            currentDomainValue: _currentDomainValue!,
            onValueChange: (value) => widget.onDomainValueChange(value),
          ),
          SizedBox(height: Margins.spacing_huge),
        ],
      ),
    );
  }

  void _onIsActiveChange(bool isActive) {
    setState(() {
      _isActiveDate = isActive;
    });
    widget.onStartDateValueChange(_currentStartDate, isActive);
  }

  void _onDateChange(DateTime date) {
    setState(() {
      _currentStartDate = date;
    });
    widget.onStartDateValueChange(date, _isActiveDate);
  }
}

class _StartDateFilters extends StatelessWidget {
  final Function(bool) onIsActiveChange;
  final Function(DateTime) onDateChange;
  final DateTime? initialDateValue;
  final bool isActiveDate;

  _StartDateFilters({
    required this.onIsActiveChange,
    required this.onDateChange,
    required this.initialDateValue,
    required this.isActiveDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.startDateFiltreTitle, style: TextStyles.textBaseBold),
        DateToggle(
          onIsActiveChange: onIsActiveChange,
          isActiveDate: isActiveDate,
        ),
        SizedBox(height: Margins.spacing_s),
        DatePicker(
          onDateSelected: onDateChange,
          initialDateValue: initialDateValue,
          isActiveDate: isActiveDate,
        )
      ],
    );
  }
}

class _DomainFilters extends StatefulWidget {
  final Function(Domaine) onValueChange;
  final Domaine currentDomainValue;

  _DomainFilters({required this.onValueChange, required this.currentDomainValue});

  @override
  State<_DomainFilters> createState() => _DomainFiltersState();
}

class _DomainFiltersState extends State<_DomainFilters> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.domainFiltreTitle, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_s),
        _DomainList(
          onValueChange: (value) => widget.onValueChange(value),
          initialDomainValue: widget.currentDomainValue,
        ),
      ],
    );
  }
}

class _DomainList extends StatefulWidget {
  final Function(Domaine) onValueChange;
  final Domaine initialDomainValue;

  _DomainList({required this.onValueChange, required this.initialDomainValue});

  @override
  State<_DomainList> createState() => _DomainListState();
}

class _DomainListState extends State<_DomainList> {
  Domaine? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialDomainValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: Domaine.values
          .map((domain) => CustomRadioGroup<Domaine>(
              title: domain.titre,
              value: domain,
              groupValue: _currentValue,
              onChanged: (value) {
                widget.onValueChange(value!);
                setState(() => _currentValue = value);
              }))
          .toList(),
    );
  }
}
