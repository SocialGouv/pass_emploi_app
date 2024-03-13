import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';

class ChatListView extends StatelessWidget {
  final ScrollController controller;
  final List<dynamic> reversedItems;
  final NullableIndexedWidgetBuilder itemBuilder;

  const ChatListView({
    required this.controller,
    required this.reversedItems,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.only(
        left: Margins.spacing_base,
        right: Margins.spacing_base,
        top: Margins.spacing_base,
        bottom: 100,
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: controller,
      itemCount: reversedItems.length,
      itemBuilder: itemBuilder,
    );
  }
}
