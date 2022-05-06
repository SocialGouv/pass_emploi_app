import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/service_civique/service_civique_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/buttons/filter_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/slider/distance_slider.dart';

class ServiceCiviqueFiltresPage extends TraceableStatefulWidget {
  ServiceCiviqueFiltresPage()
      : super(name: AnalyticsScreenNames.serviceCiviqueFiltres);

  static MaterialPageRoute<bool> materialPageRoute() {
    return MaterialPageRoute(builder: (_) => ServiceCiviqueFiltresPage());
  }

  @override
  State<ServiceCiviqueFiltresPage> createState() =>
      _ServiceCiviqueFiltresPageState();
}

class _ServiceCiviqueFiltresPageState extends State<ServiceCiviqueFiltresPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ServiceCiviqueFiltresViewModel>(
      converter: (store) => ServiceCiviqueFiltresViewModel.create(store),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      distinct: true,
    );
  }

  Widget _scaffold(
      BuildContext context, ServiceCiviqueFiltresViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(
          label: Strings.serviceCiviqueFiltresTitle,
          context: context,
          withBackButton: true),
      body: _content(context, viewModel),
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
  var _isFiltersUpdated = false;

  @override
  void initState() {
    super.initState();
    _currentStartDate = widget.viewModel.initialStartDateValue;
    _currentDomainValue = widget.viewModel.initialDomainValue;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _Filters(
          viewModel: widget.viewModel,
          onDistanceValueChange: (distance) =>
              _setDistanceFilterState(distance),
          onStartDateValueChange: (date, isActive) =>
              _setStartDateFilterState(date, isActive),
          onDomainValueChange: (domain) => _setDomainFilterState(domain),
        ),
        Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: FilterButton(
            isEnabled: _isButtonEnabled(widget.viewModel),
            onPressed: () => _onButtonClick(widget.viewModel),
          ),
        ),
      ],
    );
  }

  void _setDistanceFilterState(double value) {
    setState(() {
      _isFiltersUpdated = true;
      _currentSliderValue = value;
    });
  }

  void _setStartDateFilterState(DateTime? date, bool isActive) {
    setState(() {
      _isFiltersUpdated = true;
      _currentStartDate = date;
    });
  }

  void _setDomainFilterState(Domaine? domain) {
    setState(() {
      _isFiltersUpdated = true;
      _currentDomainValue = domain;
    });
  }

  bool _isButtonEnabled(ServiceCiviqueFiltresViewModel viewModel) =>
      _isFiltersUpdated && viewModel.displayState != DisplayState.LOADING;

  void _onButtonClick(ServiceCiviqueFiltresViewModel viewModel) {
    viewModel.updateFiltres(
      _sliderValueToDisplay(viewModel.initialDistanceValue),
      _currentDomainValue,
      _currentStartDate,
    );
    Navigator.pop(context, true);
  }

  int _sliderValueToDisplay(int viewModelInitialDistanceValue) =>
      _currentSliderValue != null
          ? _currentSliderValue!.toInt()
          : viewModelInitialDistanceValue;
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
    _currentStartDate = widget.viewModel.initialStartDateValue;
    _isActiveDate = widget.viewModel.initialStartDateValue != null;
    _currentDomainValue = widget.viewModel.initialDomainValue;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.viewModel.shouldDisplayDistanceFiltre) ...[
            SizedBox(height: Margins.spacing_l),
            DistanceSlider(
              initialDistanceValue:
                  widget.viewModel.initialDistanceValue.toDouble(),
              onValueChange: (value) => widget.onDistanceValueChange(value),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Margins.spacing_m, vertical: Margins.spacing_l),
            child: _StartDateFiltres(
              onValueChange: (date, isActive) =>
                  widget.onStartDateValueChange(date, isActive),
              initialDateValue: _currentStartDate,
              isActiveDate: _isActiveDate,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
            child: _DomainFilters(
              currentDomainValue: _currentDomainValue!,
              onValueChange: (value) => widget.onDomainValueChange(value),
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _StartDateFiltres extends StatefulWidget {
  final Function(DateTime?, bool) onValueChange;
  final DateTime? initialDateValue;
  final bool isActiveDate;

  _StartDateFiltres(
      {required this.onValueChange,
      required this.initialDateValue,
      required this.isActiveDate});

  @override
  State<_StartDateFiltres> createState() => _StartDateFiltresState();
}

class _StartDateFiltresState extends State<_StartDateFiltres> {
  bool _isActiveDate = false;
  DateTime? _currentStartDate;

  @override
  void initState() {
    super.initState();
    _isActiveDate = widget.isActiveDate;
    _currentStartDate = widget.initialDateValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.startDateFiltreTitle, style: TextStyles.textBaseBold),
        _DateToggle(
          onValueChange: (date, isActive) =>
              _onToggleDateValueChange(date, isActive),
          isActiveDate: _isActiveDate,
        ),
        _DatePicker(
          onValueChange: (value) => _onDateValueChange(value),
          initialDateValue: _currentStartDate,
          isActiveDate: _isActiveDate,
        )
      ],
    );
  }

  void _onDateValueChange(DateTime value) {
    setState(() {
      _isActiveDate = true;
      _currentStartDate = value;
    });
    widget.onValueChange(_currentStartDate, _isActiveDate);
  }

  void _onToggleDateValueChange(DateTime? value, bool isActive) {
    setState(() {
      _isActiveDate = isActive;
      _currentStartDate = value;
    });
    widget.onValueChange(_currentStartDate, _isActiveDate);
  }
}

class _DateToggle extends StatefulWidget {
  final Function(DateTime?, bool) onValueChange;
  final bool isActiveDate;

  _DateToggle({required this.onValueChange, required this.isActiveDate});

  @override
  State<_DateToggle> createState() => _DateToggleState();
}

class _DateToggleState extends State<_DateToggle> {
  bool _isActiveDate = false;

  @override
  void initState() {
    super.initState();
    _isActiveDate = widget.isActiveDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Strings.startDate, style: TextStyles.textSRegular()),
              _StartDateToggle(
                onValueChange: (date, isActive) =>
                    _onToggleDateValueChange(date, isActive),
                isActiveDate: _isActiveDate,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onToggleDateValueChange(DateTime? value, bool isActive) {
    setState(() {
      _isActiveDate = isActive;
    });
    widget.onValueChange(value, isActive);
  }
}

class _StartDateToggle extends StatefulWidget {
  final Function(DateTime?, bool) onValueChange;
  final bool isActiveDate;

  _StartDateToggle({required this.onValueChange, required this.isActiveDate});

  @override
  State<_StartDateToggle> createState() => _StartDateToggleState();
}

class _StartDateToggleState extends State<_StartDateToggle> {
  bool _isActiveDate = false;
  DateTime? _currentStartDate;

  @override
  void initState() {
    super.initState();
    _isActiveDate = widget.isActiveDate;
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: _isActiveDate,
      onChanged: (newValue) {
        setState(() {
          _isActiveDate = newValue;
          _currentStartDate = _isActiveDate ? DateTime.now() : null;
        });
        widget.onValueChange(_currentStartDate, _isActiveDate);
      },
    );
  }
}

class _DatePicker extends StatefulWidget {
  final Function(DateTime) onValueChange;
  final DateTime? initialDateValue;
  final bool isActiveDate;

  _DatePicker(
      {required this.onValueChange,
      required this.initialDateValue,
      required this.isActiveDate});

  @override
  State<_DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<_DatePicker> {
  DateTime? _currentStartDate;

  @override
  void initState() {
    super.initState();
    _currentStartDate = widget.initialDateValue;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.isActiveDate,
      decoration: InputDecoration(
          suffixIcon: SvgPicture.asset(Drawables.icCalendar,
              color: AppColors.grey800, fit: BoxFit.scaleDown),
          hintText: _currentStartDate != null ? _currentStartDate!.toDay() : "",
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.grey800, width: 1.0),
          )),
      keyboardType: TextInputType.none,
      textCapitalization: TextCapitalization.sentences,
      onTap: () => Platform.isIOS
          ? _iOSDatePicker(context)
          : _androidDatePicker(context),
      showCursor: false,
    );
  }

  Future<void> _iOSDatePicker(BuildContext context) async {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 190,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (value) {
                          widget.onValueChange(value);
                          setState(() {
                            _currentStartDate = value;
                          });
                        }),
                  ),
                ],
              ),
            ));
  }

  Future<void> _androidDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      initialDate: DateTime.now(),
      locale: const Locale("fr", "FR"),
    );
    if (picked != null && picked != _currentStartDate) {
      widget.onValueChange(picked);
      setState(() {
        _currentStartDate = picked;
      });
    }
  }
}

class _DomainFilters extends StatefulWidget {
  final Function(Domaine) onValueChange;
  final Domaine currentDomainValue;

  _DomainFilters(
      {required this.onValueChange, required this.currentDomainValue});

  @override
  State<_DomainFilters> createState() => _DomainFiltersState();
}

class _DomainFiltersState extends State<_DomainFilters> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child:
              Text(Strings.domainFiltreTitle, style: TextStyles.textBaseBold),
        ),
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
          .map((domain) => RadioListTile<Domaine>(
              controlAffinity: ListTileControlAffinity.trailing,
              selected: domain == _currentValue,
              title: Text(domain.titre),
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
