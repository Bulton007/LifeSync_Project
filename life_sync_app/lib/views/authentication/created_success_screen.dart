import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';
import 'package:life_sync_app/core/theme/app_colors.dart';

class CreatedSuccessScreen extends StatelessWidget {
  const CreatedSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.lifeSyncColors.pageBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Illustration from Life-Sync SVG File (undraw_done_i0ak 1.svg)
              SvgPicture.asset(
                LifeSyncSvgAssets.done,
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 48),

              // Success Heading
              Text(
                'You’re all set!'.tr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2979FF),
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle Text
              Text(
                'Welcome to LifeSync! Your Account is ready.\nLet’s find out what we have.'
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: context.lifeSyncColors.secondaryText,
                ),
              ),

              const Spacer(),

              // Get Started Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed<void>(AppRoutes.signIn),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Get Started'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
