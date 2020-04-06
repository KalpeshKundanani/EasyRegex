import 'package:easy_regex/pages/create_regex/regex_parameter.dart';
import 'package:easy_regex/pages/create_regex/tabs/regex_tab_state.dart';
import 'package:flutter/material.dart';

class RegexTabWidget extends StatefulWidget {
  final RegexTabState state;

  final Function(RegexTabState) onStateChange;

  const RegexTabWidget({
    Key key,
    @required this.state,
    @required this.onStateChange,
  }) : super(key: key);

  @override
  _RegexTabWidgetState createState() => _RegexTabWidgetState();
}

class _RegexTabWidgetState extends State<RegexTabWidget> {
  RegexTabState _state;

  void _notifyListeners() {
    _state.save().then((value) {
      widget.onStateChange(_state);
    });
  }

  @override
  void initState() {
    _state = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _accentColor = Theme.of(context).accentColor;
    return ListView(
      children: <Widget>[
        CheckboxListTile(
          title: Text('Anything'),
          dense: true,
          activeColor: _accentColor,
          value: _state.containsAnything,
          onChanged: (bool isChecked) {
            if (isChecked) {
              setState(_state.setAnythingChecked);
              _notifyListeners();
            }
          },
        ),
        ParameterListCreator(
          title: 'Contains...',
          onPressed: () {
            setState(() {
              _state.addContainsRegexParameter();
            });
            _notifyListeners();
          },
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: _state.containsParameters.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final parameter = _state.containsParameters[index];
            return CheckboxListTile(
              secondary: InkWell(
                child: Icon(Icons.delete),
                onTap: () {
                  setState(() {
                    _state.removeContainsRegexParameter(index);
                  });
                  _notifyListeners();
                },
              ),
              activeColor: _accentColor,
              title: TextFormField(
                initialValue: parameter.regexValue,
                textInputAction: TextInputAction.done,
                onChanged: (String value) {
                  _updateParameterValue(parameter, value);
                },
              ),
              value: parameter.isIncluded,
              onChanged: (final bool isIncluded) {
                setState(() {
                  parameter.isIncluded = isIncluded;
                  _state.checkAnythingIfNoParametersPresent();
                });
                _notifyListeners();
              },
            );
          },
        ),
        ParameterListCreator(
          title: 'But doesn\'t contain...',
          onPressed: () {
            setState(() {
              _state.addNotContainsRegexParameter();
            });
            _notifyListeners();
          },
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: _state.notContainsParameters.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final parameter = _state.notContainsParameters[index];
            return CheckboxListTile(
              secondary: InkWell(
                child: Icon(Icons.delete),
                onTap: () {
                  setState(() {
                    _state.removeNotContainsRegexParameter(index);
                  });
                  _notifyListeners();
                },
              ),
              activeColor: _accentColor,
              title: TextFormField(
                initialValue: parameter.regexValue,
                onChanged: (String value) {
                  _updateParameterValue(parameter, value);
                },
              ),
              value: parameter.isIncluded,
              onChanged: (bool value) {
                setState(() {
                  parameter.isIncluded = value;
                  _state.checkAnythingIfNoParametersPresent();
                });
                _notifyListeners();
              },
            );
          },
        ),
      ],
    );
  }

  void _updateParameterValue(RegexParameter parameter, String value) {
    setState(() {
      parameter.regexValue = value;
      parameter.isIncluded = true;
      _state.containsAnything = false;
    });
    _notifyListeners();
  }
}

class ParameterListCreator extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ParameterListCreator(
      {Key key, @required this.title, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _accentColor = Theme.of(context).accentColor;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: onPressed,
              ),
            ],
          ),
        ),
        Divider(
          color: _accentColor,
          thickness: 1,
          endIndent: 0,
        ),
      ],
    );
  }
}
