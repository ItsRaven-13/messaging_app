import 'package:go_router/go_router.dart';
import 'package:messaging_app/app/router/route_helpers.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/app/router/app_screens.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/${AppRoutes.welcome}',
  routes: <GoRoute>[
    GoRoute(
      path: '/${AppRoutes.welcome}',
      name: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/${AppRoutes.phoneInput}',
      name: AppRoutes.phoneInput,
      builder: (context, state) => const PhoneInputScreen(),
    ),
    GoRoute(
      path: '/${AppRoutes.otpVerification}',
      name: AppRoutes.otpVerification,
      builder: (context, state) {
        final args = requireExtra<OtpVerificationArgs>(state);
        return OtpVerificationScreen(phoneNumber: args.phoneNumber);
      },
    ),
    GoRoute(
      path: '/${AppRoutes.profileSetup}',
      name: AppRoutes.profileSetup,
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/${AppRoutes.home}',
      name: AppRoutes.home,
      builder: (context, state) => const HomeChatScreen(),
    ),
    GoRoute(
      path: '/${AppRoutes.contacts}',
      name: AppRoutes.contacts,
      builder: (context, state) => const ContactListScreen(),
    ),
    GoRoute(
      path: '/${AppRoutes.noConnection}',
      name: AppRoutes.noConnection,
      builder: (context, state) => const NoConnectionScreen(),
    ),
  ],
);
