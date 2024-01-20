class Helpers {
  static String checkIfParkingTimeIsSet({required String parkingPeriod}) {
    if (parkingPeriod.isEmpty) {
      return '--:--';
    } else if (parkingPeriod == '30') {
      return '$parkingPeriod min';
    } else {
      return '$parkingPeriod h';
    }
  }
}
