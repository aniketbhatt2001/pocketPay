import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles Firebase Cloud Messaging initialisation, permission requests,
/// token management, and foreground/background notification display.
class FirebaseService {
  FirebaseService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  static const _androidChannelId = 'pocket_pay_high_importance';
  static const _androidChannelName = 'PocketPay Notifications';

  /// Initialise FCM: request permission, set up local notifications for
  /// foreground messages, and attach message handlers.
  Future<void> init() async {
    await _requestPermission();
    await _setupLocalNotifications();
    _attachHandlers();
  }

  // ── Permission ────────────────────────────────────────────────────────────

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  // ── Token ─────────────────────────────────────────────────────────────────

  /// Returns the current FCM registration token, or null if unavailable.
  Future<String?> getToken() => _messaging.getToken();

  /// Stream that emits a new token whenever FCM rotates it.
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  // ── Local notifications (foreground) ─────────────────────────────────────

  Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _androidChannelId,
              _androidChannelName,
              importance: Importance.high,
            ),
          );
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    // Navigate or dispatch events here if needed.
    debugPrint('[FCM] Notification tapped: ${response.payload}');
  }

  // ── Message handlers ──────────────────────────────────────────────────────

  void _attachHandlers() {
    // Foreground messages — show a local notification because FCM doesn't
    // display heads-up banners while the app is in the foreground.
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // Background/terminated → app opened via notification.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMessage);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      importance: Importance.high,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }

  void _handleOpenedMessage(RemoteMessage message) {
    // Handle navigation based on message.data when the user taps a notification
    // that woke the app from background/terminated state.
    debugPrint('[FCM] App opened from notification: ${message.messageId}');
  }
}

/// Top-level handler required by FCM for background/terminated messages.
/// Must be a top-level function (not a class method).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] Background message: ${message.messageId}');
}
