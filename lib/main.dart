import 'package:easy_regex/app.dart';
import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      RegexChangeNotifierProvider(
        child: EasyRegExApp(),
        regexValueNotifier: ValueNotifier<String>('(?i)<td[^>]*>'),
      ),
    );
