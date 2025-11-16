import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messaging_app/app/app.dart';
import 'package:messaging_app/app/router/app_router.dart';
import 'package:messaging_app/core/providers/connectivity_provider.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart'
    as auth_provider;
import 'package:messaging_app/features/chat/domain/models/message_model.dart';
import 'package:messaging_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:messaging_app/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:messaging_app/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:messaging_app/shared/services/notification_service.dart';
import 'package:provider/provider.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final notificationService = NotificationService();
  notificationService.setRouter(appRouter);
  await notificationService.initialize();

  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? AndroidDebugProvider()
        : AndroidPlayIntegrityProvider(),
  );
  await Hive.initFlutter();
  Hive.registerAdapter(ContactModelAdapter());
  Hive.registerAdapter(MessageTypeAdapter());
  Hive.registerAdapter(MessageModelAdapter());
  await Hive.openBox('user_profile');
  await Hive.openBox<ContactModel>('contacts');
  await Hive.openBox<MessageModel>('messages');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final chatProvider = ChatProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => auth_provider.AuthProvider(chatProvider: chatProvider),
        ),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => ContactsProvider()),
        ChangeNotifierProvider.value(value: chatProvider),
      ],
      child: MyApp(router: appRouter),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Mensaje recibido en background: ${message.notification?.title}");
}
