import 'package:easy_regex/gui/regex_output_widget.dart';
import 'package:easy_regex/gui/tabs/starts_with_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'match_on_choice_widget.dart';

final ValueNotifier<String> regexValueListenable = ValueNotifier<String>('');

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('RegEx'),
          actions: _actions,
          bottom: _tabBar,
        ),
        body: Stack(
          children: <Widget>[
            _tabBarView,
            RegExOutputWidget(),
          ],
        ),
      ),
    );
  }

  List<Widget> get _actions => <Widget>[
        MatchOnChoiceWidget(),
      ];

  TabBarView get _tabBarView => TabBarView(
        children: [
          StartsWithWidget(),
          Icon(Icons.directions_transit),
          Icon(Icons.directions_bike),
        ],
      );

  TabBar get _tabBar => TabBar(
        tabs: [
          Tab(icon: Text('Starts with')),
          Tab(icon: Text('Contains')),
          Tab(icon: Text('Ends with')),
        ],
      );
}
