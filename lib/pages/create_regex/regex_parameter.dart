import 'package:easy_regex/hive_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'regex_parameter.g.dart';

@HiveType(typeId: regexParameterTypeId)
class RegexParameter extends Equatable {
  @HiveField(0)
  String title;
  @HiveField(1)
  String regexValue;
  @HiveField(2)
  bool isIncluded;

  RegexParameter([
    this.title = '',
    this.regexValue = '',
    this.isIncluded = false,
  ]);

  factory RegexParameter.from(RegexParameter other) {
    return RegexParameter(other.title, '${other.regexValue}')
      ..isIncluded = other.isIncluded;
  }

  @override
  String toString() => regexValue;

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

final defaultRegexParameter = RegexParameter('Anything', '');
final defaultRegexParameterList = <RegexParameter>[defaultRegexParameter];
