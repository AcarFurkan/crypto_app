// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_coin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MainCurrencyModelAdapter extends TypeAdapter<MainCurrencyModel> {
  @override
  final int typeId = 1;

  @override
  MainCurrencyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MainCurrencyModel(
      name: fields[0] as String,
      lastPrice: fields[1] as String?,
      id: fields[7] as String,
      isFavorite: fields[2] as bool,
      isAlarmActive: fields[5] as bool,
      isMaxAlarmActive: fields[9] as bool,
      isMinAlarmActive: fields[8] as bool,
      counterCurrencyCode: fields[6] as String?,
      priceControl: fields[10] as String?,
      percentageControl: fields[12] as String?,
      isMinLoop: fields[17] as bool?,
      isMaxLoop: fields[18] as bool?,
      lastUpdate: fields[19] as String?,
      minAlarmAudio: fields[15] as AudioModel?,
      maxAlarmAudio: fields[16] as AudioModel?,
      highOf24h: fields[14] as String?,
      lowOf24h: fields[13] as String?,
      changeOf24H: fields[11] as String?,
      addedPrice: fields[20] as String?,
      changeOfPercentageSincesAddedTime: fields[21] as String?,
      min: fields[3] as double,
      max: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MainCurrencyModel obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.lastPrice)
      ..writeByte(2)
      ..write(obj.isFavorite)
      ..writeByte(3)
      ..write(obj.min)
      ..writeByte(4)
      ..write(obj.max)
      ..writeByte(5)
      ..write(obj.isAlarmActive)
      ..writeByte(6)
      ..write(obj.counterCurrencyCode)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.isMinAlarmActive)
      ..writeByte(9)
      ..write(obj.isMaxAlarmActive)
      ..writeByte(10)
      ..write(obj.priceControl)
      ..writeByte(11)
      ..write(obj.changeOf24H)
      ..writeByte(12)
      ..write(obj.percentageControl)
      ..writeByte(13)
      ..write(obj.lowOf24h)
      ..writeByte(14)
      ..write(obj.highOf24h)
      ..writeByte(15)
      ..write(obj.minAlarmAudio)
      ..writeByte(16)
      ..write(obj.maxAlarmAudio)
      ..writeByte(17)
      ..write(obj.isMinLoop)
      ..writeByte(18)
      ..write(obj.isMaxLoop)
      ..writeByte(19)
      ..write(obj.lastUpdate)
      ..writeByte(20)
      ..write(obj.addedPrice)
      ..writeByte(21)
      ..write(obj.changeOfPercentageSincesAddedTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainCurrencyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainCurrencyModel _$MainCurrencyModelFromJson(Map<String, dynamic> json) =>
    MainCurrencyModel(
      name: json['currencyName'] as String,
      lastPrice: json['lastPrice'] as String?,
      id: json['id'] as String,
      isAlarmActive: json['isAlarmActive'] as bool? ?? false,
      addedPrice: json['addedPrice'] as String?,
    );

Map<String, dynamic> _$MainCurrencyModelToJson(MainCurrencyModel instance) =>
    <String, dynamic>{
      'currencyName': instance.name,
      'lastPrice': instance.lastPrice,
      'isAlarmActive': instance.isAlarmActive,
      'id': instance.id,
      'addedPrice': instance.addedPrice,
    };
