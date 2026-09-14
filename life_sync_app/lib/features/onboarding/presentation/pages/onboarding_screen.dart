import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/app_preferences_service.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';

final class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

final class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _index = 0;

  static const _pages = [
    _OnboardingData(
      title: 'Life gets messy when everything\nlives in different places.',
      description:
          'Tasks in one place. Goals in another. Notes, habits,\nmoney… everywhere.',
      icon: Icons.dashboard_customize_outlined,
    ),
    _OnboardingData(
      title: 'What if it all worked together?',
      description:
          'One wellbeing space connecting habits, focus,\nplanning and progress.',
      icon: Icons.hub_outlined,
    ),
    _OnboardingData(
      title: 'Introducing LifeSync!',
      description:
          'LifeSync brings the important parts of your life\ninto one connected space.',
      icon: Icons.auto_awesome_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await Get.find<AppPreferencesService>().completeOnboarding();
    await Get.offAllNamed<void>(AppRoutes.signIn);
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: _Glow(color: colors.glow, size: 260),
          ),
          Positioned(
            bottom: -100,
            left: -90,
            child: _Glow(color: colors.glow, size: 300),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _finish,
                    child: Text('${_index + 1}/${_pages.length}'),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (value) => setState(() => _index = value),
                    itemBuilder: (context, index) =>
                        _OnboardingPage(data: _pages[index]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 18),
                  child: Row(
                    children: [
                      if (_index > 0)
                        TextButton.icon(
                          onPressed: () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          ),
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: const Text('Prev'),
                        )
                      else
                        const SizedBox(width: 80),
                      const Spacer(),
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: _index == index ? 18 : 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: _index == index
                                  ? colors.primaryBlue
                                  : colors.border,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _next,
                        label: Text(
                          _index == _pages.length - 1 ? 'Get Started' : 'Next',
                        ),
                        icon: const Icon(Icons.arrow_forward, size: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});
  final _OnboardingData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.lifeSyncColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.primaryBlue,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 48),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: .9, end: 1),
            duration: const Duration(milliseconds: 320),
            builder: (_, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: 168,
              height: 168,
              decoration: BoxDecoration(
                color: colors.cardSurface.withValues(alpha: .75),
                shape: BoxShape.circle,
                border: Border.all(color: colors.border),
                boxShadow: [BoxShadow(color: colors.glow, blurRadius: 44)],
              ),
              child: Icon(data.icon, size: 76, color: colors.primaryBlue),
            ),
          ),
          const SizedBox(height: 34),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.secondaryText,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

final class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    ),
  );
}

final class _OnboardingData {
  const _OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
  final String title;
  final String description;
  final IconData icon;
}
