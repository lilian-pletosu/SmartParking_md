import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_parking_md/data/data.dart';

// StateNotifier for managing the list of cities
class CityListNotifier extends StateNotifier<List<City>> {
  CityListNotifier() : super([]);

  Future<void> loadCities() async {
    List<City> cities = await DbHelper().getAllAvailableCitiesWithZones();
    state = cities.toList();
  }

  // You can add other methods to modify the list of cities
}

// StateNotifier for managing the selected city
class SelectedCityNotifier extends StateNotifier<City?> {
  SelectedCityNotifier() : super(null) {
    getCurrentCity();
  }

  void setSelectedCity(City? city) {
    state = city;
  }

  void getCurrentCity() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var cities =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      var gottenCity = cities[0].locality;
      var cit = await DbHelper().getCity(gottenCity ?? '');
      state = cit;
    } catch (e) {
      //
    }
  }
}

// StateNotifierProvider for the list of cities
final cityListProvider =
    StateNotifierProvider<CityListNotifier, List<City>>((ref) {
  return CityListNotifier();
});

// StateNotifierProvider for the selected city
final selectedCityProvider =
    StateNotifierProvider<SelectedCityNotifier, City?>((ref) {
  return SelectedCityNotifier();
});
