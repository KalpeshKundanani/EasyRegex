import 'package:easy_regex/pages/create_regex/regex_parameter.dart';
import 'package:flutter/material.dart';

class ContainsWidget extends StatefulWidget {
  @override
  _ContainsWidgetState createState() => _ContainsWidgetState();
}

class _ContainsWidgetState extends State<ContainsWidget> {
  static final List<RegexParameter> _containsRegexParameters =
      <RegexParameter>[];
  static final List<RegexParameter> _notContainsRegexParameters =
      <RegexParameter>[];

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
              onChanged: (String value) {
                parameter.regexValue = value;
              },
            );
            parameter = RegexParameter(widget, '');
            setState(() => _containsRegexParameters.add(parameter));
          },
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: _containsRegexParameters.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final parameter = _containsRegexParameters[index];
            return CheckboxListTile(
              secondary: InkWell(
                child: Icon(Icons.delete),
                onTap: () =>
                    setState(() => _containsRegexParameters.removeAt(index)),
              ),
              activeColor: _accentColor,
              title: parameter.title,
              value: parameter.isIncluded,
              onChanged: (bool value) =>
                  setState(() => parameter.isIncluded = value),
            );
          },
        ),
        ParameterListCreator(
          title: 'But doesn\'t contain...',
          onPressed: () {
            RegexParameter parameter;
            final widget = TextField(
              onChanged: (String value) {
                parameter.regexValue = '(?<!$value)';
              },
            );
            parameter = RegexParameter(widget, '');
            setState(() => _notContainsRegexParameters.add(parameter));
          },
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: _notContainsRegexParameters.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final parameter = _notContainsRegexParameters[index];
            return CheckboxListTile(
              secondary: InkWell(
                child: Icon(Icons.delete),
                onTap: () =>
                    setState(() => _notContainsRegexParameters.removeAt(index)),
              ),
              activeColor: _accentColor,
              title: parameter.title,
              value: parameter.isIncluded,
              onChanged: (bool value) =>
                  setState(() => parameter.isIncluded = value),
            );
          },
        ),
      ],
    );
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
