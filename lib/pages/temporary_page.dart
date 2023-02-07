import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class TemporaryPage extends StatefulWidget {
  @override
  State<TemporaryPage> createState() => _TemporaryPageState();
}

class _TemporaryPageState extends State<TemporaryPage> {
  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PrimaryAppBar(title: 'Autocompletion', backgroundColor: backgroundColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Autocompletion'),
        ],
      ),
    );
  }
}
