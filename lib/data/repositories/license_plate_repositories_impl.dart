import 'package:smart_parking_md/data/data.dart';
import 'package:smart_parking_md/data/models/license_plate_model.dart';
import 'package:smart_parking_md/data/repositories/respositories.dart';

class LicensePlateRepositoryImpl extends LicensePlateRepository {
  final LicensePlateDatasource _datasource;

  LicensePlateRepositoryImpl(this._datasource);

  @override
  Future<void> addLicensePlate(LicensePlate licensePlate) async {
    try {
      await _datasource.addLicensePlate(licensePlate);
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<List<LicensePlate>> getAllLicensesPlates() async {
    try {
      return await _datasource.getAllLicensesPlates();
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<void> removeLicensePlate(LicensePlate licensePlate) async {
    try {
      await _datasource.removeLicensePlate(licensePlate);
    } catch (e) {
      throw '$e';
    }
  }

  @override
  Future<void> updateLicensePlate(LicensePlate licensePlate) async {
    try {
      await _datasource.updateLicensePlate(licensePlate);
    } catch (e) {
      throw '$e';
    }
  }
}
