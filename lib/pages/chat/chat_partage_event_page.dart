import 'package:flutter/material.dart';

// TODO: viewModel
class ChatPartageEventPage extends StatelessWidget {
  const ChatPartageEventPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => const ChatPartageEventPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
