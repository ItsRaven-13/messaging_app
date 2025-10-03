import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/core/providers/connectivity_provider.dart';
import 'package:messaging_app/core/constants/app_routes.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final connectivity = Provider.of<ConnectivityProvider>(context);

    if (!connectivity.hasConnection) {
      // Navegación si no hay conexión
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed(AppRoutes.noConnection);
      });
    }

    return child;
  }
}
