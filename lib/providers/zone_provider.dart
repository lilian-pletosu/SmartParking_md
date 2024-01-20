import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_parking_md/data/data.dart';

final zoneProvider = StateNotifierProvider<ZoneNotifier, List<Zones>>((ref) {
  return ZoneNotifier();
});

final selectedZoneProvider = StateProvider<Zones?>((ref) {
  return null;
});

class ZoneNotifier extends StateNotifier<List<Zones>> {
  ZoneNotifier() : super([]);

  Future<void> getZones(City? city) async {
    List<Zones>? zones = await DbHelper().getZones(city);
    state = zones.toList();
  }
}
