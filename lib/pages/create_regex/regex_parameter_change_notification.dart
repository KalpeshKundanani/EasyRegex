import 'package:easy_regex/pages/create_regex/match_on.dart';
import 'package:easy_regex/pages/create_regex/tabs/regex_tab_state.dart';
import 'package:easy_regex/pages/create_regex/tabs/starts_with/starts_with_state.dart';
import 'package:flutter/cupertino.dart';

class RegexParameterChangeNotification extends Notification {
  StartsWithState startsWithState;
  RegexTabState containsTabState;
  RegexTabState endsWithTabState;
  MatchOn matchOn;

  RegexParameterChangeNotification({
    this.startsWithState,
    this.containsTabState,
    this.endsWithTabState,
    this.matchOn,
  });

  void consume(RegexParameterChangeNotification notification) {
    startsWithState = notification.startsWithState != null
        ? notification.startsWithState
        : startsWithState;
    containsTabState = notification.containsTabState != null
        ? notification.containsTabState
        : containsTabState;
    endsWithTabState = notification.endsWithTabState != null
        ? notification.endsWithTabState
        : endsWithTabState;
    matchOn = notification.matchOn != null ? notification.matchOn : matchOn;
  }

  String calculate() {
    final matchOnStart = matchOn.valueForStart ?? '';
    final matchOnEnd = matchOn.valueForEnd ?? '';
    final startsWithRegex = _buildStartsWithRegex();
    final containsRegex = _buildContainsRegex();
    final endsWithRegex = _buildEndsWithRegex();
    final trailingRegex = containsRegex +
        (endsWithRegex.isEmpty ? '.*' : endsWithRegex + matchOnEnd);
    return matchOnStart +
        startsWithRegex +
        (trailingRegex.isEmpty ? '.*' : trailingRegex);
  }

  String _buildStartsWithRegex() {
    if (startsWithState == null || startsWithState.startsWithAnything) {
      return '';
    }
    if (startsWithState.startsWithExactText) {
      return startsWithState.exactTextToStartWith;
    }
    var regex = '';

    if (startsWithState.startsWithUppercaseLetter) {
      regex = '${regex}A-Z';
    }
    if (startsWithState.startsWithLowercaseLetter) {
      regex = '${regex}a-z';
    }
    if (startsWithState.startsWithNumber) {
      regex = '${regex}0-9';
    }
    if (startsWithState.startsWithSymbol) {
      regex = '$regex!-/:-@\\[-`\\{-~';
    }
    if (regex.isNotEmpty) {
      return '[$regex]';
    } else {
      return '';
    }
  }

  String _buildContainsRegex() {
    if (containsTabState == null || containsTabState.containsAnything) {
      return '';
    }
    var regex = '';
    if (containsTabState.notContainsParameters.isNotEmpty) {
      final list = containsTabState.notContainsParameters
          .map((e) {
            if (!e.isIncluded) return '';
            return e.regexValue;
          })
          .where((e) => (e.isNotEmpty))
          .toList();
      if (list.isNotEmpty) {
        regex = list.join('|');
        regex = '(?!.*$regex)';
      }
    }

    if (containsTabState.containsParameters.isNotEmpty) {
      regex = '$regex.*';
      final list = containsTabState.containsParameters
          .map((e) {
            if (!e.isIncluded) return '';
            return e.regexValue;
          })
          .where((e) => (e.isNotEmpty))
          .toList();
      if (list.isNotEmpty) {
        final currentRegex =
            list.length == 1 ? list.first : '(${list.join('|')})';
        regex = '$regex$currentRegex';
      }
    }
    return regex;
  }

  String _buildEndsWithRegex() {
    if (endsWithTabState == null || endsWithTabState.containsAnything) {
      return '';
    }
    var regex = '';

    if (endsWithTabState.containsParameters.isNotEmpty) {
      regex = '$regex.*';
      final list = endsWithTabState.containsParameters
          .map((e) {
            if (!e.isIncluded) return '';
            return e.regexValue;
          })
          .where((e) => (e.isNotEmpty))
          .toList();
      if (list.isNotEmpty) {
        final currentRegex =
            list.length == 1 ? list.first : '(${list.join('|')})';
        regex = '$regex$currentRegex';
      }
    }

    if (endsWithTabState.notContainsParameters.isNotEmpty) {
      final list = endsWithTabState.notContainsParameters
          .map((e) {
            if (!e.isIncluded) return '';
            return e.regexValue;
          })
          .where((e) => (e.isNotEmpty))
          .toList();
      if (list.isNotEmpty) {
        regex = '$regex(?<!${list.join('|')})';
      }
    }
    return regex;
  }
}
