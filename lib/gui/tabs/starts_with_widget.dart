import 'package:flutter/material.dart';

enum CheckableItem {
  anything,
  symbol,
  exact,
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
          return Column(
            children: <Widget>[
              CheckboxListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text('Anything'),
                value: checkNotifier.value == CheckableItem.anything,
                onChanged: (bool value) {
                  checkNotifier.value = CheckableItem.anything;
                  symbolCheckNotifier.value = <Symbols>{};
                  print('symbolCheckNotifier.value: ${symbolCheckNotifier.value}');
                  print('symbols: {}');
                },
              ),
              CheckboxListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text('uppercase letter'),
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
                  print('symbolCheckNotifier.value: ${symbolCheckNotifier.value}');
                  print('symbols: ${symbols}');
                  symbolCheckNotifier.value =symbols;
                },
              ),
              CheckboxListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text('lowercase letter'),
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
                  print('symbolCheckNotifier.value: ${symbolCheckNotifier.value}');
                  print('symbols: ${symbols}');
                  symbolCheckNotifier.value =symbols;
                },
              ),
              CheckboxListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text('number'),
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
                  print('symbolCheckNotifier.value: ${symbolCheckNotifier.value}');
                  print('symbols: ${symbols}');
                  symbolCheckNotifier.value =symbols;

                },
              ),
              CheckboxListTile(
                activeColor: Theme.of(context).accentColor,
                title: Text('symbol'),
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
                  print('symbolCheckNotifier.value: ${symbolCheckNotifier.value}');
                  print('symbols: ${symbols}');
                  symbolCheckNotifier.value =symbols;
                },
              ),
            ],
          );
        },
      );},
    );
   }
}
