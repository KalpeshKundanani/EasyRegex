import 'package:easy_regex/pages/test_regex/test_regex_widget.dart';
import 'package:flutter/material.dart';

class RegexChangeNotifierProvider extends InheritedWidget {
  final ValueNotifier<String> regexValueNotifier;

  const RegexChangeNotifierProvider({
    this.regexValueNotifier,
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static RegexChangeNotifierProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RegexChangeNotifierProvider>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) =>
      regexValueNotifier ==
      (oldWidget as RegexChangeNotifierProvider).regexValueNotifier;
}
