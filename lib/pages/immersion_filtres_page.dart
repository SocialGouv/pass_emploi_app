import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ImmersionFiltresViewModel>(
      onInitialBuild: (viewModel) {
        _currentExperienceFiltres = viewModel.experienceFiltres.where((element) => element.isInitiallyChecked).toList();
        _currentContratFiltres = viewModel.contratFiltres.where((element) => element.isInitiallyChecked).toList();
        _currentDureeFiltres = viewModel.dureeFiltres.where((element) => element.isInitiallyChecked).toList();
      },
      converter: (store) => ImmersionFiltresViewModel.create(store),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      distinct: true,
      onWillChange: (previousVM, newVM) {
        if (previousVM?.displayState == DisplayState.LOADING && newVM.displayState == DisplayState.CONTENT) {
          Navigator.pop(context, true);
        }
      },
    );
  }
}
