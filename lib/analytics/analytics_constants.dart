import 'package:flutter/material.dart';

abstract class AnalyticsScreenNames {
  static const splash = "splash";
  static const forceUpdate = "force_update";
  static const login = "login";
  static const main = "main";
  static const home = "home";
  static const rendezvous = "rendez_vous";
  static const userAction = "actions";
  static const userActionDetails = "action_details";
  static const createUserAction = "create_action";
  static const chat = "chat";
  static const offresEmploi = "resultats_offres";
}

abstract class AnalyticsRouteSettings {
  static RouteSettings splash() => RouteSettings(name: AnalyticsScreenNames.splash);

  static RouteSettings login() => RouteSettings(name: AnalyticsScreenNames.login);

  static RouteSettings main() => RouteSettings(name: AnalyticsScreenNames.main);

  static RouteSettings home() => RouteSettings(name: AnalyticsScreenNames.home);

  static RouteSettings rendezvous() => RouteSettings(name: AnalyticsScreenNames.rendezvous);

  static RouteSettings userAction() => RouteSettings(name: AnalyticsScreenNames.userAction);

  static RouteSettings userActionDetails() => RouteSettings(name: AnalyticsScreenNames.userActionDetails);

  static RouteSettings createUserAction() => RouteSettings(name: AnalyticsScreenNames.createUserAction);

  static RouteSettings chat() => RouteSettings(name: AnalyticsScreenNames.chat);

  static RouteSettings offreEmploiList() => RouteSettings(name: AnalyticsScreenNames.offresEmploi);
}
