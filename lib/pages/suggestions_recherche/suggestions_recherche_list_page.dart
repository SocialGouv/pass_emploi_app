import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class SuggestionsRechercheListPage extends StatelessWidget {

  SuggestionsRechercheListPage._() : super();

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return SuggestionsRechercheListPage._();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.suggestionsDeRechercheTitlePage, context: context, withBackButton: true),
      body: Text("coucou"),
    );
  }
}

