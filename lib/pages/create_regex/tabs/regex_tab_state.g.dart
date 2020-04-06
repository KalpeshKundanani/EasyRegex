// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regex_tab_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegexTabStateAdapter extends TypeAdapter<RegexTabState> {
  @override
  final typeId = 1;

  @override
  RegexTabState read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegexTabState(
      containsAnything: fields[0] as bool,
      containsParameters: (fields[1] as List)?.cast<RegexParameter>(),
      notContainsParameters: (fields[2] as List)?.cast<RegexParameter>(),
    );
  }

  @override
  void write(BinaryWriter writer, RegexTabState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.containsAnything)
      ..writeByte(1)
      ..write(obj.containsParameters)
      ..writeByte(2)
      ..write(obj.notContainsParameters);
  }
}
