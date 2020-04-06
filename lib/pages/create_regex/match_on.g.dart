// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_on.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchOnAdapter extends TypeAdapter<MatchOn> {
  @override
  final typeId = 3;

  @override
  MatchOn read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MatchOn.words;
      case 1:
        return MatchOn.lines;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, MatchOn obj) {
    switch (obj) {
      case MatchOn.words:
        writer.writeByte(0);
        break;
      case MatchOn.lines:
        writer.writeByte(1);
        break;
    }
  }
}
