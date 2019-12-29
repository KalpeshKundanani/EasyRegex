import 'package:easy_regex/pages/create_regex/regex_parameter.dart';
import 'package:easy_regex/pages/create_regex/regex_value_manager.dart';
import 'package:easy_regex/regex_change_notifier_provider.dart';
import 'package:flutter/material.dart';

class StartsWithWidget extends StatefulWidget {
  @override
  _StartsWithWidgetState createState() => _StartsWithWidgetState();
}

class _StartsWithWidgetState extends State<StartsWithWidget> {
  final List<RegexParameter> _startsWithRegexParameterList = [
    RegexParameter(Text('Uppercase letter'), 'A-Z'),
    RegexParameter(Text('Lowercase letter'), 'a-z'),
    RegexParameter(Text('Number'), '0-9'),
    RegexParameter(Text('Symbol'), '!-/:-@\\[-`\\{-~'),
  ];
  ValueNotifier<List<RegexParameter>> _startsWithListNotifier;
  ValueNotifier<RegexParameter> _exactTextNotifier;
  ValueNotifier<RegexParameter> _anyTextNotifier;

  Color _accentColor;

  @override
  void initState() {
    exactText = RegexParameter(TextField(
      onChanged: (String value) {
        exactText.regexValue = value;
        exactText.isIncluded = true;
        _exactTextNotifier.value = RegexParameter.from(exactText);
      },
    ), '');
    _startsWithListNotifier =
        ValueNotifier<List<RegexParameter>>(_startsWithRegexParameterList);
    _exactTextNotifier = ValueNotifier<RegexParameter>(exactText);
    _anyTextNotifier = ValueNotifier<RegexParameter>(defaultRegexParameter);
    _startsWithListNotifier.addListener(() {
      final listToRegex = parameterListToRegex(_startsWithListNotifier.value);
      if (listToRegex.isNotEmpty) {
        startsWithListenable.value = listToRegex;
        _regexValueNotifier(context).value = buildRegex();
      } else if (_exactTextNotifier.value.isIncluded) {
        startsWithListenable.value = _exactTextNotifier.value.regexValue;
        _regexValueNotifier(context).value = buildRegex();
      } else if (_anyTextNotifier.value.isIncluded) {
        startsWithListenable.value = _anyTextNotifier.value.regexValue;
        _regexValueNotifier(context).value = buildRegex();
      }
    });
    _exactTextNotifier.addListener(() {
      if (_exactTextNotifier.value.isIncluded) {
        startsWithListenable.value = _exactTextNotifier.value.regexValue;
        _regexValueNotifier(context).value = buildRegex();
      }
    });

    _anyTextNotifier.addListener(() {
      print(_anyTextNotifier.value);
      if (_anyTextNotifier.value.isIncluded) {
        startsWithListenable.value = '.*';
        _regexValueNotifier(context).value = buildRegex();
      }
    });
    super.initState();
  }

  RegexParameter exactText;

  ValueNotifier<String> _regexValueNotifier(BuildContext context) =>
      RegexChangeNotifierProvider.of(context).regexValueNotifier;

  @override
  Widget build(BuildContext context) {
    _accentColor = Theme.of(context).accentColor;
    return ValueListenableBuilder<List<RegexParameter>>(
      valueListenable: _startsWithListNotifier,
      builder: (BuildContext context, List<RegexParameter> list, Widget child) {
        return ListView.builder(
          itemCount: list.length + 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return CheckboxListTile(
                dense: true,
                title: defaultRegexParameter.title,
                activeColor: _accentColor,
                value: defaultRegexParameter.isIncluded,
                onChanged: (bool isChecked) {
                  defaultRegexParameter.isIncluded = isChecked;
                  if (isChecked) {
                    for (final parameter in list) {
                      parameter.isIncluded = false;
                    }
                    exactText.isIncluded = false;
                    _anyTextNotifier.value =
                        RegexParameter.from(defaultRegexParameter);
                    _startsWithListNotifier.value = List.from(list);
                  }
                },
              );
            }
            if (index == (list.length + 1)) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return CheckboxListTile(
                    dense: true,
                    title: exactText.title,
                    activeColor: _accentColor,
                    value: exactText.isIncluded,
                    onChanged: (bool isChecked) {
                      setState(() {
                        exactText.isIncluded = isChecked;
                        if (isChecked) {
                          for (final parameter in list) {
                            parameter.isIncluded = false;
                          }
                          defaultRegexParameter.isIncluded = false;
                          _startsWithListNotifier.value = List.from(list);
                        }
                      });
                    },
                  );
                },
              );
            }

            index = index - 1;
            final parameter = list[index];
            return CheckboxListTile(
              dense: true,
              title: parameter.title,
              activeColor: _accentColor,
              value: parameter.isIncluded,
              onChanged: (bool value) {
                parameter.isIncluded = value;
                _startsWithListNotifier.value = List.from(list);
                exactText.isIncluded = false;
                defaultRegexParameter.isIncluded = false;
              },
            );
          },
        );
      },
    );
  }
}
