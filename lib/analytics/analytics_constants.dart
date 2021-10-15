import 'package:flutter/cupertino.dart';

abstract class AnalyticsScreenNames {
  static const splash = "splash";
  static const forceUpdate = "force_update";
  static const login = "login";
  static const home = "home";
  static const rendezvous = "rendez_vous";
  static const userAction = "actions";
  static const chat = "chat";
}

abstract class AnalyticsRouteSettings {
  static RouteSettings splash() => RouteSettings(name: AnalyticsScreenNames.splash);

  static RouteSettings login() => RouteSettings(name: AnalyticsScreenNames.login);

  static RouteSettings home() => RouteSettings(name: AnalyticsScreenNames.home);

  static RouteSettings rendezvous() => RouteSettings(name: AnalyticsScreenNames.rendezvous);

  static RouteSettings userAction() => RouteSettings(name: AnalyticsScreenNames.userAction);

  static RouteSettings chat() => RouteSettings(name: AnalyticsScreenNames.chat);
}
