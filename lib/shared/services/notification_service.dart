import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:messaging_app/shared/services/user_service.dart';
import 'package:messaging_app/core/constants/app_routes.dart';

class NotificationService {
  StreamSubscription<RemoteMessage>? _onMessageSub;
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final UserService _userService = UserService();

  late GoRouter _router;

  void setRouter(GoRouter router) {
    _router = router;
  }

  Future<void> initialize() async {
    await _messaging.requestPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          _handleNotificationClick(response.payload!);
        }
      },
    );

    _onMessageSub = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleIncomingMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final senderId = message.data['senderId'];
      _handleNotificationClick(senderId);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final senderId = initialMessage.data['senderId'];
      _handleNotificationClick(senderId);
    }

    final token = await _messaging.getToken();
    debugPrint("FCM Token: $token");
  }

  void _handleIncomingMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      final hasImage = data['hasImage'] == 'true';

      _showNotification(
        notification.title ?? 'Nuevo mensaje',
        notification.body ?? '',
        data['senderId'],
        data['senderName'],
        hasImage: hasImage,
        messageData: data,
      );
    }
  }

  Future<void> _showNotification(
    String title,
    String body,
    String? senderId,
    String? senderName, {
    bool hasImage = false,
    Map<String, dynamic>? messageData,
  }) async {
    if (senderId == null) return;

    final contactsBox = Hive.box<ContactModel>('contacts');
    final contact = contactsBox.get(senderId);
    final displayName = contact?.name ?? senderName ?? senderId;

    AndroidNotificationDetails androidDetails;

    if (hasImage) {
      androidDetails = AndroidNotificationDetails(
        'chat_channel',
        'Mensajes',
        channelDescription: 'Notificaciones de mensajes de chat',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        color: const Color(0xFF4CAF50),
        ledColor: const Color(0xFF4CAF50),
        ledOnMs: 1000,
        ledOffMs: 500,
        // Añadir un icono personalizado si tienes uno para imágenes
        // largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_image_notification'),
        autoCancel: true,
        timeoutAfter: 30000,
      );
    } else {
      androidDetails = AndroidNotificationDetails(
        'chat_channel',
        'Mensajes',
        channelDescription: 'Notificaciones de mensajes de chat',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        color: const Color(0xFF2196F3),
        ledColor: const Color(0xFF2196F3),
        ledOnMs: 1000,
        ledOffMs: 500,
        autoCancel: true,
        timeoutAfter: 30000,
      );
    }

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      displayName,
      body,
      notificationDetails,
      payload: senderId,
    );
  }

  Future<void> _handleNotificationClick(String senderId) async {
    if (senderId.isEmpty) return;

    try {
      final contactsBox = Hive.box<ContactModel>('contacts');
      ContactModel? contact = contactsBox.get(senderId);

      if (contact == null) {
        contact = await _userService.fetchUserAsContact(senderId);

        if (contact != null) {
          await contactsBox.put(senderId, contact);
          debugPrint('Contacto guardado en Hive: ${contact.name}');
        } else {
          debugPrint('No se encontró el contacto del remitente');
          return;
        }
      }

      _router.goNamed(AppRoutes.chat, extra: contact);
    } catch (e) {
      debugPrint('Error al abrir chat desde notificación: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  Future<void> dispose() async {
    await _onMessageSub?.cancel();
  }
}
