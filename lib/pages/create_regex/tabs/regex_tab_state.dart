import 'package:easy_regex/hive_utils.dart';
import 'package:easy_regex/pages/create_regex/regex_parameter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'regex_tab_state.g.dart';

@HiveType(typeId: regexTabStateTypeId)
class RegexTabState extends HiveObject {
  @HiveField(0)
  bool containsAnything;
  @HiveField(1)
  List<RegexParameter> containsParameters;
  @HiveField(2)
  List<RegexParameter> notContainsParameters;

  RegexTabState({
    @required this.containsAnything,
    @required this.containsParameters,
    @required this.notContainsParameters,
  });

  void addContainsRegexParameter() {
    containsParameters.add(RegexParameter());
    checkAnythingIfNoParametersPresent();
  }

  void removeContainsRegexParameter(int index) {
    containsParameters.removeAt(index);
    checkAnythingIfNoParametersPresent();
  }

  void addNotContainsRegexParameter() {
    notContainsParameters.add(RegexParameter());
    checkAnythingIfNoParametersPresent();
  }

  void removeNotContainsRegexParameter(int index) {
    notContainsParameters.removeAt(index);
    checkAnythingIfNoParametersPresent();
  }

  void checkAnythingIfNoParametersPresent() {
    final isAnyContainsParameterIncluded =
        containsParameters.any((element) => element.isIncluded);
    final isAnyNotContainsParameterIncluded =
        notContainsParameters.any((element) => element.isIncluded);
    containsAnything =
        !(isAnyContainsParameterIncluded || isAnyNotContainsParameterIncluded);
  }

  @override
  String toString() {
    return 'RegexTabState{'
        'containsAnything: $containsAnything,'
        ' containsParameters: $containsParameters,'
        ' notContainsParameters: $notContainsParameters'
        '}';
  }

  void setAnythingChecked() {
    containsAnything = true;
    for (final element in containsParameters) {
      element.isIncluded = false;
    }
    for (final element in notContainsParameters) {
      element.isIncluded = false;
    }
  }
}
