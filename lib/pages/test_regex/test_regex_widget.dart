import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum RegexTestChoice { createdRegex, newRegex }

class TestRegExWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> regexValueNotifier =
        _regexValueNotifier(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _regexInputWidget(context, regexValueNotifier),
          _regexTestTextWidget(context),
        ],
      ),
    );
  }

  Widget _regexTestTextWidget(BuildContext context) {
    final ValueNotifier<String> testTextNotifier = _testTextNotifier(context);
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: testTextNotifier,
              builder: (BuildContext context, String value, Widget child) {
                return SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(value),
                ));
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Transform.scale(
                scale: 0.75,
                child: FloatingActionButton.extended(
                  icon: Icon(Icons.content_paste),
                  onPressed: () {},
                  label: Text('Paste'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Card _regexInputWidget(
    final BuildContext context,
    final ValueNotifier<String> regexValueNotifier,
  ) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _regexSelectionWidget(context, regexValueNotifier),
              _regexUtils(context, regexValueNotifier),
            ],
          ),
        ),
      );

  Widget _regexSelectionWidget(
    final BuildContext context,
    final ValueNotifier<String> regexValueNotifier,
  ) {
    final Color activeColor = Theme.of(context).accentColor;
    var testRegexSelectionNotifier = _testRegexSelectionNotifier(context);
    return ValueListenableBuilder(
      valueListenable: testRegexSelectionNotifier,
      builder: (_, final RegexTestChoice groupValue, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: _testSelections(context, groupValue, regexValueNotifier)
              .map(
                (selection) => selection.toRadioListTile(
                  activeColor,
                  groupValue,
                  (value) => testRegexSelectionNotifier.value = value,
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }

  Widget _regexUtils(
      final BuildContext context, ValueNotifier<String> regexValueNotifier) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder(
        valueListenable: _testRegexSelectionNotifier(context),
        builder: (_, final RegexTestChoice groupValue, __) {
          final testRegexNotifier = _testRegexNotifier(context);
          return ValueListenableBuilder(
            valueListenable: testRegexNotifier,
            builder: (_, String newRegexValue, __) {
              final bool shallCopyOrShare =
                  groupValue == RegexTestChoice.newRegex &&
                      newRegexValue.isNotEmpty;
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      testRegexNotifier.value = 'paste';
                    },
                    icon: Icon(Icons.content_paste),
                  ),
                  IconButton(
                    onPressed: shallCopyOrShare
                        ? () {
                            testRegexNotifier.value = 'copy';
                          }
                        : null,
                    icon: Icon(Icons.content_copy),
                  ),
                  IconButton(
                    onPressed: shallCopyOrShare
                        ? () {
                            testRegexNotifier.value = 'share';
                          }
                        : null,
                    icon: Icon(Icons.share),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Text _createdRegexOutputWidget(final RegexTestChoice groupValue,
          final ValueNotifier<String> regexValueNotifier) =>
      Text(regexValueNotifier.value);

  Widget _newRegexInputWidget(
      final BuildContext context, final RegexTestChoice groupValue) {
    return ValueListenableBuilder(
      valueListenable: _testRegexNotifier(context),
      builder: (BuildContext context, String value, Widget child) =>
          TextFormField(key: ValueKey(value), initialValue: value),
    );
  }

  ValueNotifier<String> _testTextNotifier(BuildContext context) =>
      RegexChangeNotifierProvider.of(context).testTextNotifier;

  ValueNotifier<String> _regexValueNotifier(BuildContext context) =>
      RegexChangeNotifierProvider.of(context).regexValueNotifier;

  ValueNotifier<RegexTestChoice> _testRegexSelectionNotifier(
          BuildContext context) =>
      RegexChangeNotifierProvider.of(context).testRegexSelectionNotifier;

  ValueNotifier<String> _testRegexNotifier(BuildContext context) =>
      RegexChangeNotifierProvider.of(context).testRegexNotifier;

  List<_RegexTestSelection> _testSelections(
          final BuildContext context,
          final RegexTestChoice groupValue,
          final ValueNotifier<String> regexValueNotifier) =>
      <_RegexTestSelection>[
        _RegexTestSelection(
          _createdRegexOutputWidget(groupValue, regexValueNotifier),
          RegexTestChoice.createdRegex,
        ),
        _RegexTestSelection(
          _newRegexInputWidget(context, groupValue),
          RegexTestChoice.newRegex,
        ),
      ];
}

@immutable
class _RegexTestSelection {
  final Widget title;
  final RegexTestChoice value;

  const _RegexTestSelection(this.title, this.value);

  RadioListTile<RegexTestChoice> toRadioListTile(
    final Color activeColor,
    final RegexTestChoice groupValue,
    final ValueChanged<RegexTestChoice> onChanged,
  ) =>
      RadioListTile<RegexTestChoice>(
        value: value,
        title: title,
        groupValue: groupValue,
        activeColor: activeColor,
        onChanged: onChanged,
      );
}
