import 'package:easy_regex/pages/cheat_sheet/topic.dart';
import 'package:flutter/material.dart';

class CheatSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          direction: Axis.horizontal,
          children: topics
              .map((Topic topic) => _topicToCard(context, topic))
              .toList(growable: false),
        ),
      ),
    );
  }

  Card _topicToCard(BuildContext context, Topic topic) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    topic.title,
                    style: textTheme.title,
                  ),
                ),
              ] +
              topic.content.entries.map((MapEntry<String, String> entry) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Text(
                    '${entry.key}\t\t\t\t${entry.value}',
                    style: textTheme.caption,
                  ),
                );
              }).toList(growable: false),
        ),
      ),
    );
  }
}
