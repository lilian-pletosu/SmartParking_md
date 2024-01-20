// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class LicensePlateFields {
  static const String licensePlateTable = 'license_plates';
  static const String idColumn = 'id';
  static const String licensePlateColumn = 'license_plate';
  static const String statusColumn = 'status';
}

class LicensePlate extends Equatable {
  final int? id;
  final String licensePlate;
  final bool status;
  const LicensePlate({
    this.id,
    required this.status,
    required this.licensePlate,
  });

  @override
  List<Object> get props => [
        if (id != null) id!,
        licensePlate,
        status,
      ];

  LicensePlate copyWith({
    int? id,
    String? licensePlate,
    bool? selected,
  }) {
    return LicensePlate(
      id: id ?? this.id,
      status: status ?? this.status,
      licensePlate: licensePlate ?? this.licensePlate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      LicensePlateFields.idColumn: id,
      LicensePlateFields.statusColumn: 1,
      LicensePlateFields.licensePlateColumn: licensePlate,
    };
  }

  factory LicensePlate.fromMap(Map<String, dynamic> map) {
    return LicensePlate(
      id: map[LicensePlateFields.idColumn] != null
          ? map[LicensePlateFields.idColumn] as int
          : null,
      status: map[LicensePlateFields.statusColumn] == 1 ? true : false,
      licensePlate: map[LicensePlateFields.licensePlateColumn] != null
          ? map[LicensePlateFields.licensePlateColumn] as String
          : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LicensePlate.fromJson(Map<String, dynamic> map) {
    return LicensePlate(
        id: map[LicensePlateFields.idColumn],
        status: map[LicensePlateFields.statusColumn] == 1,
        licensePlate: map[LicensePlateFields.licensePlateColumn]);
  }

  @override
  bool get stringify => true;
}
