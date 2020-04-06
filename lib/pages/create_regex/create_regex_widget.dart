import 'package:easy_regex/pages/create_regex/create_regex_repository.dart';
import 'package:easy_regex/pages/create_regex/match_on.dart';
import 'package:easy_regex/pages/create_regex/regex_output_widget.dart';
import 'package:easy_regex/pages/create_regex/regex_parameter_change_notification.dart';
import 'package:easy_regex/pages/create_regex/tabs/regex_tab_state.dart';
import 'package:easy_regex/pages/create_regex/tabs/regex_tab_widget.dart';
import 'package:easy_regex/pages/create_regex/tabs/starts_with/starts_with_state.dart';
import 'package:easy_regex/pages/create_regex/tabs/starts_with/starts_with_widget.dart';
import 'package:flutter/material.dart';

class CreateRegExWidget extends StatefulWidget {
  @override
  _CreateRegExWidgetState createState() => _CreateRegExWidgetState();
}

class _CreateRegExWidgetState extends State<CreateRegExWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  CreateRegexRepository _repository;

  @override
  void initState() {
    _repository = CreateRegexRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _repository.init(),
      builder: (context, snapshot) {
        if (_isFutureNotComplete(snapshot)) return Container();
        final tabBodies = _tabBodies(context);
        _tabController ??= TabController(vsync: this, length: tabBodies.length);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildRegExOutputWidget(context),
              TabBar(
                isScrollable: true,
                controller: _tabController,
                tabs: _tabs(context),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: tabBodies,
                ),
              ),
            ],
          ),
        );
      });

  List<Widget> _tabBodies(BuildContext context) => _createRegExTabs(context)
      .map((_createRegExTab) => _createRegExTab.body)
      .toList();

  List<Tab> _tabs(BuildContext context) => _createRegExTabs(context)
      .map((_createRegExTab) => _createRegExTab.toTab())
      .toList();

  List<_CreateRegExTab> _regExTabs;

  List<_CreateRegExTab> _createRegExTabs(BuildContext context) {
    _regExTabs ??= <_CreateRegExTab>[
      _CreateRegExTab('Starts With', startsWithWidget(context)),
      _CreateRegExTab('Contains', containsWidget(context)),
      _CreateRegExTab('Ends With', endsWidget(context)),
    ];
    return _regExTabs;
  }

  Widget startsWithWidget(BuildContext context) {
    void dispatchState(StartsWithState state) {
      RegexParameterChangeNotification(startsWithState: state)
          .dispatch(context);
    }

    final state = _repository.startsWithState;
    dispatchState(state);
    return StartsWithWidget(state: state, onStateChange: dispatchState);
  }

  Widget containsWidget(BuildContext context) {
    void dispatchState(RegexTabState state) {
      RegexParameterChangeNotification(containsTabState: state)
          .dispatch(context);
    }

    final state = _repository.containsState;
    dispatchState(state);
    return RegexTabWidget(state: state, onStateChange: dispatchState);
  }

  Widget endsWidget(BuildContext context) {
    void dispatchState(RegexTabState state) {
      RegexParameterChangeNotification(endsWithTabState: state)
          .dispatch(context);
    }

    final state = _repository.endsWithState;
    dispatchState(state);
    return RegexTabWidget(state: state, onStateChange: dispatchState);
  }

  Widget buildRegExOutputWidget(BuildContext context) {
    void dispatchState(MatchOn matchOn) {
      _repository.saveMatchOn(matchOn).then((value) {
        RegexParameterChangeNotification(matchOn: matchOn).dispatch(context);
      });
    }

    final matchOn = _repository.matchOn;
    dispatchState(matchOn);
    return RegExOutputWidget(
      matchOn: matchOn,
      onMatchOnSelectionChange: dispatchState,
    );
  }

  bool _isFutureNotComplete(AsyncSnapshot snapshot) =>
      !(snapshot.connectionState == ConnectionState.done);
}

@immutable
class _CreateRegExTab {
  final String title;
  final Widget body;

  const _CreateRegExTab(this.title, this.body);

  Tab toTab() => Tab(child: Text(title));
}
