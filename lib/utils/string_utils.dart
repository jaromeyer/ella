class StringUtils {
  static String formatNumberWithUnit(
      int value, String singularUnit, String pluralUnit) {
    return "$value ${value == 1 ? singularUnit : pluralUnit}";
  }

  static String formatDuration(Duration duration) {
    bool past = duration < Duration.zero;
    if (past) duration = -duration;

    if (duration < const Duration(minutes: 1)) {
      return past ? "just now" : "now";
    }

    List<String> items = [];
    if (duration.inDays > 0) {
      items.add(formatNumberWithUnit(duration.inDays, "day", "days"));
    }
    if (duration.inHours % 24 > 0) {
      items.add(formatNumberWithUnit(duration.inHours % 24, "hour", "hours"));
    }
    if (duration.inMinutes % 60 > 0) {
      items.add(
          formatNumberWithUnit(duration.inMinutes % 60, "minute", "minutes"));
    }
    return past
        ? "${grammaticalJoin(items)} ago"
        : "in ${grammaticalJoin(items)}";
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
