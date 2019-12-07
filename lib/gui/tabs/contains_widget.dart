import 'package:flutter/material.dart';

enum Contains {
  anything,
  contains,
  does_not_contain,
  none,
}

enum ContainsText {
  contains1,
  contains2,
  contains3,
}

const Map<Contains, String> containsNameMap = <Contains, String>{
  Contains.anything: "Anything",
  Contains.contains: "Contains...",
  Contains.does_not_contain: "Does not contain...",
};

extension ContainsExtention on Contains {
  String get name => containsNameMap[this];
}

class ContainsWidget extends StatelessWidget {
  ValueNotifier<Contains> checkNotifier =
      ValueNotifier<Contains>(Contains.anything);
  ValueNotifier<Set<ContainsText>> containsCheckNotifier =
      ValueNotifier<Set<ContainsText>>(<ContainsText>{});

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).accentColor;
    return ValueListenableBuilder(
      valueListenable: containsCheckNotifier,
      builder: (BuildContext context, value, Widget child) {
        return ValueListenableBuilder(
          valueListenable: checkNotifier,
          builder: (BuildContext context, value, Widget child) {
            return Column(
              children: <Widget>[
                CheckboxListTile(
                  dense: true,
                  activeColor: accentColor,
                  title: Text(Contains.anything.name),
                  value: checkNotifier.value == Contains.anything,
                  onChanged: (bool value) {
                    checkNotifier.value =
                        value ? Contains.anything : Contains.none;
                    containsCheckNotifier.value = <ContainsText>{};
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
                      hintText: Contains.contains.name,
                    ),
                  ),
                  value: checkNotifier.value == Contains.contains &&
                      containsCheckNotifier.value
                          .contains(ContainsText.contains1),
                  onChanged: (bool value) {
                    checkNotifier.value = Contains.contains;
                    Set<ContainsText> symbols =
                        Set.from(containsCheckNotifier.value);
                    if (value) {
                      symbols.add(ContainsText.contains1);
                    } else {
                      symbols.remove(ContainsText.contains1);
                    }
                    containsCheckNotifier.value = symbols;
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
                            hintText: Contains.contains.name,
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: checkNotifier.value == Contains.contains &&
                      containsCheckNotifier.value
                          .contains(ContainsText.contains2),
                  onChanged: (bool value) {
                    checkNotifier.value = Contains.contains;
                    Set<ContainsText> symbols =
                        Set.from(containsCheckNotifier.value);
                    if (value) {
                      symbols.add(ContainsText.contains2);
                    } else {
                      symbols.remove(ContainsText.contains2);
                    }
                    containsCheckNotifier.value = symbols;
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
                            hintText: Contains.contains.name,
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: checkNotifier.value == Contains.contains &&
                      containsCheckNotifier.value
                          .contains(ContainsText.contains3),
                  onChanged: (bool value) {
                    checkNotifier.value = Contains.contains;
                    Set<ContainsText> symbols =
                        Set.from(containsCheckNotifier.value);
                    if (value) {
                      symbols.add(ContainsText.contains3);
                    } else {
                      symbols.remove(ContainsText.contains3);
                    }
                    containsCheckNotifier.value = symbols;
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
                            hintText: Contains.does_not_contain.name,
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: checkNotifier.value == Contains.does_not_contain,
                  onChanged: (bool value) {
                    checkNotifier.value =
                        value ? Contains.does_not_contain : Contains.none;
                    containsCheckNotifier.value = <ContainsText>{};
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
