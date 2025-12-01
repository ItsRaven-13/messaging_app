import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:messaging_app/features/chat/domain/models/message_model.dart';
import 'package:messaging_app/shared/services/notification_service.dart';
import 'package:messaging_app/app/router/app_router.dart';
import 'package:messaging_app/firebase_options.dart';

class AppInitializer {
  static Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(ContactModelAdapter());
      Hive.registerAdapter(MessageTypeAdapter());
      Hive.registerAdapter(MessageModelAdapter());

      Future<void> openBoxIfNeeded<T>(String name) async {
        if (!Hive.isBoxOpen(name)) {
          await Hive.openBox<T>(name);
        }
      }

      await openBoxIfNeeded('user_profile');
      await openBoxIfNeeded<ContactModel>('contacts');
      await openBoxIfNeeded<MessageModel>('messages');

      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e) {
        debugPrint("Firebase NO pudo inicializar (offline): $e");
      }

      if (Firebase.apps.isNotEmpty) {
        await FirebaseAppCheck.instance.activate(
          providerAndroid: kDebugMode
              ? AndroidDebugProvider()
              : AndroidPlayIntegrityProvider(),
        );
      }

      if (Firebase.apps.isNotEmpty) {
        final notificationService = NotificationService();
        notificationService.setRouter(appRouter);
        await notificationService.initialize();
        FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler,
        );
      }
    } catch (e) {
      debugPrint('Error inicializando servicios: $e');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    debugPrint(
      "Mensaje recibido en background: ${message.notification?.title}",
    );
  }
}
