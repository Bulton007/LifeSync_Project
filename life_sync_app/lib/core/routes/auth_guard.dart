import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_sync_app/core/routes/app_routes.dart';
import 'package:life_sync_app/core/services/auth_session_service.dart';

final class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final sessionService = Get.find<AuthSessionService>();
    if (!sessionService.isInitialized) {
      return const RouteSettings(name: AppRoutes.startup);
    }
    if (!sessionService.isAuthenticated) {
      return const RouteSettings(name: AppRoutes.signIn);
    }
    return null;
  }
}
