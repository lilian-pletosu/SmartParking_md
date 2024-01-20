class PeriodParkingList {
  List<String> generateParkingPeriods() {
    final List<String> periods = [];

    for (int totalMinutes = 30; totalMinutes <= 8 * 60; totalMinutes += 30) {
      final int hours = totalMinutes ~/ 60;
      final int minutes = totalMinutes % 60;

      final formattedHours = hours == 0 ? '' : hours.toString();
      final formattedMinutes =
          minutes == 0 ? '00' : minutes.toString().padLeft(2, '0');

      if (hours == 0) {
        periods.add('$formattedMinutes');
      } else {
        periods.add('$formattedHours:$formattedMinutes');
      }
    }

    return periods;
  }
  String formatNumber(int number) {
    return number < 10 ? '0$number' : '$number';
  }
}
