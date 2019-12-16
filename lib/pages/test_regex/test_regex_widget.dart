import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:easy_regex/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum RegexTestChoice { createdRegex, newRegex }

class TestRegExWidget extends StatelessWidget {
  static final ValueNotifier<String> _testRegexNotifier =
      ValueNotifier<String>(r"<[^>]*>");
  static final TextEditingController _controller = TextEditingController();
  static final ValueNotifier<String> _testTextNotifier =
      ValueNotifier<String>('''<!DOCTYPE html>
<html>
<body>

<p>This is a paragraph.</p>
<p>This is a paragraph.</p>
<p>This is a paragraph.</p>

</body>
</html>''');
  static final ValueNotifier<RegexTestChoice> _testRegexSelectionNotifier =
      ValueNotifier<RegexTestChoice>(RegexTestChoice.createdRegex);

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
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: _testRegexNotifier,
              builder: (BuildContext context, String value, Widget child) {
                return FutureBuilder<List<TextSpan>>(
                  future: _highlightAccordingToRegex(value),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                              padding: const EdgeInsets.all(8.0),
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
                  (value) => _testRegexSelectionNotifier.value = value,
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
      String value) async {
    try {
      String data = _testTextNotifier.value;
      RegExp exp = new RegExp(value);
      print(exp.hasMatch(data));
      Iterable<RegExpMatch> matches = exp.allMatches(data);
      List<String> toBeHighlightedWords = <String>[];
      for (int i = 0; i < matches.length; i++) {
        String word = matches.elementAt(i).group(0);
        toBeHighlightedWords.add(word);
      }
      return _getHighlightedWords(data, toBeHighlightedWords);
    } catch (e, s) {
      print('$e $s');
    }
    return null;
  }

  List<TextSpan> _getHighlightedWords(String text, List<String> toBeHighlighted){
    List<TextSpan> _textSpans = <TextSpan>[];
    TextStyle nonHighlight = TextStyle(color: Colors.black);
    TextStyle highlight = TextStyle(color: Colors.blue);
    int index = 0;
    toBeHighlighted.forEach((String string) {
      int indexOfHighlight = text.indexOf(string);
      try {
        String nonHighlightedString = text.substring(index, indexOfHighlight);
        print('X $nonHighlightedString index: $index, indexOfHighlight: $indexOfHighlight');
        _textSpans
            .add(TextSpan(text: nonHighlightedString, style: nonHighlight));
      } catch (e) {
        // print('$e ');
      }
      print('=======================================');
      index = indexOfHighlight + string.length;
      try {
        String highlightedString = text.substring(indexOfHighlight, index);
        print('+ $highlightedString  indexOfHighlight: $indexOfHighlight, index: $index');
        // print(highlightedString);
        _textSpans.add(TextSpan(text: highlightedString, style: highlight));
        // text = text.substring(indexOfHighlight);
        // text = text.substring(index);
      } catch (e) {
        // print('$e');
      }
      text=text.substring(index);
      index = 0;
      print('~~~~~~~~~~~~~~~ $text ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    });
    if(text.isNotEmpty){
      _textSpans
            .add(TextSpan(text: text, style: nonHighlight));
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
