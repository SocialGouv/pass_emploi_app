import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/presentation/attached_file_view_model.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:share_plus/share_plus.dart';

class ChatAttachedFileWidget extends StatelessWidget {
  final AttachedFileConseillerMessageItem item;

  const ChatAttachedFileWidget(this.item) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MessageBubble(
            children: [
              Text(item.message, style: TextStyles.textSRegular()),
              SizedBox(height: 14),
              _PieceJointeName(item.filename),
              SizedBox(height: 20),
              _DownloadButton(fileId: item.id),
            ],
          ),
          _Caption(item.caption),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final List<Widget> children;

  const _MessageBubble({required this.children}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 0,
        right: 77.0,
      ),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _PieceJointeName extends StatelessWidget {
  final String filename;

  const _PieceJointeName(this.filename) : super();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(padding: const EdgeInsets.only(right: 10), child: SvgPicture.asset(Drawables.icClip)),
        Flexible(
          child: Text(
            filename,
            style: TextStyles.textSBoldWithColor(Colors.black),
          ),
        ),
      ],
    );
  }
}

class _Caption extends StatelessWidget {
  final String text;

  const _Caption(this.text) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Margins.spacing_xs),
        Text(text, style: TextStyles.textXsRegular()),
      ],
    );
  }
}

class _DownloadButton extends StatefulWidget {
  final String fileId;

  const _DownloadButton({required this.fileId}) : super();

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AttachedFileViewModel>(
      converter: (store) => AttachedFileViewModel.create(store),
      builder: (context, viewModel) => _body(context, viewModel),
      distinct: true,
    );
  }

  Widget _body(BuildContext context, AttachedFileViewModel viewModel) {
    switch (viewModel.displayState(widget.fileId)) {
      // todo 679 error handler
      case DisplayState.LOADING:
        return _loader();
      default:
        return _downloadButton(viewModel);
    }
  }

  Widget _downloadButton(AttachedFileViewModel viewModel) {
    return Center(
      child: PrimaryActionButton(
        label: Strings.open,
        drawableRes: Drawables.icDownload,
        onPressed: () => _share(viewModel),
        heightPadding: 2,
      ),
    );
  }

// todo : PoC to remove
  void _share(AttachedFileViewModel viewModel) async {
    viewModel.onClick(widget.fileId);
    // final hardcodedUrl = "https://www.messagerbenin.info/wp-content/uploads/2021/06/14481-google-logo-3-s-.jpg";
    // final cache = PassEmploiCacheManager(Config("aaa"));
    // final fileInfo = await cache.downloadFile(hardcodedUrl);
    // final path = fileInfo.file.path;
    // print('downloaded file path = $path');
    final String? path = viewModel.getPath(widget.fileId);
    if (path != null && path.isNotEmpty) {
      Share.shareFiles(['$viewModel.getPath'], text: 'Cute one');
    }
  }

  Widget _loader() => Center(child: CircularProgressIndicator(color: AppColors.nightBlue));

}
