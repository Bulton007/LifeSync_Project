import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/value_objects/money_amount.dart';

void main() {
  test('MoneyAmount preserves exact scale-2 values', () {
    final first = MoneyAmount.parse('100.25');
    final second = MoneyAmount.parse('25.50');

    expect((first + second).toApiString(), '125.75');
    expect((first - second).toApiString(), '74.75');
    expect(MoneyAmount.parse('1.2').toApiString(), '1.20');
    expect(MoneyAmount.parse('-12.30').format(), r'-$12.30');
  });

  test('MoneyAmount rejects precision beyond two decimal places', () {
    expect(() => MoneyAmount.parse('0.001'), throwsFormatException);
  });
}
