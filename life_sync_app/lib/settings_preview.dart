import 'package:flutter/material.dart';
import 'features/settings/presentation/widgets/settings_layout.dart';

void main() => runApp(const SettingsPreview());

class SettingsPreview extends StatelessWidget {
  const SettingsPreview({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'LifeSync Settings Preview',
    builder: (context, child) => Banner(
      message: 'UI PREVIEW',
      location: BannerLocation.topEnd,
      child: child!,
    ),
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorSchemeSeed: SettingsStyle.blue,
    ),
    home: const _PreviewPage(),
  );
}

class _PreviewPage extends StatefulWidget {
  const _PreviewPage();
  @override
  State<_PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<_PreviewPage> {
  String _appearance = 'System';
  String _firstDay = 'Monday';
  void _notice() => ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Design preview only — no account or backend changes.'),
    ),
  );
  @override
  Widget build(BuildContext context) => SettingsLayout(
    name: 'John Steven',
    email: 'steven@gmail.com',
    counts: const [182, 28, 4, 82],
    appearance: _appearance,
    firstDay: _firstDay,
    onBack: _notice,
    onProfile: () => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (profileContext) => ProfileLayout(
          name: 'John Steven',
          email: 'steven@gmail.com',
          onClose: () => Navigator.pop(profileContext),
          onSave: () => Navigator.pop(profileContext),
          onAvatar: _notice,
          onName: _notice,
          onEmail: _notice,
          onPassword: _notice,
          onProvider: (_) => _notice(),
          onDelete: _notice,
        ),
      ),
    ),
    onAppearance: () => setState(
      () => _appearance = _appearance == 'System' ? 'Light' : 'System',
    ),
    onFirstDay: () =>
        setState(() => _firstDay = _firstDay == 'Monday' ? 'Sunday' : 'Monday'),
    onLanguage: _notice,
    onPasscode: _notice,
    onReminder: _notice,
    onLogout: _notice,
  );
}
