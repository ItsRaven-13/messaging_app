import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

T requireExtra<T>(GoRouterState state) {
  final extra = state.extra;
  if (extra is! T) {
    throw Exception("Se esperaba un extra de tipo $T en ${state.uri}");
  }
  return extra;
}

class OtpVerificationArgs {
  final String phoneNumber;
  final String? autodetectedSmsCode;
  OtpVerificationArgs(this.phoneNumber, {this.autodetectedSmsCode});
}

Future<String?> authRedirect(BuildContext context, GoRouterState state) async {
  final auth = context.read<AuthProvider>();
  final isLoggedIn = auth.isLoggedIn;
  const authRouteNames = [
    AppRoutes.welcome,
    AppRoutes.phoneInput,
    AppRoutes.otpVerification,
    AppRoutes.legalDocument,
  ];
  final authPaths = authRouteNames.map((name) => '/$name').toList();

  final isGoingToAuthRoute = authPaths.any(
    (path) => state.matchedLocation.startsWith(path),
  );

  if (!isLoggedIn) {
    return isGoingToAuthRoute ? null : '/${AppRoutes.welcome}';
  } else {
    final isProfileComplete = await auth.isProfileCompleteLocal();
    if (!isProfileComplete && state.matchedLocation == '/${AppRoutes.home}') {
      return '/${AppRoutes.profileSetup}';
    }
    if (isProfileComplete && isGoingToAuthRoute) {
      return '/${AppRoutes.home}';
    }
  }
  return null;
}
