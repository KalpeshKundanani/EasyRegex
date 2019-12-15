import 'package:easy_regex/pages/test_regex/test_regex_widget.dart';
import 'package:flutter/material.dart';

class RegexChangeNotifierProvider extends InheritedWidget {
  final ValueNotifier<String> regexValueNotifier;
  final ValueNotifier<String> testRegexNotifier;
  final ValueNotifier<String> testTextNotifier;
  final ValueNotifier<RegexTestChoice> testRegexSelectionNotifier;

  const RegexChangeNotifierProvider({
    this.regexValueNotifier,
    this.testRegexNotifier,
    this.testRegexSelectionNotifier,
    this.testTextNotifier,
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
