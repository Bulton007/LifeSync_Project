import 'package:flutter_test/flutter_test.dart';
import 'package:life_sync_app/core/utils/api_date_codec.dart';

void main() {
  group('ApiDateCodec', () {
    test('encodes and decodes a Spring LocalDate', () {
      final encoded = ApiDateCodec.encodeDate(DateTime(2026, 8, 5));
      final decoded = ApiDateCodec.decodeDate(encoded);

      expect(encoded, '2026-08-05');
      expect(decoded, DateTime(2026, 8, 5));
    });

    test('rejects an impossible LocalDate', () {
      expect(
        () => ApiDateCodec.decodeDate('2026-02-30'),
        throwsFormatException,
      );
    });

    test('encodes LocalDateTime without a UTC suffix', () {
      final encoded = ApiDateCodec.encodeLocalDateTime(
        DateTime.utc(2026, 8, 5, 12, 30),
      );

      expect(encoded.endsWith('Z'), isFalse);
      expect(ApiDateCodec.decodeLocalDateTime(encoded).isUtc, isFalse);
    });
  });
}
