import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/file_picker_wrapper.dart';
import 'package:pass_emploi_app/utils/image_picker_wrapper.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';
import 'package:pass_emploi_app/widgets/alert_message.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';

sealed class ChatPieceJointeBottomSheetResult {
  final String path;

  ChatPieceJointeBottomSheetResult({required this.path});
}

class ChatPieceJointeBottomSheetImageResult extends ChatPieceJointeBottomSheetResult {
  ChatPieceJointeBottomSheetImageResult(String path) : super(path: path);
}

class ChatPieceJointeBottomSheetFileResult extends ChatPieceJointeBottomSheetResult {
  ChatPieceJointeBottomSheetFileResult(String path) : super(path: path);
}

class ChatPieceJointeBottomSheet extends StatefulWidget {
  const ChatPieceJointeBottomSheet({super.key});

  static Future<ChatPieceJointeBottomSheetResult?> show(BuildContext context) async {
    return await showModalBottomSheet<ChatPieceJointeBottomSheetResult>(
      context: context,
      isScrollControlled: true,
      barrierLabel: Strings.bottomSheetBarrierLabel,
      builder: (context) => ChatPieceJointeBottomSheet(),
    );
  }

  @override
  State<ChatPieceJointeBottomSheet> createState() => _ChatPieceJointeBottomSheetState();
}

enum PermissionErrorType { none, gallery, camera, file }

class _ChatPieceJointeBottomSheetState extends State<ChatPieceJointeBottomSheet> {
  bool showFileTooLargeMessage = false;
  bool showLoading = false;
  PermissionErrorType permissionErrorType = PermissionErrorType.none;

  void _isFileTooLarge(bool isFileTooLarge) {
    setState(() {
      showLoading = false;
      showFileTooLargeMessage = isFileTooLarge;
    });
  }

  void _pickFileSarted() {
    setState(() {
      showLoading = true;
      showFileTooLargeMessage = false;
    });
  }

  void _pickFileEnded() => setState(() => showLoading = false);

  void _onPermissionError(PermissionErrorType type) => setState(() => permissionErrorType = type);

  void _resetErrorMessages() {
    setState(() {
      showFileTooLargeMessage = false;
      permissionErrorType = PermissionErrorType.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      title: Strings.chatPieceJointeBottomSheetTitle,
      maxHeightFactor: 0.7,
      body: SingleChildScrollView(
        child: Column(
          children: [
            switch (permissionErrorType) {
              PermissionErrorType.none => SizedBox.shrink(),
              PermissionErrorType.camera => _CameraPermissionWarning(),
              PermissionErrorType.file => _FilePermissionWarning(),
              PermissionErrorType.gallery => _GalleryPermissionWarning(),
            },
            if (showFileTooLargeMessage) ...[
              SizedBox(height: Margins.spacing_m),
              _FileTooLargeWarning(),
            ],
            if (showLoading) ...[
              SizedBox(height: Margins.spacing_m),
              _Loading(),
            ],
            SizedBox(height: Margins.spacing_m),
            _PieceJointeWarning(),
            SizedBox(height: Margins.spacing_base),
            _TakePictureButton(
              onPressed: () => _resetErrorMessages(),
              onPickImagePermissionError: () => _onPermissionError(PermissionErrorType.camera),
            ),
            _SelectFileButton(
              onPressed: () => _resetErrorMessages(),
              isFileTooLarge: _isFileTooLarge,
              onPermissionError: () => _onPermissionError(PermissionErrorType.file),
              pickFileSarted: _pickFileSarted,
              pickFileEnded: _pickFileEnded,
            ),
            _SelectPictureButton(
              onPressed: () => _resetErrorMessages(),
              onPickImagePermissionError: () => _onPermissionError(PermissionErrorType.gallery),
            ),
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 40,
      child: CircularProgressIndicator(),
    );
  }
}

class _PieceJointeWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(Strings.chatPieceJointeBottomSheetSubtitle, style: TextStyles.textSRegular());
  }
}

class _SelectPictureButton extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onPickImagePermissionError;

  const _SelectPictureButton({required this.onPressed, required this.onPickImagePermissionError});
  @override
  Widget build(BuildContext context) {
    return _PieceJointeListTile(
      icon: AppIcons.image_outlined,
      text: Strings.chatPieceJointeBottomSheetSelectImageButton,
      onPressed: () async {
        onPressed();
        final result = await ImagePickerWrapper.pickSingleImage();
        if (context.mounted && result is ImagePickerSuccessResult) {
          Navigator.of(context).pop(ChatPieceJointeBottomSheetImageResult(result.path));
        } else if (result is ImagePickerPermissionErrorResult) {
          onPickImagePermissionError();
        }
      },
    );
  }
}

class _TakePictureButton extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onPickImagePermissionError;

  const _TakePictureButton({required this.onPressed, required this.onPickImagePermissionError});
  @override
  Widget build(BuildContext context) {
    return _PieceJointeListTile(
      icon: AppIcons.camera_alt_outlined,
      text: Strings.chatPieceJointeBottomSheetTakeImageButton,
      onPressed: () async {
        onPressed();
        final result = await ImagePickerWrapper.takeSinglePicture();
        if (context.mounted && result is ImagePickerSuccessResult) {
          Navigator.of(context).pop(ChatPieceJointeBottomSheetImageResult(result.path));
        } else if (result is ImagePickerPermissionErrorResult) {
          onPickImagePermissionError();
        }
      },
    );
  }
}

class _SelectFileButton extends StatelessWidget {
  final void Function(bool isFileTooLarge) isFileTooLarge;
  final VoidCallback onPressed;
  final VoidCallback onPermissionError;
  final VoidCallback pickFileSarted;
  final VoidCallback pickFileEnded;
  const _SelectFileButton({
    required this.onPressed,
    required this.isFileTooLarge,
    required this.onPermissionError,
    required this.pickFileSarted,
    required this.pickFileEnded,
  });

  @override
  Widget build(BuildContext context) {
    return _PieceJointeListTile(
      icon: AppIcons.description_outlined,
      text: Strings.chatPieceJointeBottomSheetSelectFileButton,
      onPressed: () async {
        onPressed();
        pickFileSarted();
        final result = await FilePickerWrapper.pickFile();
        if (result is FilePickerSuccessResult && context.mounted) {
          _onFilePicked(context, result);
        } else if (result is FilePickerPermissionErrorResult) {
          onPermissionError();
        }
        pickFileEnded();
      },
    );
  }

  void _onFilePicked(BuildContext context, FilePickerSuccessResult result) {
    final isTooLarge = result.isTooLarge;
    isFileTooLarge(isTooLarge);
    if (context.mounted && !isTooLarge) {
      Navigator.of(context).pop(ChatPieceJointeBottomSheetFileResult(result.path));
    }
  }
}

class _FileTooLargeWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertMessage(
      message: Strings.chatPieceJointeBottomSheetFileTooLarge,
    );
  }
}

class _GalleryPermissionWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PermissionDeniedWarning(Strings.chatPieceJointeGalleryPermissionError);
  }
}

class _CameraPermissionWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PermissionDeniedWarning(Strings.chatPieceJointeCameraPermissionError);
  }
}

class _FilePermissionWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PermissionDeniedWarning(Strings.chatPieceJointeFilePermissionError);
  }
}

class _PermissionDeniedWarning extends StatelessWidget {
  final String message;

  const _PermissionDeniedWarning(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_m),
      child: Semantics(
        focusable: true,
        child: AutoFocusA11y(
          child: AlertMessage(
            message: message,
            retryMessage: AlertMessageRetry(
              message: Strings.chatPieceJointeOpenAppSettings,
              onRetry: () => AppSettings.openAppSettings(),
              link: true,
            ),
          ),
        ),
      ),
    );
  }
}

class _PieceJointeListTile extends StatelessWidget {
  const _PieceJointeListTile({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: ListTile(
        leading: Icon(icon),
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity(vertical: -2),
        title: Text(text, style: TextStyles.textBaseBold),
        onTap: onPressed,
      ),
    );
  }
}
