import 'package:easy_regex/pages/create_regex/tabs/contains_widget.dart';
import 'package:flutter/material.dart';

class EndsWithWidget extends StatelessWidget {
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
          onPressed: () {},
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: _accentColor,
              title: Text(index.toString()),
              value: true,
              onChanged: (bool value) {},
            );
          },
        ),
        ParameterListCreator(
          title: 'But doesn\'t contain...',
          onPressed: () {},
        ),
        ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              activeColor: _accentColor,
              title: Text(index.toString()),
              value: true,
              onChanged: (bool value) {},
            );
          },
        ),
      ],
    );
  }
}
