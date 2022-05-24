import 'package:flutter/material.dart';

class CampagneDetailsPage extends StatelessWidget {

  CampagneDetailsPage._() : super();

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CampagneDetailsPage._());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Text("hey"),
    );
  }
}
