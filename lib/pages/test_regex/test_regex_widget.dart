import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:easy_regex/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:highlight_text/highlight_text.dart';

enum RegexTestChoice { createdRegex, newRegex }

class TestRegExWidget extends StatelessWidget {
  static final ValueNotifier<String> _testRegexNotifier =
      ValueNotifier<String>(r"[as]");
  static final TextEditingController _controller = TextEditingController();
  static final ValueNotifier<String> _testTextNotifier =
      ValueNotifier<String>('Aas jd kfha jkf h12 32 1 21');
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
                return FutureBuilder<Map<String, HighlightedWord>>(
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
                              child: TextHighlight(
                                text: value,
                                words: snapshot.data,
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

  Future<Map<String, HighlightedWord>> _highlightAccordingToRegex(
      String value) async {
    try {
      String data = _testTextNotifier.value;
      RegExp exp = new RegExp(value);
      print(exp.hasMatch(data));
      Iterable<RegExpMatch> matches = exp.allMatches(data);
      print(matches);
      TextStyle highlightedWordTextStyle = TextStyle(color: Colors.amber);
      Map<String, HighlightedWord> words = <String, HighlightedWord>{};
      for (int i = 0; i < matches.length; i++) {
        String word = matches.elementAt(i).group(0);
        print(word);
        words[word] = HighlightedWord(
          onTap: () {},
          textStyle: highlightedWordTextStyle,
        );
      }
      print(words.keys);
      return words;
    } catch (e, s) {
      print('$e $s');
    }
    return null;
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
