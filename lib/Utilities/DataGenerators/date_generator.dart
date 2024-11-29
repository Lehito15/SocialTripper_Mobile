import 'dart:math';

class DateGenerator {
  static DateTime generateRandomDate() {
    final Random random = Random();

    int year = random.nextInt(3) + 2020;

    int month = random.nextInt(12) + 1;

    int day = random.nextInt(31) + 1;

    int hour = random.nextInt(24);

    int minute = random.nextInt(60);

    return DateTime(year, month, day, hour, minute);
  }
}