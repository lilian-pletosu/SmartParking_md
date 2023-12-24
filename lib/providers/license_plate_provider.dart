import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data.dart';

final licensePlateProvider =
    StateNotifierProvider<LicensePlateNotifer, List<LicensePlate>>(
        (ref) => LicensePlateNotifer());

class LicensePlateNotifer extends StateNotifier<List<LicensePlate>> {
  LicensePlateNotifer() : super([]) {
    loadPlates();
  }

  Future<void> loadPlates() async {
    List<LicensePlate> licensePlates =
        await LicensePlateDatasource().getAllLicensesPlates();
    state = licensePlates.reversed.toList();
  }

  Future<void> add() async {
    await LicensePlateDatasource().addLicensePlate(
        LicensePlate(licensePlate: 'item ${Random().nextInt(1999)}'));
    loadPlates();
  }

  Future<void> remove(LicensePlate licensePlate) async {
    await LicensePlateDatasource().removeLicensePlate(licensePlate);
    loadPlates();
  }
}
