import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/models/cvm/cvm_event.dart';
import 'package:pass_emploi_app/presentation/cvm_chat_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';

class CvmChatPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => CvmChatPage());

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CvmChatPageViewModel>(
      onInit: (store) => store.dispatch(CvmRequestAction()),
      converter: (store) => CvmChatPageViewModel.create(store),
      builder: (context, viewModel) => _Scaffold(_Body(viewModel)),
      distinct: true,
    );
  }
}

class _Scaffold extends StatelessWidget {
  final Widget body;

  const _Scaffold(this.body);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: "Chat CVM"),
      floatingActionButton: FloatingActionButton(
        onPressed: () => StoreProvider.of<AppState>(context).dispatch(CvmRequestAction()),
        child: Icon(Icons.refresh),
      ),
      body: body,
    );
  }
}

class _Body extends StatelessWidget {
  final CvmChatPageViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.displayState) {
      DisplayState.LOADING => Center(child: CircularProgressIndicator()),
      DisplayState.FAILURE => Center(child: Text("😬KO, régale-toi", style: TextStyles.textBaseMedium)),
      DisplayState.EMPTY => Center(child: Text("🐐Aucun message", style: TextStyles.textBaseMedium)),
      DisplayState.CONTENT => _Content(viewModel),
    };
  }
}

class _Content extends StatelessWidget {
  final CvmChatPageViewModel viewModel;

  const _Content(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _MessageList(viewModel)),
        _MessageInput(viewModel),
      ],
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
        return switch (viewModel.messages[index]) {
          final CvmMessageEvent event => _MessageTile(event),
          final CvmFileEvent event => _FileTile(event),
          final CvmUnknownEvent event => _UnknownTile(event),
        };
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
  final CvmMessageEvent event;

  const _MessageTile(this.event);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(event.id),
      title: SelectableTextWithClickableLinks(event.content, style: TextStyles.textSRegular()),
      subtitle: Text(event.date.toDayAndHour()),
      leading: CircleAvatar(
        backgroundColor: event.isFromUser ? Colors.blue : Colors.grey,
        child: Text(event.isFromUser ? "Moi" : "PE"),
      ),
    );
  }
}

class _FileTile extends StatelessWidget {
  final CvmFileEvent event;

  const _FileTile(this.event);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(event.id),
      title: Column(
        children: [
          Text('Pièce jointe'),
          SizedBox(height: Margins.spacing_xs),
          SelectableTextWithClickableLinks(event.content, style: TextStyles.textSRegular()),
          SizedBox(height: Margins.spacing_xs),
          SelectableTextWithClickableLinks(event.url, style: TextStyles.textSRegular()),
        ],
      ),
      subtitle: Text(event.date.toDayAndHour()),
      leading: CircleAvatar(
        backgroundColor: event.isFromUser ? Colors.blue : Colors.grey,
        child: Text(event.isFromUser ? "Moi" : "PE"),
      ),
    );
  }
}

class _UnknownTile extends StatelessWidget {
  final CvmUnknownEvent event;

  const _UnknownTile(this.event);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(event.id),
      title: Text('⚠️Format de message inconnu'),
      subtitle: Text(event.date.toDayAndHour()),
    );
  }
}
