import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class CurrentPositionNotifier extends StateNotifier<Position> {
  CurrentPositionNotifier()
      : super(Position(
          longitude: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
          latitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          floor: 0,
          isMocked: false,
        )) {
    getCurrentPosition();
  }

  Future<void> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    state = position;
  }
}

final currentPositionProvider =
    StateNotifierProvider<CurrentPositionNotifier, Position>((ref) {
  return CurrentPositionNotifier();
});
