import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:flutter/material.dart';

class RegExOutputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> regexValueNotifier =
        _regexValueNotifier(context);
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _regexOutputView(regexValueNotifier),
          _copyRegexButton(regexValueNotifier),
          _shareRegexButton(regexValueNotifier),
        ],
      ),
    ));
  }

  ValueNotifier<String> _regexValueNotifier(BuildContext context) =>
      RegexChangeNotifierProvider.of(context).regexValueNotifier;

  ValueListenableBuilder<String> _regexOutputView(
          ValueNotifier<String> regexValueNotifier) =>
      ValueListenableBuilder<String>(
        valueListenable: regexValueNotifier,
        builder: _regexTextBuilder,
      );

  final ValueWidgetBuilder<String> _regexTextBuilder =
      (BuildContext context, String value, Widget child) => Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(value),
            ),
          );

  IconButton _shareRegexButton(ValueNotifier<String> regexValueNotifier) =>
      IconButton(
        icon: Icon(Icons.share),
        onPressed: () {
          regexValueNotifier.value = 'Share';
        },
      );

  IconButton _copyRegexButton(ValueNotifier<String> regexValueNotifier) =>
      IconButton(
        icon: Icon(Icons.content_copy),
        onPressed: () {
          regexValueNotifier.value = 'Copy';
        },
      );
}
