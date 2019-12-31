import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class RegexParameter extends Equatable {
  final Widget title;
  String regexValue = '';
  bool isIncluded = false;

  RegexParameter(this.title, this.regexValue);

  factory RegexParameter.from(RegexParameter other) {
    return RegexParameter(other.title, '${other.regexValue}')
      ..isIncluded = other.isIncluded;
  }

  @override
  String toString() => '{title: $title, isIncluded: $isIncluded}';

  @override
  List<Object> get props => [title, isIncluded];
}

String parameterListToRegex(List<RegexParameter> list) {
  final joinedRegExValues = list
      .where((parameter) => parameter != null && parameter.isIncluded)
      .map((parameter) => parameter.regexValue)
      .toList(growable: false)
      .join();
  if (joinedRegExValues.isEmpty) return '';
  return '[$joinedRegExValues]';
}

final defaultRegexParameter = RegexParameter(Text('Anything'), '');
final defaultRegexParameterList = <RegexParameter>[defaultRegexParameter];
