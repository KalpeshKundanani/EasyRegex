import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

void copyToClipBoard(BuildContext context, String textToBeCopied) {
  ClipboardManager.copyToClipBoard(textToBeCopied).then((result) {
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      content: Text('Copied to Clipboard'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  });
}

void shareText(String textToBeShared) => Share.share(textToBeShared);
