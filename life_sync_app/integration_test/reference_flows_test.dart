import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test/support/reference_flows.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  var converted = false;
  setUp(() => converted = false);
  registerReferenceFlows(
    capture: (tester, name) async {
      if (!converted) {
        await binding.convertFlutterSurfaceToImage();
        converted = true;
      }
      await tester.pumpAndSettle();
      await binding.takeScreenshot(name);
    },
  );
}
