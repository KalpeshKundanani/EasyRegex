// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starts_with_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StartsWithStateAdapter extends TypeAdapter<StartsWithState> {
  @override
  final typeId = 2;

  @override
  StartsWithState read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StartsWithState(
      startsWithAnything: fields[0] as bool,
      startsWithLowercaseLetter: fields[1] as bool,
      startsWithUppercaseLetter: fields[2] as bool,
      startsWithNumber: fields[3] as bool,
      startsWithSymbol: fields[4] as bool,
      startsWithExactText: fields[5] as bool,
      exactTextToStartWith: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StartsWithState obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startsWithAnything)
      ..writeByte(1)
      ..write(obj.startsWithLowercaseLetter)
      ..writeByte(2)
      ..write(obj.startsWithUppercaseLetter)
      ..writeByte(3)
      ..write(obj.startsWithNumber)
      ..writeByte(4)
      ..write(obj.startsWithSymbol)
      ..writeByte(5)
      ..write(obj.startsWithExactText)
      ..writeByte(6)
      ..write(obj.exactTextToStartWith);
  }
}
