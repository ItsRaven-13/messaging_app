import 'package:go_router/go_router.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/app/router/app_screens.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/${AppRoutes.welcome}',
  routes: <GoRoute>[
    GoRoute(
      path: '/${AppRoutes.welcome}',
      name: AppRoutes.welcome,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/${AppRoutes.noConnection}',
      name: AppRoutes.noConnection,
      builder: (context, state) => const NoConnectionScreen(),
    ),
  ],
);
