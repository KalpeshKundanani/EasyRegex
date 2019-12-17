import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:easy_regex/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'test_text.dart';

enum RegexTestChoice { createdRegex, newRegex }

class TestRegExWidget extends StatelessWidget {
  static final ValueNotifier<String> _testRegexNotifier = ValueNotifier<String>(defaultRegexForTest);
  static final TextEditingController _controller = TextEditingController(text: defaultRegexForTest);
  static final ValueNotifier<String> _testTextNotifier = ValueNotifier<String>(dummyTestText);
  static final ValueNotifier<RegexTestChoice> _testRegexSelectionNotifier = ValueNotifier<RegexTestChoice>(RegexTestChoice.newRegex);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> regexValueNotifier =
        _regexValueNotifier(context);
    return Padding(
      padding: defaultPadding,
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: _testRegexNotifier,
              builder: (BuildContext context, String value, Widget child) {
                return FutureBuilder<List<TextSpan>>(
                  future: _highlightAccordingToRegex(context, value),
                  builder: (BuildContext context, AsyncSnapshot<List<TextSpan>> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text(
                        'Error parsing regex',
                        style: TextStyle(color: Colors.redAccent),
                      );
                    }
                    if (snapshot.hasData) {
                      return ValueListenableBuilder<String>(
                        valueListenable: _testTextNotifier,
                        builder:
                            (BuildContext context, String value, Widget child) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: defaultPadding,
                              child: RichText(
                                text: TextSpan(children: snapshot.data),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
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
                  onPressed: () async {
                    _testTextNotifier.value = await pasteFromClipBoard();
                    showSnackBar(context, 'Updated test text.');
                  },
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
          padding: defaultPadding,
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
    return ValueListenableBuilder(
      valueListenable: _testRegexSelectionNotifier,
      builder: (_, final RegexTestChoice groupValue, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: _testSelections(context, groupValue, regexValueNotifier)
              .map(
                (selection) => selection.toRadioListTile(
                  activeColor,
                  groupValue,
                  (value) {
                    if (value == RegexTestChoice.newRegex) {
                      _testRegexNotifier.value = _controller.text;
                    } else {
                      _testRegexNotifier.value =
                          _regexValueNotifier(context).value;
                    }
                    _testRegexSelectionNotifier.value = value;
                  },
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }

  Widget _regexUtils(
      final BuildContext context, ValueNotifier<String> regexValueNotifier) {
    return ValueListenableBuilder(
      valueListenable: _testRegexSelectionNotifier,
      builder: (_, final RegexTestChoice groupValue, __) {
        return ValueListenableBuilder(
          valueListenable: _testRegexNotifier,
          builder: (_, String newRegexValue, __) {
            final bool shallCopyOrShare =
                groupValue == RegexTestChoice.newRegex &&
                    _controller.text.isNotEmpty;
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    _controller.text = await pasteFromClipBoard();
                  },
                  icon: Icon(Icons.content_paste),
                ),
                IconButton(
                  onPressed: shallCopyOrShare
                      ? () {
                          copyToClipBoard(context, _controller.text);
                        }
                      : null,
                  icon: Icon(Icons.content_copy),
                ),
                IconButton(
                  onPressed: shallCopyOrShare
                      ? () {
                          shareText(_controller.text);
                        }
                      : null,
                  icon: Icon(Icons.share),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Text _createdRegexOutputWidget(final RegexTestChoice groupValue,
          final ValueNotifier<String> regexValueNotifier) =>
      Text(regexValueNotifier.value);

  static FocusNode myFocusNode = FocusNode();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  Widget _newRegexInputWidget(
      final BuildContext context, final RegexTestChoice groupValue) {
    return ValueListenableBuilder<RegexTestChoice>(
      valueListenable: _testRegexSelectionNotifier,
      builder: (BuildContext context, RegexTestChoice selection, Widget child) {
        if (selection == RegexTestChoice.newRegex)
          FocusScope.of(context).requestFocus(myFocusNode);
        return Form(
          key: _formStateKey,
          child: TextFormField(
            controller: _controller,
            focusNode: myFocusNode,
            enabled: selection == RegexTestChoice.newRegex,
            onSaved: (String value) {
              _testRegexNotifier.value = value;
            },
            onChanged: (String value) {
              if (_formStateKey.currentState.validate()) {
                _formStateKey.currentState.save();
              }
            },
            validator: _regexValidator,
            decoration: InputDecoration(
                suffix: InkWell(
              child: Icon(Icons.clear),
              onTap: () {
                _controller.clear();
                _testRegexNotifier.value = '';
              },
            )),
          ),
        );
      },
    );
  }

  ValueNotifier<String> _regexValueNotifier(BuildContext context) =>
      RegexChangeNotifierProvider.of(context).regexValueNotifier;

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

  Future<List<TextSpan>> _highlightAccordingToRegex(
    BuildContext context,
    String value,
  ) async {
    String data = _testTextNotifier.value;
    RegExp exp = new RegExp(value);
    print(exp.hasMatch(data));
    Iterable<RegExpMatch> matches = exp.allMatches(data);
    List<String> toBeHighlightedWords = <String>[];
    for (int i = 0; i < matches.length; i++) {
      String word = matches.elementAt(i).group(0);
      toBeHighlightedWords.add(word);
    }
    return _getHighlightedWords(context, data, toBeHighlightedWords);
  }

  List<TextSpan> _getHighlightedWords(
      BuildContext context, String text, List<String> toBeHighlighted) {
    List<TextSpan> _textSpans = <TextSpan>[];
    final TextStyle nonHighlight = Theme.of(context).textTheme.body2;
    final TextStyle highlight = TextStyle(
        color: Theme.of(context).accentColor,
        fontSize: Theme.of(context).textTheme.body2.fontSize,
        backgroundColor: Theme.of(context).accentColor.withAlpha(50));
    int index = 0;
    toBeHighlighted.forEach((String string) {
      int indexOfHighlight = text.indexOf(string);
      try {
        String nonHighlightedString = text.substring(index, indexOfHighlight);
        _textSpans
            .add(TextSpan(text: nonHighlightedString, style: nonHighlight));
      } catch (e) {
        // print('$e ');
      }
      index = indexOfHighlight + string.length;
      try {
        String highlightedString = text.substring(indexOfHighlight, index);
        _textSpans.add(TextSpan(text: highlightedString, style: highlight));
      } catch (e) {
        // print('$e');
      }
      text = text.substring(index);
      index = 0;
    });
    if (text.isNotEmpty) {
      _textSpans.add(TextSpan(text: text, style: nonHighlight));
    }
    return _textSpans;
  }

  String _regexValidator(String value) {
    try {
      RegExp(value);
      return null;
    } catch (e) {
      return 'Invalid Regex.';
    }
  }
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
