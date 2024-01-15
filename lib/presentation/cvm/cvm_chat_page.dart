import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/presentation/cvm_chat_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/cvm_repository.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class CvmChatPage extends StatelessWidget {
  const CvmChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CvmChatPageViewModel>(
      onInit: (store) {
        store.dispatch(CvmRequestAction());
      },
      converter: (store) => CvmChatPageViewModel.create(store),
      builder: (context, viewModel) => _Body(viewModel),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel);
  final CvmChatPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _MessageList(viewModel),
          ),
          _MessageInput(viewModel),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList(this.viewModel);
  final CvmChatPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: false,
      itemCount: viewModel.messages.length,
      itemBuilder: (context, index) {
        final message = viewModel.messages[index];
        return _MessageTile(message: message);
      },
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput(this.viewModel);
  final CvmChatPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Row(
        children: [
          Expanded(
            child: BaseTextField(
              controller: controller,
              hintText: "Ecrivez votre message",
            ),
          ),
          SizedBox(width: Margins.spacing_s),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(Dimens.radius_base),
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
            onPressed: () {
              viewModel.onSendMessage(controller.value.text);
              controller.clear();
            },
          )
        ],
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({required this.message});
  final CvmMessage message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(message.id),
      title: Text(message.content),
      subtitle: Text(message.date.toDayAndHour()),
      leading: CircleAvatar(
        backgroundColor: message.isFromUser ? Colors.blue : Colors.grey,
        child: Text(message.isFromUser ? "Moi" : "PE"),
      ),
    );
  }
}
