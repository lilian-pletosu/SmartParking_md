// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:smart_parking_md/data/data.dart';

class ZoneFields {
  static const String zoneTable = 'zones';
  static const String idColumn = 'id';
  static const String nameColumn = 'name';
  static const String tarifColumn = 'tarif';
  static const String maxParkingColumn = 'max_parking';
  static const String cityIdColumn = 'city_id';
}

class Zones extends Equatable {
  final int? id;
  final String name;
  final double tarif;
  final String max_parking;
  final int city;
  const Zones({
    this.id,
    required this.name,
    required this.tarif,
    required this.max_parking,
    required this.city,
  });

  @override
  List<Object> get props => [if (id != null) id!, name, tarif];

  Zones copyWith({
    int? id,
    String? nameZone,
    double? tarif,
    String? max_parking,
    int? city,
  }) {
    return Zones(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      max_parking: max_parking ?? this.max_parking,
      tarif: tarif ?? this.tarif,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ZoneFields.idColumn: id,
      ZoneFields.nameColumn: name,
      ZoneFields.tarifColumn: tarif,
      ZoneFields.cityIdColumn: city,
      ZoneFields.maxParkingColumn: max_parking,
    };
  }

  factory Zones.fromMap(Map<String, dynamic> map) {
    return Zones(
      id: ZoneFields.idColumn != null ? ZoneFields.idColumn as int : null,
      name: ZoneFields.nameColumn,
      tarif: ZoneFields.tarifColumn as double,
      city: ZoneFields.cityIdColumn as int,
      max_parking: ZoneFields.maxParkingColumn,
    );
  }

  String toJson() => json.encode(toMap());

  factory Zones.fromJson(Map<String, dynamic> map) {
    return Zones(
        id: map[ZoneFields.idColumn],
        name: map[ZoneFields.nameColumn] ?? 'sss',
        city: map[ZoneFields.cityIdColumn] ?? 'sss',
        max_parking: map[ZoneFields.maxParkingColumn] ?? 'sss',
        tarif: map[ZoneFields.tarifColumn]);
  }

  @override
  bool get stringify => true;
}
