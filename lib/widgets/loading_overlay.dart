import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Opacity(opacity: 0.2, child: ModalBarrier(dismissible: false, color: Colors.black)),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
