import 'package:flutter/material.dart';

enum EndsWith {
  anything,
  endsWith,
  does_not_contain,
  none,
}

enum EndsWithText {
  endsWith1,
  endsWith2,
  endsWith3,
}

const Map<EndsWith, String> endsWithNameMap = <EndsWith, String>{
  EndsWith.anything: "Anything",
  EndsWith.endsWith: "Ends With...",
  EndsWith.does_not_contain: "Does not ends with...",
};

extension EndsWithExtention on EndsWith {
  String get name => endsWithNameMap[this];
}

class EndsWithWidget extends StatelessWidget {
  ValueNotifier<EndsWith> checkNotifier =
      ValueNotifier<EndsWith>(EndsWith.anything);
  ValueNotifier<Set<EndsWithText>> endsWithCheckNotifier =
      ValueNotifier<Set<EndsWithText>>(<EndsWithText>{});

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).accentColor;
    return ValueListenableBuilder(
      valueListenable: endsWithCheckNotifier,
      builder: (BuildContext context, value, Widget child) {
        return ValueListenableBuilder(
          valueListenable: checkNotifier,
          builder: (BuildContext context, value, Widget child) {
            return Column(
              children: <Widget>[
                CheckboxListTile(
                  dense: true,
                  activeColor: accentColor,
                  title: Text(EndsWith.anything.name),
                  value: checkNotifier.value == EndsWith.anything,
                  onChanged: (bool value) {
                    checkNotifier.value =
                        value ? EndsWith.anything : EndsWith.none;
                    endsWithCheckNotifier.value = <EndsWithText>{};
                  },
                ),
                CheckboxListTile(
                  dense: true,
                  activeColor: accentColor,
                  title: TextFormField(
                    cursorColor: accentColor,
                    decoration: InputDecoration(
                      focusColor: accentColor,
                      hoverColor: accentColor,
                      contentPadding: EdgeInsets.all(16),
                      hintText: EndsWith.endsWith.name,
                    ),
                  ),
                  value: checkNotifier.value == EndsWith.endsWith &&
                      endsWithCheckNotifier.value
                          .contains(EndsWithText.endsWith1),
                  onChanged: (bool value) {
                    checkNotifier.value = EndsWith.endsWith;
                    Set<EndsWithText> symbols =
                        Set.from(endsWithCheckNotifier.value);
                    if (value) {
                      symbols.add(EndsWithText.endsWith1);
                    } else {
                      symbols.remove(EndsWithText.endsWith1);
                    }
                    endsWithCheckNotifier.value = symbols;
                  },
                ),
                CheckboxListTile(
                  dense: true,
                  activeColor: accentColor,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Or: '),
                      Expanded(
                        child: TextFormField(
                          cursorColor: accentColor,
                          decoration: InputDecoration(
                            focusColor: accentColor,
                            hoverColor: accentColor,
                            contentPadding: EdgeInsets.all(16),
                            hintText: EndsWith.endsWith.name,
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: checkNotifier.value == EndsWith.endsWith &&
                      endsWithCheckNotifier.value
                          .contains(EndsWithText.endsWith2),
                  onChanged: (bool value) {
                    checkNotifier.value = EndsWith.endsWith;
                    Set<EndsWithText> symbols =
                        Set.from(endsWithCheckNotifier.value);
                    if (value) {
                      symbols.add(EndsWithText.endsWith2);
                    } else {
                      symbols.remove(EndsWithText.endsWith2);
                    }
                    endsWithCheckNotifier.value = symbols;
                  },
                ),
                CheckboxListTile(
                  dense: true,
                  activeColor: accentColor,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Or: '),
                      Expanded(
                        child: TextFormField(
                          cursorColor: accentColor,
                          decoration: InputDecoration(
                            focusColor: accentColor,
                            hoverColor: accentColor,
                            contentPadding: EdgeInsets.all(16),
                            hintText: EndsWith.endsWith.name,
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: checkNotifier.value == EndsWith.endsWith &&
                      endsWithCheckNotifier.value
                          .contains(EndsWithText.endsWith3),
                  onChanged: (bool value) {
                    checkNotifier.value = EndsWith.endsWith;
                    Set<EndsWithText> symbols =
                        Set.from(endsWithCheckNotifier.value);
                    if (value) {
                      symbols.add(EndsWithText.endsWith3);
                    } else {
                      symbols.remove(EndsWithText.endsWith3);
                    }
                    endsWithCheckNotifier.value = symbols;
                  },
                ),
                CheckboxListTile(
                  dense: true,
                  activeColor: accentColor,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('But: '),
                      Expanded(
                        child: TextFormField(
                          cursorColor: accentColor,
                          decoration: InputDecoration(
                            focusColor: accentColor,
                            hoverColor: accentColor,
                            contentPadding: EdgeInsets.all(16),
                            hintText: EndsWith.does_not_contain.name,
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: checkNotifier.value == EndsWith.does_not_contain,
                  onChanged: (bool value) {
                    checkNotifier.value =
                        value ? EndsWith.does_not_contain : EndsWith.none;
                    endsWithCheckNotifier.value = <EndsWithText>{};
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
