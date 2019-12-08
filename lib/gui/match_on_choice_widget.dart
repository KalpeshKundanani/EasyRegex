import 'package:easy_regex/gui/regex_value_manager.dart';
import 'package:flutter/material.dart';

class MatchOnChoiceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder(
        builder: (BuildContext context, value, Widget child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: matchOn.entries.map((MapEntry entry) {
              MatchOn match = entry.key;
              return InkWell(
                onTap: () => matchOnListenable.value = match,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio<MatchOn>(
                      activeColor: Theme.of(context).accentColor,
                      value: match,
                      groupValue: matchOnListenable.value,
                      onChanged: (MatchOn value) {
                        matchOnListenable.value = value;
                      },
                    ),
                    Text(match.name),
                  ],
                ),
              );
            }).toList(growable: false),
          );
        },
        valueListenable: matchOnListenable,
      ),
    );
  }
}
