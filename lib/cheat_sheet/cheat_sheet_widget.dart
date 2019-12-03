import 'package:easy_regex/cheat_sheet/topic.dart';
import 'package:flutter/material.dart';

class CheatSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (BuildContext context, int index) {
        Topic topic = topics[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8,left: 16,right: 8,top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  Text(
                    topic.title,
                    style: Theme.of(context).textTheme.title,
                  )
                ] +
                topic.content.entries
                    .map(
                      (MapEntry<String, String> mapEntry) {
                        return Row(
                          children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8,left: 16,right: 8,top: 8),
                            child: Text(mapEntry.key),
                          ),
                          Text(mapEntry.value),
                        ],);
                      },
                    )
                    .toList(growable: false),
          ),
        );
      },
    );
  }
}
