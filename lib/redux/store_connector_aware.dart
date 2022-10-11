import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pass_emploi_app.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

class StoreConnectorAware<ViewModel> extends StatefulWidget {

  final ViewModelBuilder<ViewModel> builder;
  final StoreConverter<AppState, ViewModel> converter;
  final bool distinct;
  final OnInitCallback<AppState>? onInit;
  final OnDisposeCallback<AppState>? onDispose;
  final bool rebuildOnChange;
  final IgnoreChangeTest<AppState>? ignoreChange;
  final OnWillChangeCallback<ViewModel>? onWillChange;
  final OnDidChangeCallback<ViewModel>? onDidChange;
  final OnInitialBuildCallback<ViewModel>? onInitialBuild;

  const StoreConnectorAware({
    Key? key,
    required this.builder,
    required this.converter,
    this.distinct = false,
    this.onInit,
    this.onDispose,
    this.rebuildOnChange = true,
    this.ignoreChange,
    this.onWillChange,
    this.onDidChange,
    this.onInitialBuild,
  }) : super(key: key);

  @override
  State<StoreConnectorAware<ViewModel>> createState() => _StoreConnectorAwareState<ViewModel>();
}

class _StoreConnectorAwareState<ViewModel> extends State<StoreConnectorAware<ViewModel>> with RouteAware {
  var _pageIsVisible = true;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      key: widget.key,
      builder: widget.builder,
      converter: widget.converter,
      distinct: widget.distinct,
      onInit: widget.onInit,
      onDispose: widget.onDispose,
      rebuildOnChange: widget.rebuildOnChange,
      ignoreChange: widget.ignoreChange,
      onWillChange: (oldVm, newVm) {
        if (_pageIsVisible == false) return;
        if (widget.onWillChange == null) return;
        widget.onWillChange!(oldVm, newVm);
      },
      onDidChange: (oldVm, newVm) {
        if (_pageIsVisible == false) return;
        if (widget.onDidChange == null) return;
        widget.onDidChange!(oldVm, newVm);
      },
      onInitialBuild: widget.onInitialBuild,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      PassEmploiApp.routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void didPopNext() {
    _pageIsVisible = true;
  }

  @override
  void didPushNext() {
    _pageIsVisible = false;
  }

  @override
  void dispose() {
    PassEmploiApp.routeObserver.unsubscribe(this);
    super.dispose();
  }
}
