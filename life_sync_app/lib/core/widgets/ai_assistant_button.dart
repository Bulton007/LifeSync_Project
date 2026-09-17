import 'package:flutter/material.dart';
import 'package:life_sync_app/core/theme/app_icons.dart';
import 'package:lottie/lottie.dart';

/// Circular floating AI assistant button with a soft blue/purple gradient,
/// subtle glow shadow, and cute robot animation face.
class AIAssistantButton extends StatelessWidget {
  const AIAssistantButton({this.size = 56.0, this.onTap, super.key});

  final double size;
  final VoidCallback? onTap;

  static const Color primaryBlue = Color(0xFF4F8DF7);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFD6CFFF),
                  Color(0xFF9FB6FF),
                  Color(0xFF4F8DF7),
                ],
              ),
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(
              child: Lottie.asset(
                LifeSyncSvgAssets.animedIconAi,
                width: size,
                height: size,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: size * 0.52,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
