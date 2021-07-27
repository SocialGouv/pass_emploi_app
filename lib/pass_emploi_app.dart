import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/actions_page.dart';

class PassEmploiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pass Emploi',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: ActionsPage(),
    );
  }
}
