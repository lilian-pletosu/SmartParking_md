import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_parking_md/providers/providers.dart';

final totalForParkingProvider = StateProvider<int?>((ref) {
  if (ref.watch(selectedLicenseProvider) != null &&
      ref.watch(parkingPeriodProvider).isNotEmpty &&
      ref.watch(selectedZoneProvider) != null &&
      ref.watch(paymentMethodProvider).toLowerCase() == 'card') {
    return 0;
  }
  return null;
});
