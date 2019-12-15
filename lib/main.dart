import 'package:easy_regex/app.dart';
import 'package:easy_regex/pages/test_regex/test_regex_widget.dart';
import 'package:easy_regex/pages/test_regex/test_text.dart'
    as test_text_provider;
import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      RegexChangeNotifierProvider(
        child: EasyRegExApp(),
        regexValueNotifier: ValueNotifier<String>('(?i)<td[^>]*>'),
        testRegexNotifier: ValueNotifier<String>(''),
        testTextNotifier:
            ValueNotifier<String>(test_text_provider.dummyTestText),
        testRegexSelectionNotifier:
            ValueNotifier<RegexTestChoice>(RegexTestChoice.newRegex),
      ),
    );
