import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/core/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';

class NavigationService {
  Future<void> retryConnection(BuildContext context) async {
    final connectivity = Provider.of<ConnectivityProvider>(
      context,
      listen: false,
    );

    if (connectivity.hasConnection) {
      context.goNamed(AppRoutes.welcome);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sigue sin conexión a Internet')),
      );
    }
  }
}
