// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      email: fields[3] as String,
      gender: fields[4] as String,
      profile_pic: fields[7] as String,
      diseases: (fields[6] as List).cast<String>(),
      allergies: (fields[5] as List).cast<String>(),
      age: fields[8] as int,
      date_of_birth: fields[9] as String,
      weight: fields[10] as double,
      height: fields[11] as double,
      token: fields[12] as String,
      UserType: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.allergies)
      ..writeByte(6)
      ..write(obj.diseases)
      ..writeByte(7)
      ..write(obj.profile_pic)
      ..writeByte(8)
      ..write(obj.age)
      ..writeByte(9)
      ..write(obj.date_of_birth)
      ..writeByte(10)
      ..write(obj.weight)
      ..writeByte(11)
      ..write(obj.height)
      ..writeByte(12)
      ..write(obj.token)
      ..writeByte(13)
      ..write(obj.UserType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
