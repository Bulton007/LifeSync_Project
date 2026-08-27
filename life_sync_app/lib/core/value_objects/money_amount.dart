/// Exact scale-2 monetary value used at the API boundary.
final class MoneyAmount implements Comparable<MoneyAmount> {
  const MoneyAmount._(this.minorUnits);

  factory MoneyAmount.parse(Object value) {
    final text = value.toString().trim();
    final match = RegExp(r'^(-?)(\d+)(?:\.(\d{1,2}))?$').firstMatch(text);
    if (match == null) {
      throw FormatException('Expected a scale-2 decimal amount.', text);
    }
    final sign = match.group(1) == '-' ? -1 : 1;
    final whole = BigInt.parse(match.group(2)!);
    final fraction = (match.group(3) ?? '').padRight(2, '0');
    return MoneyAmount._(
      (whole * BigInt.from(100) +
              BigInt.parse(fraction.isEmpty ? '0' : fraction)) *
          BigInt.from(sign),
    );
  }

  factory MoneyAmount.zero() => MoneyAmount._(BigInt.zero);

  final BigInt minorUnits;

  String toApiString() {
    final negative = minorUnits.isNegative;
    final absolute = minorUnits.abs();
    final whole = absolute ~/ BigInt.from(100);
    final fraction = (absolute % BigInt.from(100)).toString().padLeft(2, '0');
    return '${negative ? '-' : ''}$whole.$fraction';
  }

  String format({String symbol = r'$'}) {
    final value = toApiString();
    return value.startsWith('-')
        ? '-$symbol${value.substring(1)}'
        : '$symbol$value';
  }

  double ratioOf(MoneyAmount target) {
    if (target.minorUnits <= BigInt.zero) {
      return 0;
    }
    final basisPoints = (minorUnits * BigInt.from(10000)) ~/ target.minorUnits;
    return (basisPoints.toInt() / 10000).clamp(0, 1);
  }

  MoneyAmount operator +(MoneyAmount other) =>
      MoneyAmount._(minorUnits + other.minorUnits);
  MoneyAmount operator -(MoneyAmount other) =>
      MoneyAmount._(minorUnits - other.minorUnits);

  @override
  int compareTo(MoneyAmount other) => minorUnits.compareTo(other.minorUnits);

  @override
  bool operator ==(Object other) =>
      other is MoneyAmount && minorUnits == other.minorUnits;

  @override
  int get hashCode => minorUnits.hashCode;
}
