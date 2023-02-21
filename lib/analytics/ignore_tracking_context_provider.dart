import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/theme.dart';

/// An additional `MaterialApp`, around main `PassEmploiApp`.
/// Can be used to offre another context, specially not track specific navigation routes.
/// To do so, pass `IgnoreTrackingContext.of(context).nonTrackingContext` to `Navigator`'s
/// methods.
class IgnoreTrackingContextProvider extends StatelessWidget {
  final Widget child;

  const IgnoreTrackingContextProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (materialAppContext) {
        return IgnoreTrackingContext(
          nonTrackingContext: materialAppContext,
          child: child,
        );
      }),
      theme: PassEmploiTheme.data,
    );
  }
}

class IgnoreTrackingContext extends InheritedWidget {
  static IgnoreTrackingContext of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<IgnoreTrackingContext>()!;
  }

  final BuildContext nonTrackingContext;

  const IgnoreTrackingContext({
    required this.nonTrackingContext,
    required super.child,
  });

  @override
  bool updateShouldNotify(IgnoreTrackingContext oldWidget) => false;
}
