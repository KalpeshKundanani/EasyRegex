import 'package:easy_regex/app.dart';
import 'package:easy_regex/pages/create_regex/regex_change_notification.dart';
import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:flutter/material.dart';

import 'pages/test_regex/test_text.dart';

void main() {
  final valueNotifier = ValueNotifier<String>(defaultRegexForCreateRegex);
  runApp(
    RegexChangeNotifierProvider(
      child: NotificationListener<RegexChangeNotification>(
        onNotification: (notification) {
          valueNotifier.value = notification.regexValue;
          return true;
        },
        child: EasyRegExApp(),
      ),
      regexValueNotifier: valueNotifier,
    ),
  );
}
