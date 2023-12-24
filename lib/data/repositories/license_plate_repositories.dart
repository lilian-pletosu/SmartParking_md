import 'package:smart_parking_md/data/models/models.dart';

abstract class LicensePlateRepository {
  Future<void> addLicensePlate(LicensePlate licensePlate);
  Future<void> removeLicensePlate(LicensePlate licensePlate);
  Future<void> updateLicensePlate(LicensePlate licensePlate);
  Future<List<LicensePlate>> getAllLicensesPlates();
}
