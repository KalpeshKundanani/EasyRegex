import 'package:easy_regex/pages/cheat_sheet/topic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheatSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics.elementAt(index);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[_buildTitle(topic, context)] +
                    topic.content.entries.map(_buildRegexList).toList(),
              ),
            ),
          );
        },
      );

  Padding _buildTitle(Topic topic, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Text(
            topic.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }

  Widget _buildRegexList(MapEntry<String, String> entry) => Padding(
        padding: EdgeInsets.only(left: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(flex: 2, child: Text(entry.key)),
            entry.value.isEmpty
                ? Container()
                : Expanded(flex: 3, child: Text(entry.value)),
          ],
        ),
      );
}
