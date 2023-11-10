import 'dart:math';

class StringUtils {
  static String formatNumberWithUnit(
      int value, String singularUnit, String pluralUnit) {
    return "$value ${value == 1 ? singularUnit : pluralUnit}";
  }

  static String formatDuration(Duration duration, {int precision = 3}) {
    bool past = duration < Duration.zero;
    if (past) duration = -duration;

    if (duration < const Duration(minutes: 1)) {
      return past ? "just now" : "now";
    } else {
      List<String> items = [
        if (duration.inDays > 0)
          formatNumberWithUnit(duration.inDays, "day", "days"),
        if (duration.inHours % 24 > 0)
          formatNumberWithUnit(duration.inHours % 24, "hour", "hours"),
        if (duration.inMinutes % 60 > 0)
          formatNumberWithUnit(duration.inMinutes % 60, "minute", "minutes")
      ];
      String joined = grammaticalJoin(
          items.getRange(0, min(precision, items.length)).toList());
      return past ? "$joined ago" : "in $joined";
    }
  }

  static String grammaticalJoin(List<String> items) {
    if (items.length < 2) {
      return items.join();
    } else if (items.length == 2) {
      return items.join(' and ');
    } else {
      final lastItem = items.removeLast();
      final commaSeparated = items.join(', ');
      return '$commaSeparated, and $lastItem';
    }
  }
}
