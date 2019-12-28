import 'package:flutter/material.dart';

final ValueNotifier<MatchOn> matchOnListenable =
    ValueNotifier<MatchOn>(MatchOn.words);
final ValueNotifier<String> startsWithListenable = ValueNotifier<String>('');
final ValueNotifier<String> containsListenable = ValueNotifier<String>('');
final ValueNotifier<String> endsWithListenable = ValueNotifier<String>('');

const matchOn = <MatchOn, String>{
  MatchOn.words: 'Words',
  MatchOn.lines: 'Lines',
};

const matchOnRegExStart = <MatchOn, String>{
  MatchOn.words: '\\b',
  MatchOn.lines: '^',
};

const matchOnRegExEnd = <MatchOn, String>{
  MatchOn.words: '\\b',
  MatchOn.lines: '\$',
};

enum MatchOn {
  words,
  lines,
}

extension MatchOnExtension on MatchOn {
  String get name => matchOn[this];
  String get valueForStart => matchOnRegExStart[this];
  String get valueForEnd => matchOnRegExEnd[this];
}

String buildRegex() {
  final matchOn = matchOnListenable.value;
  final matchOnStart = matchOn.valueForStart;
  final matchOnEnd = matchOn.valueForEnd;
  final startsWith = startsWithListenable.value;
  final contains = containsListenable.value;
  final endsWith = endsWithListenable.value;
  return '$matchOnStart$startsWith.*$contains.*$endsWith$matchOnEnd';
}
