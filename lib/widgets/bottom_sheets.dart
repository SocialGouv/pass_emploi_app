import 'package:flutter/material.dart';

Future<T?> showUserActionBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required RouteSettings routeSettings,
}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    isScrollControlled: true,
    builder: builder,
    routeSettings: routeSettings,
  );
}
