import 'package:go_router/go_router.dart';
import 'package:messaging_app/app/router/route_helpers.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/app/router/app_screens.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';

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
      path: '/${AppRoutes.addContact}',
      name: AppRoutes.addContact,
      builder: (context, state) => const AddContactScreen(),
    ),
    GoRoute(
      path: '/${AppRoutes.chat}',
      name: AppRoutes.chat,
      builder: (context, state) {
        final extra = state.extra;
        return switch (extra) {
          ContactModel(:final uid, :final name) => ChatScreen(
            contactId: uid,
            contactName: name,
          ),
          {'contactId': String contactId, 'contactName': String contactName} =>
            ChatScreen(contactId: contactId, contactName: contactName),
          _ => const HomeChatScreen(),
        };
      },
    ),
    GoRoute(
      path: '/${AppRoutes.createGroups}',
      name: AppRoutes.createGroups,
      builder: (context, state) => const CreateGroupsScreen(),
    ),
    GoRoute(
      path: '/${AppRoutes.profileEdit}',
      name: AppRoutes.profileEdit,
      builder: (context, state) => const ProfileEditScreen(),
    ),
    GoRoute(
      path: '/${AppRoutes.noConnection}',
      name: AppRoutes.noConnection,
      builder: (context, state) => const NoConnectionScreen(),
    ),
  ],
);
