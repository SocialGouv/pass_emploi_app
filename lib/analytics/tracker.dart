import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/pass_emploi_app.dart';

class Tracker extends StatefulWidget {
  final String tracking;
  final Widget child;

  const Tracker({Key? key, required this.tracking, required this.child}) : super(key: key);

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    _track();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PassEmploiApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    PassEmploiApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _track();
  }

  void _track() {
    MatomoTracker.trackScreenWithName(widget.tracking, 'WidgetCreated');
  }
}
