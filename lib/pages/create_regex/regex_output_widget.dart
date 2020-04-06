import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:easy_regex/utils.dart';
import 'package:flutter/material.dart';

import 'match_on.dart';

class RegExOutputWidget extends StatelessWidget {
  final ValueNotifier<MatchOn> matchOnListenable;
  final Function(MatchOn) onMatchOnSelectionChange;

  RegExOutputWidget({
    Key key,
    @required MatchOn matchOn,
    @required this.onMatchOnSelectionChange,
  })  : matchOnListenable = ValueNotifier<MatchOn>(matchOn),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final regexValueNotifier = _regexValueNotifier(context);
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _copyRegexButton(context, regexValueNotifier),
              _shareRegexButton(regexValueNotifier),
            ],
          ),
          _regexOutputView(textTheme, regexValueNotifier),
          _matchOnSelectionWidget(textTheme, themeData),
        ],
      ),
    ));
  }

  Widget _matchOnSelectionWidget(TextTheme textTheme, ThemeData themeData) {
    return ValueListenableBuilder<MatchOn>(
      valueListenable: matchOnListenable,
      builder: (BuildContext context, MatchOn value, __) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Match on : ',
                style: textTheme.caption,
              ),
              Expanded(
                child: RadioListTile<MatchOn>(
                  activeColor: themeData.accentColor,
                  title: Text(
                    MatchOn.words.name,
                    style: textTheme.subtitle2,
                  ),
                  value: MatchOn.words,
                  groupValue: value,
                  onChanged: _onMatchOnSelected,
                ),
              ),
              Expanded(
                child: RadioListTile<MatchOn>(
                  activeColor: themeData.accentColor,
                  title: Text(
                    MatchOn.lines.name,
                    style: textTheme.subtitle2,
                  ),
                  value: MatchOn.lines,
                  groupValue: value,
                  onChanged: _onMatchOnSelected,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onMatchOnSelected(MatchOn value) {
    matchOnListenable.value = value;
    onMatchOnSelectionChange(value);
  }

  ValueNotifier<String> _regexValueNotifier(BuildContext context) =>
      RegexChangeNotifierProvider.of(context).regexValueNotifier;

  ValueListenableBuilder<String> _regexOutputView(
    final TextTheme textTheme,
    final ValueNotifier<String> regexValueNotifier,
  ) =>
      ValueListenableBuilder<String>(
        valueListenable: regexValueNotifier,
        builder: (BuildContext context, final String value, __) {
          return Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 25.0,
                maxHeight: MediaQuery.of(context).size.height * 0.15,
              ),
              child: value == null || value.isEmpty
                  ? Container(height: 0)
                  : FittedBox(child: Text(value, maxLines: 1)),
            ),
          );
        },
      );

  IconButton _shareRegexButton(ValueNotifier<String> regexValueNotifier) =>
      IconButton(
        icon: Icon(Icons.share),
        onPressed: () {
          shareText(regexValueNotifier.value);
        },
      );

  Widget _copyRegexButton(
      final BuildContext context, ValueNotifier<String> regexValueNotifier) {
    return Visibility(
      visible: false,
      child: IconButton(
        icon: Icon(Icons.content_copy),
        onPressed: () {
          copyToClipBoard(context, regexValueNotifier.value);
        },
      ),
    );
  }

  double getRegexOutputTextSize(String value) {
    if (value == null || value.isEmpty) return 12.0;
    final length = value.length;
    if (length < 30) return 34.0;
    if (length < 50) return 24.0;
    if (length < 70) return 20.0;
    if (length < 90) return 16.0;
    if (length < 120) return 14.0;
    return 12.0;
  }
}
