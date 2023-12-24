import 'package:flutter/foundation.dart';
import 'package:smart_parking_md/utils/utils.dart';

@immutable
class DBKeys {
  const DBKeys._();
  static const String dbName = 'parking.db';
  static const String dbTable = 'license_plates';
  static const String idColumn = LicensePlatesKeys.id;
  static const String licensePlateColumn = LicensePlatesKeys.licensePlate;
}
