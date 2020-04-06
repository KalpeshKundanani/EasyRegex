import 'package:easy_regex/pages/create_regex/tabs/starts_with/starts_with_state.dart';
import 'package:flutter/material.dart';

class StartsWithWidget extends StatefulWidget {
  final StartsWithState state;

  final Function(StartsWithState) onStateChange;

  const StartsWithWidget({
    Key key,
    @required this.state,
    @required this.onStateChange,
  }) : super(key: key);

  @override
  _StartsWithWidgetState createState() => _StartsWithWidgetState();
}

class _StartsWithWidgetState extends State<StartsWithWidget> {
  StartsWithState get _state => widget.state;
  Color _accentColor;

  @override
  Widget build(BuildContext context) {
    _accentColor = Theme.of(context).accentColor;
    return ListView(
      children: <Widget>[
        createCheckedTile('Anything', _state.startsWithAnything, (isChecked) {
          if (isChecked) {
            setState(() {
              _state.isStartWithAnything = true;
            });
            notifyListeners();
          }
        }),
        createCheckedTile('Uppercase letter', _state.startsWithUppercaseLetter,
            (isChecked) {
          setState(() {
            _state.isStartWithUppercaseLetter = isChecked;
          });
          notifyListeners();
        }),
        createCheckedTile('Lowercase letter', _state.startsWithLowercaseLetter,
            (isChecked) {
          setState(() {
            _state.isStartWithLowercaseLetter = isChecked;
          });
          notifyListeners();
        }),
        createCheckedTile('Number', _state.startsWithNumber, (isChecked) {
          setState(() {
            _state.isStartWithNumber = isChecked;
          });
          notifyListeners();
        }),
        createCheckedTile('Symbol', _state.startsWithSymbol, (isChecked) {
          setState(() {
            _state.isStartWithSymbol = isChecked;
          });
          notifyListeners();
        }),
        CheckboxListTile(
          dense: true,
          title: TextFormField(
            initialValue: _state.exactTextToStartWith,
            decoration: InputDecoration(hintText: 'Exact Text'),
            onChanged: (String value) {
              _state.exactTextToStartWith = value;
              if (!_state.startsWithExactText) {
                setState(() {
                  _state.isStartWithExactText = true;
                });
              }
              notifyListeners();
            },
          ),
          activeColor: _accentColor,
          value: _state.startsWithExactText,
          onChanged: (bool isChecked) {
            setState(() {
              _state.isStartWithExactText = isChecked;
            });
            notifyListeners();
          },
        ),
      ],
    );
  }

  void notifyListeners() {
    _state.save().then((value) {
      widget.onStateChange(_state);
    });
  }

  CheckboxListTile createCheckedTile(
    String title,
    bool initialValue,
    ValueChanged<bool> onChanged,
  ) {
    return CheckboxListTile(
      dense: true,
      title: Text(title),
      activeColor: _accentColor,
      value: initialValue,
      onChanged: onChanged,
    );
  }
}
