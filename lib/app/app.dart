import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/app/theme/app_theme.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart'
    as auth_provider;
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return Consumer<auth_provider.AuthProvider>(
      builder: (context, auth, child) {
        return MaterialApp.router(
          title: 'Messaging App',
          routerConfig: router,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
