import 'package:easy_regex/gui/regex_output_widget.dart';
import 'package:flutter/material.dart';

import 'tabs/contains_widget.dart';
import 'tabs/ends_with_widget.dart';
import 'tabs/starts_with_widget.dart';

class CreateRegExWidget extends StatefulWidget {
  @override
  _CreateRegExWidgetState createState() => _CreateRegExWidgetState();
}

class _CreateRegExWidgetState extends State<CreateRegExWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController =
        TabController(vsync: this, length: _createRegExTabs.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RegExOutputWidget(),
          TabBar(isScrollable: true, controller: _tabController, tabs: _tabs),
          Expanded(
            child: TabBarView(controller: _tabController, children: _tabBodies),
          ),
        ],
      ),
    );
  }

  List<Widget> get _tabBodies =>
      _createRegExTabs.map((_createRegExTab) => _createRegExTab.body).toList();

  List<Tab> get _tabs => _createRegExTabs
      .map((_createRegExTab) => _createRegExTab.toTab())
      .toList();
}

final List<_CreateRegExTab> _createRegExTabs = <_CreateRegExTab>[
  _CreateRegExTab('Starts With', StartsWithWidget()),
  _CreateRegExTab('Contains', ContainsWidget()),
  _CreateRegExTab('Ends With', EndsWithWidget()),
];

@immutable
class _CreateRegExTab {
  final String title;
  final Widget body;

  const _CreateRegExTab(this.title, this.body);

  Tab toTab() => Tab(child: Text(title));
}
