

import 'package:flutter/material.dart';

import 'main_ui.dart';

class RegExOutputWidget extends StatelessWidget {
  const RegExOutputWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder<String>(
                      builder: (BuildContext context, String value,
                          Widget child) {
                        return Text(value);
                      },
                      valueListenable: regexValueListenable,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    regexValueListenable.value = 'Copy';
                  },
                  icon: Icon(Icons.content_copy),
                ),
                IconButton(
                  onPressed: () {
                    regexValueListenable.value = 'Share';
                  },
                  icon: Icon(Icons.share),
                ),
              ],
            ),
          )),
    );
  }
}