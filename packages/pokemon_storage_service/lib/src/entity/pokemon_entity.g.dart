// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonEntityAdapter extends TypeAdapter<PokemonEntity> {
  @override
  final typeId = 0;

  @override
  PokemonEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonEntity(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      height: (fields[3] as num).toInt(),
      weight: (fields[4] as num).toInt(),
      types: (fields[5] as List).cast<PokemonTypeEntity>(),
      sprites: fields[6] as PokemonSpritesEntity,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.types)
      ..writeByte(6)
      ..write(obj.sprites);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PokemonTypeEntityAdapter extends TypeAdapter<PokemonTypeEntity> {
  @override
  final typeId = 1;

  @override
  PokemonTypeEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonTypeEntity(
      slot: (fields[0] as num).toInt(),
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonTypeEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.slot)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonTypeEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PokemonSpritesEntityAdapter extends TypeAdapter<PokemonSpritesEntity> {
  @override
  final typeId = 2;

  @override
  PokemonSpritesEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonSpritesEntity(
      frontDefault: fields[0] as String,
      backDefault: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonSpritesEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.frontDefault)
      ..writeByte(1)
      ..write(obj.backDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonSpritesEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
