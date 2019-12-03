import 'package:easy_regex/gui/starts_with_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TabBarDemo extends StatelessWidget {
  final ValueNotifier<String> _regexValueListnable = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[Radio()],
          bottom: TabBar(
            tabs: [
              Tab(icon: Text('Starts with')),
              Tab(icon: Text('Contains')),
              Tab(icon: Text('Ends with')),
            ],
          ),
          title: Text('RegEx'),
        ),
        body: Stack(
          children: <Widget>[
            TabBarView(
              children: [
                StartsWithWidget(),
                Icon(Icons.directions_transit),
                Icon(Icons.directions_bike),
              ],
            ),
            Align(
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
                          builder: (BuildContext context, String value, Widget child) {
                            return Text(value);
                          },
                          valueListenable: _regexValueListnable,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _regexValueListnable.value = 'Copy';
                      },
                      icon: Icon(Icons.content_copy),
                    ),
                    IconButton(
                      onPressed: () {
                        _regexValueListnable.value = 'Share';
                      },
                      icon: Icon(Icons.share),
                    ),
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}