import 'package:integration_test/integration_test.dart';
import '../test/features/auth/presentation/pages/sign_up_screen_test.dart'
    as auth_navigation;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  auth_navigation.main();
}
