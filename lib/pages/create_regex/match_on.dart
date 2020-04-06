import 'package:easy_regex/hive_utils.dart';
import 'package:hive/hive.dart';

part 'match_on.g.dart';

const matchOn = <MatchOn, String>{
  MatchOn.words: 'Words',
  MatchOn.lines: 'Lines',
};

const matchOnRegExStart = <MatchOn, String>{
  MatchOn.words: '\\b',
//  MatchOn.lines: '^',
  MatchOn.lines: '',
};

const matchOnRegExEnd = <MatchOn, String>{
  MatchOn.words: '\\b',
//  MatchOn.lines: '\$',
  MatchOn.lines: '',
};

@HiveType(typeId: matchOnTypeId)
enum MatchOn {
  @HiveField(0)
  words,
  @HiveField(1)
  lines,
}

extension MatchOnExtension on MatchOn {
  String get name => matchOn[this];

  String get valueForStart => matchOnRegExStart[this];

  String get valueForEnd => matchOnRegExEnd[this];
}
