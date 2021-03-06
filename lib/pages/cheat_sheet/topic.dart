import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class Topic {
  final String title;
  final Map<String, String> content;

  const Topic(this.title, this.content);

  @override
  String toString() {
    return 'Topic{title: $title, content: $content}';
  }
}

const List<Topic> topics = <Topic>[
  Topic('Metacharacters escaped with \'\\\'', <String, String>{
    '<  (  [  {  \^  -  =  \$  !  |  ]  }  )  ?  *  +  .  >': ''
  }),
  Topic('Special Groups And Characters', <String, String>{
    '[:upper:]': 'Uppercase',
    '[:lower:]': 'Lowercase',
    '[:alpha:]': 'Any letter',
    '[:digit:]': 'Number',
    '[:alphanum:]': 'Letter or num',
    '[:space:]': 'Blank char',
    '[:graph:]': 'Printed char',
    '[:word:]': 'Letter, _, digit',
    '[:cntrl:]': 'Control char',
  }),
  Topic('Groups And Ranges', <String, String>{
    '[abc]': 'Range(a,b or c)',
    '[^abc]': 'Not a,b or c',
    '[a-f]': 'Any char a through f',
    '[1-5]': 'Any digit 1 through 5',
    '(...)': 'Logical group',
    '(x|y)': 'Char x or y',
    '?!': 'Negative lookahead',
    '?<!': 'Negative lookbehind',
  }),
  Topic('Quantifires', <String, String>{
    '.': 'Any Character',
    '*': 'Zero or more',
    '+': 'One or more',
    '?': 'Zero or one',
    '{n}': 'n times',
    '{n,}': 'n or more',
    '{n,m}': 'n to m times',
  }),
  Topic('Anchors', <String, String>{
    '^': 'Start of line/string',
    '\$': 'End of line/string',
    '\\A': 'Start of string only',
    '\\Z': 'End of string only',
    '\\b': 'Word boundry',
    '\\B': 'Non-word boundry',
  }),
  Topic('Character Classes', <String, String>{
    '\\d': 'Digit',
    '\\D': 'Not digit',
    '\\w': 'word',
    '\\W': 'Not word',
    '\\s': 'Whitespace',
    '\\S': 'Non-whitespace',
    '\\c': 'Control char',
  }),
];
