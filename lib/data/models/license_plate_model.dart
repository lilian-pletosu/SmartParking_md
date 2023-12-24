// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:smart_parking_md/utils/utils.dart';

class LicensePlate extends Equatable {
  final int? id;
  final String licensePlate;
  const LicensePlate({
    this.id,
    required this.licensePlate,
  });

  @override
  List<Object> get props => [if (id != null) id!, licensePlate];

  LicensePlate copyWith({
    int? id,
    String? licensePlate,
  }) {
    return LicensePlate(
      id: id ?? this.id,
      licensePlate: licensePlate ?? this.licensePlate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      DBKeys.idColumn: id,
      DBKeys.licensePlateColumn: licensePlate,
    };
  }

  factory LicensePlate.fromMap(Map<String, dynamic> map) {
    return LicensePlate(
      id: map['id'] != null ? map['id'] as int : null,
      licensePlate: map['licensePlate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LicensePlate.fromJson(Map<String, dynamic> map) {
    return LicensePlate(
        id: map[LicensePlatesKeys.id],
        licensePlate: map[LicensePlatesKeys.licensePlate]);
  }

  @override
  bool get stringify => true;
}
