import 'package:flutter/material.dart';

class ActionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            color: Color.fromARGB(255, 237, 238, 255),
          ),
          Container(
            height: 700,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
