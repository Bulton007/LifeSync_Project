/// Converts Spring `LocalDate` and `LocalDateTime` values consistently.
abstract final class ApiDateCodec {
  static final RegExp _datePattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  static String encodeDate(DateTime value) {
    final local = value.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }

  static DateTime decodeDate(String value) {
    final match = _datePattern.firstMatch(value);
    if (match == null) {
      throw FormatException('Expected an ISO local date.', value);
    }

    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    final parsed = DateTime(year, month, day);

    if (parsed.year != year || parsed.month != month || parsed.day != day) {
      throw FormatException('Invalid calendar date.', value);
    }

    return parsed;
  }

  static String encodeLocalDateTime(DateTime value) {
    return value.toLocal().toIso8601String();
  }

  static DateTime decodeLocalDateTime(Object? value) {
    if (value == null) {
      return DateTime.now();
    }
    if (value is DateTime) {
      return value.isUtc ? value.toLocal() : value;
    }
    if (value is List) {
      if (value.isEmpty) return DateTime.now();
      final year = (value[0] as num).toInt();
      final month = value.length > 1 ? (value[1] as num).toInt() : 1;
      final day = value.length > 2 ? (value[2] as num).toInt() : 1;
      final hour = value.length > 3 ? (value[3] as num).toInt() : 0;
      final minute = value.length > 4 ? (value[4] as num).toInt() : 0;
      final second = value.length > 5 ? (value[5] as num).toInt() : 0;
      final microsecond = value.length > 6
          ? ((value[6] as num).toInt() ~/ 1000)
          : 0;
      return DateTime(year, month, day, hour, minute, second, 0, microsecond);
    }
    if (value is num) {
      final val = value.toInt();
      if (val < 10000000000) {
        return DateTime.fromMillisecondsSinceEpoch(val * 1000);
      }
      return DateTime.fromMillisecondsSinceEpoch(val);
    }
    final str = value.toString().trim();
    if (str.isEmpty) return DateTime.now();

    final parsed =
        DateTime.tryParse(str) ?? DateTime.tryParse(str.replaceFirst(' ', 'T'));
    if (parsed != null) {
      return parsed.isUtc ? parsed.toLocal() : parsed;
    }

    final match = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})(?:[T ](\d{2}):(\d{2})(?::(\d{2}))?)?',
    ).firstMatch(str);
    if (match != null) {
      final y = int.parse(match.group(1)!);
      final m = int.parse(match.group(2)!);
      final d = int.parse(match.group(3)!);
      final h = match.group(4) != null ? int.parse(match.group(4)!) : 0;
      final min = match.group(5) != null ? int.parse(match.group(5)!) : 0;
      final sec = match.group(6) != null ? int.parse(match.group(6)!) : 0;
      return DateTime(y, m, d, h, min, sec);
    }

    return DateTime.now();
  }

  const ApiDateCodec._();
}
