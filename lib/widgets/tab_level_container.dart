import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/widgets/connectivity_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class TabLevelContainer extends StatelessWidget {
  final Widget body;
  final String title;

  const TabLevelContainer({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(title: title),
      body: SafeArea(child: ConnectivityContainer(child: body)),
    );
  }
}
