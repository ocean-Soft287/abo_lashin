class GreetingHelper {
  static String getGreetingKey() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'good_morning';
    } else if (hour >= 12 && hour < 17) {
      return 'good_afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'good_evening';
    } else {
      return 'good_night';
    }
  }
}
