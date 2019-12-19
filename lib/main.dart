import 'package:easy_regex/app.dart';
import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:flutter/material.dart';

import 'pages/test_regex/test_text.dart';

void main() => runApp(
      RegexChangeNotifierProvider(
        child: EasyRegExApp(),
        regexValueNotifier: ValueNotifier<String>(defaultRegexForTest),
      ),
    );
