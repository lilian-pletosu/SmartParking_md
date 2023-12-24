import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

final cityProvider = FutureProvider<String?>((ref) async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  var city =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  return city[0].locality;
});
