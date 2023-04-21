import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_outils_item.dart';

class AccueilOutils extends StatelessWidget {
  final AccueilOutilsItem item;

  AccueilOutils(this.item);

  @override
  Widget build(BuildContext context) {
    return Text("Outils");
  }
}