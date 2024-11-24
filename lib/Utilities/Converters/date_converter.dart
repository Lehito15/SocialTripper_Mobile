import 'dart:collection';

import 'package:social_tripper_mobile/Exceptions/date_exceptions.dart';

class DateConverter {
  static final HashMap<int, String> _months = HashMap.from({
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  });

  static String convertMonthNumberToShortenedText(int number, {int letterNumber = 3}) {
    if (!_months.containsKey(number)) {
      throw WrongMonthNumberException();
    }

    String result = _months[number]!;

    if (letterNumber <= 0) {
      return '';
    }

    if (letterNumber >= result.length) {
      return result;
    }

    return _months[number]!.substring(0, letterNumber);
  }

  static String convertClockTimeToString(int hour, int minute) {
    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = minute.toString().padLeft(2, '0');
    return "$hourStr:$minuteStr";
  }
}