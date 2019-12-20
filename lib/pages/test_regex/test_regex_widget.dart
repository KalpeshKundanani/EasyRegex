import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:easy_regex/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'test_text.dart';

/// Options to run RegEx on test text.
enum RegexTestChoice {
  /// RegEx that is created by create RegEx module.
  createdRegex,

  /// RegEx that is entered by user in the text field.
  newRegex,
}

/// Widget that allows user to test the RegEx on a text.
/// Some additional utilites are that user can copy, paste
/// and share RegEx form user input text field.
class TestRegExWidget extends StatelessWidget {
  /// Notfier that is used for tracking changes in RegEx that is used for
  /// testing.
  static final ValueNotifier<String> _testRegexNotifier =
      ValueNotifier<String>(defaultRegexForTest);

  /// TextController that will be used to access value of the text that
  /// user will enter in TextField.
  static final TextEditingController _textControllerForRegexInput =
      TextEditingController(text: defaultRegexForTest);

  /// Notifier used for tracking changes in the text that is used to test
  /// RegEx uppon.
  static final ValueNotifier<String> _testTextNotifier =
      ValueNotifier<String>(dummyTestText);

  /// Notifier used to track value of user's choice of RegexTestChoice.
  static final ValueNotifier<RegexTestChoice> _testRegexSelectionNotifier =
      ValueNotifier<RegexTestChoice>(RegexTestChoice.newRegex);

  @override
  Widget build(BuildContext context) {
    /// Notifier used to track the changes in the RegEx created by user in
    /// Create RegEx module.
    final regexValueNotifier = _regexValueNotifier(context);
    return Padding(
      // main Screen padding.
      padding: defaultPadding,
      // Test view below RegEx input view.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Widget where user can enter RegEx or can use the
          // created RegEx in CreateRegEx module.
          _regexInputWidget(context, regexValueNotifier),

          // Widget that will be used to highlight the text that
          // is selected by the RegEx.
          _regexTestTextWidget(),

          // Widget used to let user paste their text on which they
          // can test RegEx.
          _pasteWidgetForTestText(context),
        ],
      ),
    );
  }

  /// Widget that is used to paste the text coppied by the user.
  Widget _pasteWidgetForTestText(BuildContext context) => Align(
        alignment: Alignment.bottomRight,
        child: Transform.scale(
          scale: 0.75,
          child: FloatingActionButton.extended(
            icon: Icon(Icons.content_paste),
            onPressed: () async {
              _testTextNotifier.value = await textFromClipBoard();
              showSnackBar(context, 'Updated test text.');
            },
            label: Text('Paste'),
          ),
        ),
      );

  /// Used for user to see which text is highlight when they enter
  /// RegEx as input.
  Widget _regexTestTextWidget() => ValueListenableBuilder<String>(
        valueListenable: _testRegexNotifier,
        builder: (final BuildContext context, final String value, _) =>
            FutureBuilder<List<TextSpan>>(
          future: _highlightAccordingToRegex(context, value),
          builder: (_, AsyncSnapshot<List<TextSpan>> snapshot) =>
              snapshot.hasError
                  ? _buildInvalidRegexUI(value)
                  : snapshot.hasData
                      ? _buildTextHighlightWidget(snapshot.data)
                      : _buildLoadingWidget(),
        ),
      );

  /// Widget that shows the text highlighted according to RegEx.
  Expanded _buildTextHighlightWidget(final List<TextSpan> _textSpans) =>
      Expanded(
        child: ValueListenableBuilder<String>(
          valueListenable: _testTextNotifier,
          builder: (BuildContext context, String value, Widget child) {
            return SingleChildScrollView(
              child: Padding(
                padding: defaultPadding,
                child: RichText(
                  text: TextSpan(children: _textSpans),
                ),
              ),
            );
          },
        ),
      );

  /// Creates UI that represents loading.
  Widget _buildLoadingWidget() => Padding(
        padding: defaultPadding,
        child: CircularProgressIndicator(),
      );

  /// Widget that informs user that the entered RegEx is not a valid RegEx.
  Widget _buildInvalidRegexUI(String value) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Invalid RegEx',
              style: TextStyle(color: Colors.redAccent),
            ),
            Padding(
              padding: defaultPadding,
              child: Text(value),
            ),
          ],
        ),
      );

  /// Widget where user can select what RegEx to use.
  /// Utilis like copy, paste and share is shown for user entered RegEx.
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

  /// Widget that allows user to select either the RegEx created by user in
  /// Create RegEx module or the RegEx entered by user in the TextField.
  Widget _regexSelectionWidget(
    final BuildContext context,
    final ValueNotifier<String> regexValueNotifier,
  ) {
    final activeColor = Theme.of(context).accentColor;
    return ValueListenableBuilder<RegexTestChoice>(
        valueListenable: _testRegexSelectionNotifier,
        builder: (_, final RegexTestChoice groupValue, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: _testSelections(context, groupValue, regexValueNotifier)
                .map((final _RegexTestSelection selection) =>
                    selection.toRadioListTile(
                      activeColor,
                      groupValue,
                      (final RegexTestChoice value) {
                        if (value == RegexTestChoice.newRegex) {
                          _testRegexNotifier.value =
                              _textControllerForRegexInput.text;
                        } else {
                          _testRegexNotifier.value =
                              _regexValueNotifier(context).value;
                        }
                        _testRegexSelectionNotifier.value = value;
                      },
                    ))
                .toList(growable: false)));
  }

  /// Copy, paste and share button.
  Widget _regexUtils(
    final BuildContext context,
    final ValueNotifier<String> regexValueNotifier,
  ) {
    return ValueListenableBuilder<RegexTestChoice>(
      valueListenable: _testRegexSelectionNotifier,
      builder: (_, final RegexTestChoice groupValue, __) {
        return ValueListenableBuilder<String>(
          valueListenable: _testRegexNotifier,
          builder: (_, final String newRegexValue, __) {
            final shallCopyOrShare = groupValue == RegexTestChoice.newRegex &&
                _textControllerForRegexInput.text.isNotEmpty;
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: () async => _textControllerForRegexInput.text =
                      await textFromClipBoard(),
                  icon: Icon(Icons.content_paste),
                ),
                IconButton(
                  onPressed: shallCopyOrShare
                      ? () => copyToClipBoard(
                          context, _textControllerForRegexInput.text)
                      : null,
                  icon: Icon(Icons.content_copy),
                ),
                IconButton(
                  onPressed: shallCopyOrShare
                      ? () => shareText(_textControllerForRegexInput.text)
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

  /// TextField to allow user to write and check widget.
  Widget _newRegexInputWidget(
      final BuildContext context, final RegexTestChoice groupValue) {
    return ValueListenableBuilder<RegexTestChoice>(
      valueListenable: _testRegexSelectionNotifier,
      builder: (BuildContext context, RegexTestChoice selection, Widget child) {
        if (selection == RegexTestChoice.newRegex) {
          FocusScope.of(context).requestFocus(myFocusNode);
        }
        return Form(
          key: _formStateKey,
          child: TextFormField(
            controller: _textControllerForRegexInput,
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
                _textControllerForRegexInput.clear();
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

  /// Used to compile regex and match it on data.
  /// returns the TextSpan with highlighted words.
  Future<List<TextSpan>> _highlightAccordingToRegex(
    final BuildContext context,
    final String regexValue,
  ) async {
    final testText = _testTextNotifier.value;
    final regex = RegExp(regexValue);
    final toBeHighlightedWords = regex
        .allMatches(testText)
        .map((final RegExpMatch match) => match.group(0))
        .toList();
    return _highlightMatchedWords(context, testText, toBeHighlightedWords);
  }

  /// highlights the words that are passed as matched and returns textspans
  /// that has both highlighted and unhighlighted texts.
  List<TextSpan> _highlightMatchedWords(
    final BuildContext context,
    String testText,
    final List<String> matchedWords,
  ) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;
    final accentColor = themeData.accentColor;
    final plainTextStyle = textTheme.body2;
    final highlightedTextStyle = TextStyle(
        color: accentColor,
        fontSize: textTheme.body2.fontSize,
        backgroundColor: accentColor.withAlpha(50));
    final _textSpans = <TextSpan>[];
    for (final match in matchedWords) {
      var textCursor = 0;
      // Plain text.
      // jump till the start of the  string to be highlighted.
      final indexOfHighlight = testText.indexOf(match);
      // take non highlight string and give it plain text style.
      final plainText = testText.substring(textCursor, indexOfHighlight);
      // add it to List of text span so that it can be visible on screen.
      _textSpans.add(TextSpan(text: plainText, style: plainTextStyle));

      // Highlighted text.
      // jump till the end of the string that is to be highlighted.
      textCursor = indexOfHighlight + match.length;
      // chop the string that is to be highlighted.
      final textToBeHighlight =
          testText.substring(indexOfHighlight, textCursor);
      // apply highlighted text style and
      // add it to List of text span so that it can be visible on screen.
      _textSpans
          .add(TextSpan(text: textToBeHighlight, style: highlightedTextStyle));
      // chop the string that is not processed.
      testText = testText.substring(textCursor);
    }
    // remaining string will be the string that will not have any string
    // that is to be highlighted.
    if (testText.isNotEmpty) {
      // add it to List of text span so that it can be visible on screen.
      _textSpans.add(TextSpan(text: testText, style: plainTextStyle));
    }
    // return list containing both, highlighted and non=highlighted words.
    return _textSpans;
  }

  /// returns error message if the regex is invalid and null otherwise.
  String _regexValidator(final String value) {
    try {
      // throws format exception in case of invalid RegEx format.
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
