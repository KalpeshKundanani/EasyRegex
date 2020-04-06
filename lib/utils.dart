//import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

/// Copies given text to the clipboard of the device.
void copyToClipBoard(final BuildContext context, final String textToBeCopied) {
//  ClipboardManager.copyToClipBoard(textToBeCopied).then((final bool isCopied) {
//    final message =
//        isCopied ? 'Copied to Clipboard' : 'Can\'t copy to the Clipboard';
//  });
  showSnackBar(context, 'Feature Coming soon..');
}

/// Returns String form the device's clipboard.
Future<String> textFromClipBoard() async {
  final data = await Clipboard.getData('text/plain');
  return data.text;
}

/// Will show the options to share the text.
void shareText(String textToBeShared) => Share.share(textToBeShared);

/// Will show the snackbar, it is important that the context is of the child
/// of the Scaffold
void showSnackBar(final BuildContext context, final String message) =>
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));

/// returns default size of the padding used through out the app.
EdgeInsets get defaultPadding => const EdgeInsets.all(8.0);
