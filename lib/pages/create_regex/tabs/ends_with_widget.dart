import 'package:easy_regex/pages/create_regex/regex_parameter.dart';
import 'package:easy_regex/pages/create_regex/tabs/contains_widget.dart';
import 'package:flutter/material.dart';

class EndsWithWidget extends StatefulWidget {
  @override
  _EndsWithWidgetState createState() => _EndsWithWidgetState();
}

class _EndsWithWidgetState extends State<EndsWithWidget> {

  final List<RegexParameter> _containsRegexParameters = <RegexParameter>[];
  final List<RegexParameter> _notContainsRegexParameters = <RegexParameter>[];

  @override
  Widget build(BuildContext context) {
    final _accentColor = Theme.of(context).accentColor;
    return ListView(
      children: <Widget>[
        CheckboxListTile(
          title: Text('Anything'),
          dense: true,
          activeColor: _accentColor,
          value: true,
          onChanged: (bool value) {},
        ),
        ParameterListCreator(
          title: 'Contains...',
          onPressed: () {
            RegexParameter parameter;
            final widget = TextField(
              onChanged: (String value){
                parameter.regexValue = value;
              },
            );
            parameter = RegexParameter(widget, '');
            _containsRegexParameters.add(parameter);
          },
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: _containsRegexParameters.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final parameter = _containsRegexParameters[index];
            return CheckboxListTile(
              activeColor: _accentColor,
              title: parameter.title,
              value: parameter.isIncluded,
              onChanged: (bool value) {
                parameter.isIncluded = value;
              },
            );
          },
        ),
        ParameterListCreator(
          title: 'But doesn\'t contain...',
          onPressed: () {
            RegexParameter parameter;
            final widget = TextField(
              onChanged: (String value){
                parameter.regexValue = '(?<!$value)';
              },
            );
            parameter = RegexParameter(widget, '');
            _notContainsRegexParameters.add(parameter);
          },
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: _notContainsRegexParameters.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final parameter = _notContainsRegexParameters[index];
            return CheckboxListTile(
              activeColor: _accentColor,
              title: parameter.title,
              value: parameter.isIncluded,
              onChanged: (bool value) {
                parameter.isIncluded = value;
              },
            );
          },
        ),
      ],
    );
  }
}
