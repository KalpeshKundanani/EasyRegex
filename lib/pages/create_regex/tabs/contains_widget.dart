import 'package:flutter/material.dart';

class ContainsWidget extends StatefulWidget {
  @override
  _ContainsWidgetState createState() => _ContainsWidgetState();
}

class _ContainsWidgetState extends State<ContainsWidget> {
  Color _accentColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _accentColor = Theme.of(context).accentColor;
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
            return Text(index.toString());
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
