import 'package:easy_regex/gui/tabs/contains_widget.dart';
import 'package:easy_regex/gui/tabs/ends_with_widget.dart';
import 'package:easy_regex/gui/tabs/starts_with_widget.dart';
import 'package:flutter/material.dart';

import 'match_on_choice_widget.dart';

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: _actions,
          bottom: _tabBar,
        ),
        body: _tabBarView,
      ),
    );
  }

  List<Widget> get _actions => <Widget>[
        MatchOnChoiceWidget(),
      ];

  TabBarView get _tabBarView => TabBarView(
        children: <Widget>[
          StartsWithWidget(),
          ContainsWidget(),
          EndsWithWidget(),
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
