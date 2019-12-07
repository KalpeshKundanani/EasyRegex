import 'package:flutter/material.dart';

enum CheckableItem {
  anything,
  symbol,
  exact,
  none,
}

const Map<CheckableItem, String> checkableItemNameMap = <CheckableItem, String>{
  CheckableItem.anything: 'Anything',
  CheckableItem.symbol: 'Symbol',
  CheckableItem.exact: 'Excat',
};

const Map<Symbols, String> symbolsItemNameMap = <Symbols, String>{
  Symbols.upperCase: 'Upper Case',
  Symbols.lowerCase: 'Lower Case',
  Symbols.number: 'Number',
  Symbols.symbol: 'Symbol',
};

extension CheckableItemExtension on CheckableItem {
  String get name => checkableItemNameMap[this];
}

extension SymbolsExtension on Symbols {
  String get name => symbolsItemNameMap[this];
}

enum Symbols {
  upperCase,
  lowerCase,
  number,
  symbol,
}

ValueNotifier<CheckableItem> checkNotifier =
    ValueNotifier<CheckableItem>(CheckableItem.anything);
ValueNotifier<Set<Symbols>> symbolCheckNotifier =
    ValueNotifier<Set<Symbols>>(<Symbols>{});

class StartsWithWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: symbolCheckNotifier,
      builder: (BuildContext context, value, Widget child) {
        return ValueListenableBuilder(
          valueListenable: checkNotifier,
          builder: (BuildContext context, value, Widget child) {
            var accentColor = Theme.of(context).accentColor;
            return Column(
              children: <Widget>[
                CheckboxListTile(
                  dense: true,
                  activeColor: accentColor,
                  title: Text(CheckableItem.anything.name),
                  value: checkNotifier.value == CheckableItem.anything,
                  onChanged: (bool value) {
                    checkNotifier.value =
                        value ? CheckableItem.anything : CheckableItem.none;
                    symbolCheckNotifier.value = <Symbols>{};
                  },
                ),
                CheckboxListTile(
                  dense: true,
                  activeColor: accentColor,
                  title: Text(Symbols.upperCase.name),
                  value: checkNotifier.value == CheckableItem.symbol &&
                      symbolCheckNotifier.value.contains(Symbols.upperCase),
                  onChanged: (bool value) {
                    checkNotifier.value = CheckableItem.symbol;
                    Set<Symbols> symbols = Set.from(symbolCheckNotifier.value);
                    if (value) {
                      symbols.add(Symbols.upperCase);
                    } else {
                      symbols.remove(Symbols.upperCase);
                    }
                    symbolCheckNotifier.value = symbols;
                  },
                ),
                CheckboxListTile(
                  dense: true,
                  activeColor: accentColor,
                  title: Text(Symbols.lowerCase.name),
                  value: checkNotifier.value == CheckableItem.symbol &&
                      symbolCheckNotifier.value.contains(Symbols.lowerCase),
                  onChanged: (bool value) {
                    checkNotifier.value = CheckableItem.symbol;
                    Set<Symbols> symbols = Set.from(symbolCheckNotifier.value);
                    if (value) {
                      symbols.add(Symbols.lowerCase);
                    } else {
                      symbols.remove(Symbols.lowerCase);
                    }
                    symbolCheckNotifier.value = symbols;
                  },
                ),
                CheckboxListTile(
                  dense: true,
                  activeColor: accentColor,
                  title: Text(Symbols.number.name),
                  value: checkNotifier.value == CheckableItem.symbol &&
                      symbolCheckNotifier.value.contains(Symbols.number),
                  onChanged: (bool value) {
                    checkNotifier.value = CheckableItem.symbol;
                    Set<Symbols> symbols = Set.from(symbolCheckNotifier.value);
                    if (value) {
                      symbols.add(Symbols.number);
                    } else {
                      symbols.remove(Symbols.number);
                    }
                    symbolCheckNotifier.value = symbols;
                  },
                ),
                CheckboxListTile(
                  dense: true,
                  activeColor: accentColor,
                  title: Text(Symbols.symbol.name),
                  value: checkNotifier.value == CheckableItem.symbol &&
                      symbolCheckNotifier.value.contains(Symbols.symbol),
                  onChanged: (bool value) {
                    checkNotifier.value = CheckableItem.symbol;
                    Set<Symbols> symbols = Set.from(symbolCheckNotifier.value);
                    if (value) {
                      symbols.add(Symbols.symbol);
                    } else {
                      symbols.remove(Symbols.symbol);
                    }
                    symbolCheckNotifier.value = symbols;
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
                      hintText: 'Exact text...',
                    ),
                  ),
                  value: checkNotifier.value == CheckableItem.exact,
                  onChanged: (bool value) {
                    checkNotifier.value =
                        value ? CheckableItem.exact : CheckableItem.none;
                    symbolCheckNotifier.value = <Symbols>{};
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
