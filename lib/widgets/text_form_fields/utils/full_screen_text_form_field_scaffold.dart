import 'package:flutter/material.dart';

class FullScreenTextFormFieldScaffold extends Scaffold {
  FullScreenTextFormFieldScaffold({required Widget body})
      : super(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          // Required to delegate top padding to system
          appBar: AppBar(toolbarHeight: 0, scrolledUnderElevation: 0),
          body: body,
        );
}
