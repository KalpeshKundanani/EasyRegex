import 'package:flutter/material.dart';

class MatchOnChoiceWidget extends StatelessWidget {
  final ValueNotifier<String> _matchOnListenable =
      ValueNotifier<String>(_matchOn.elementAt(0));
  static const _matchOn = <String>[
    'Match on words',
    'Match on Lines',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder(
        builder: (BuildContext context, value, Widget child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: _matchOn.map((String match) {
              return InkWell(
                onTap: () => _matchOnListenable.value = match,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio<String>(
                      activeColor: Theme.of(context).accentColor,
                      value: match,
                      groupValue: _matchOnListenable.value,
                      onChanged: (String value) {
                        _matchOnListenable.value = value;
                      },
                    ),
                    Text(match),
                  ],
                ),
              );
            }).toList(growable: false),
          );
        },
        valueListenable: _matchOnListenable,
      ),
    );
  }
}
