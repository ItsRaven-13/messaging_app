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
      final notification = message.notification;
      if (notification != null) {
        _showNotification(
          notification.title ?? 'Nuevo mensaje',
          notification.body ?? '',
          message.data['senderId'],
          message.data['senderName'],
        );
      }
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

  Future<void> _showNotification(
    String title,
    String body,
    String? senderId,
    String? senderName,
  ) async {
    if (senderId == null) return;
    final contactsBox = Hive.box<ContactModel>('contacts');
    final contact = contactsBox.get(senderId);

    final displayName = contact?.name ?? senderName ?? senderId;

    const androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Mensajes',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
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
