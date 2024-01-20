// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:smart_parking_md/data/data.dart';

class CityFields {
  static const String cityTable = 'cities';
  static const String idColumn = 'id';
  static const String nameColumn = 'name';
}

class City extends Equatable {
  final int? id;
  final String city;
  final List<Zones>? zones;
  const City({
    this.id,
    this.zones,
    required this.city,
  });

  @override
  List<Object> get props => [if (id != null) id!, city];

  City copyWith({
    int? id,
    String? city,
    List<Zones>? zones,
  }) {
    return City(
        id: id ?? this.id, city: city ?? this.city, zones: zones ?? this.zones);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'city': city, 'zones': zones};
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map[CityFields.idColumn] != null
          ? map[CityFields.idColumn] as int
          : null,
      city: map[CityFields.nameColumn] as String,
      zones: List<Zones>.from((map['zones'] as List<dynamic>?)
              ?.map((zoneMap) => Zones.fromJson(zoneMap)) ??
          []),
    );
  }

  String toJson() => json.encode(toMap());

  factory City.fromJson(Map<String, dynamic> map) {
    return City(
      id: map[CityFields.idColumn],
      city: map[CityFields.nameColumn],
      zones: (map['zones'] as List<dynamic>?)
          ?.map((zoneMap) => Zones.fromJson(zoneMap))
          .toList(), // Transformă lista de zoneMaps într-o listă de obiecte Zones
    );
  }

  @override
  bool get stringify => true;
}
