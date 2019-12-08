import 'package:flutter/material.dart';

final ValueNotifier<String> regexValueListenable = ValueNotifier<String>('');

final ValueNotifier<MatchOn> matchOnListenable =
    ValueNotifier<MatchOn>(MatchOn.words);

const matchOn = <MatchOn, String>{
  MatchOn.words: 'Match on words',
  MatchOn.lines: 'Match on Lines',
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

buildRegex() {
  MatchOn matchOn = matchOnListenable.value;
}
