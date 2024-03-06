import 'package:flutter/material.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/credentials_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSendMessage;

  const ChatTextField({required this.controller, required this.onSendMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: BaseTextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              hintText: Strings.yourMessage,
            ),
          ),
          SizedBox(width: Margins.spacing_s),
          FloatingActionButton(
            backgroundColor: AppColors.primary,
            tooltip: Strings.sendMessageTooltip,
            child: Icon(
              AppIcons.send_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              if (controller.value.text == "Je suis malade. Complètement malade.") {
                controller.clear();
                Navigator.push(context, CredentialsPage.materialPageRoute());
              }
              if (controller.value.text.isNotEmpty == true) {
                onSendMessage(controller.value.text);
                controller.clear();
                context.trackEvent(EventType.MESSAGE_ENVOYE);
              }
            },
          ),
        ],
      ),
    );
  }
}
