import 'package:flutter/material.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_cards.dart';

class TestCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Test Appbar'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BaseCardS(),
          ],
        ),
      ),
    );
  }
}
