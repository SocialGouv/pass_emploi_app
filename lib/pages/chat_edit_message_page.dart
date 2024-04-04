import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class ChatEditMessagePage extends StatelessWidget {
  const ChatEditMessagePage(this.content);

  final String content;

  static Route<String?> route(String content) {
    return MaterialPageRoute(builder: (context) => ChatEditMessagePage(content));
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: content);
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacing_base,
        ),
        child: SizedBox(
          width: double.infinity,
          child: PrimaryActionButton(
            label: Strings.editMessageSave,
            onPressed: () => Navigator.of(context).pop(controller.text),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.white,
      appBar: SecondaryAppBar(title: Strings.chatEditMessageAppBar),
      body: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BaseTextField(
                autofocus: true,
                minLines: 5,
                controller: controller,
              ),
              SizedBox(height: Margins.spacing_huge),
            ],
          ),
        ),
      ),
    );
  }
}
