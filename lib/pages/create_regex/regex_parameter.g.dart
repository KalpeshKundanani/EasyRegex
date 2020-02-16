// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regex_parameter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegexParameterAdapter extends TypeAdapter<RegexParameter> {
  @override
  final typeId = 0;

  @override
  RegexParameter read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegexParameter(
      fields[0] as String,
      fields[1] as String,
    )..isIncluded = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, RegexParameter obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.regexValue)
      ..writeByte(2)
      ..write(obj.isIncluded);
  }
}
