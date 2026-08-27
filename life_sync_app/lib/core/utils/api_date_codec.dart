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

  static DateTime decodeLocalDateTime(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      throw FormatException('Expected an ISO local date-time.', value);
    }

    return parsed.isUtc ? parsed.toLocal() : parsed;
  }

  const ApiDateCodec._();
}
