import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/data.dart';

final selectedLicenseProvider = StateProvider<String?>((ref) {
  return null;
});

final licensePlateProvider =
    StateNotifierProvider<LicensePlateNotifer, List<LicensePlate>>(
        (ref) => LicensePlateNotifer());

class LicensePlateNotifer extends StateNotifier<List<LicensePlate>> {
  LicensePlateNotifer() : super([]) {
    loadPlates();
  }
  Future<void> loadPlates() async {
    List<LicensePlate> licensePlates = await DbHelper().getAllLicensesPlates();
    state = licensePlates.reversed.toList();
  }

  Future<LicensePlate> add(String licensePlate) async {
    LicensePlate newLicense =
        LicensePlate(licensePlate: licensePlate, status: true);
    await DbHelper().addLicensePlate(newLicense);
    return newLicense;
    loadPlates();
  }

  Future<void> remove(LicensePlate licensePlate) async {
    await DbHelper().removeLicensePlate(licensePlate);
    loadPlates();
  }

  Future<void> updateSelectedLicense(LicensePlate licensePlate) async {
    await DbHelper().updateStatusLicensePlate(licensePlate);
    loadPlates();
  }
}
