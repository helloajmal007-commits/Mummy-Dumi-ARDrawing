import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('BG FCM message: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  GetStorage? _boxCache;

  GetStorage get _box => _boxCache ??= GetStorage();

  static const _kAskedPermissionKey = 'fcm_asked_permission';

  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  final RxBool isEnabled = false.obs;

  final Rx<AuthorizationStatus> authorizationStatus =
      AuthorizationStatus.notDetermined.obs;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermissionIfNeeded();
    await refreshStatus();

    try {
      _fcmToken = await _messaging.getToken();
      debugPrint('FCM token: $_fcmToken');
    } catch (e, st) {
      debugPrint('FCM getToken failed: $e');
      FirebaseCrashlytics.instance.recordError(
        e,
        st,
        reason: 'FCM getToken failed during PushNotificationService.initialize',
        fatal: false,
      );
    }

    _messaging.onTokenRefresh.listen(
      (newToken) {
        _fcmToken = newToken;
        debugPrint('FCM token refreshed: $newToken');
      },
      onError: (e, st) {
        debugPrint('FCM onTokenRefresh error: $e');
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground FCM message: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification opened app: ${message.data}');
    });

    try {
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('App opened from terminated state via notification');
      }
    } catch (e, st) {
      debugPrint('FCM getInitialMessage failed: $e');
      FirebaseCrashlytics.instance.recordError(
        e,
        st,
        reason:
            'FCM getInitialMessage failed during PushNotificationService.initialize',
        fatal: false,
      );
    }
  }

  Future<NotificationSettings> _requestPermissionIfNeeded({
    bool force = false,
  }) async {
    bool alreadyAsked = false;
    try {
      alreadyAsked = _box.read<bool>(_kAskedPermissionKey) ?? false;
    } catch (e) {
      debugPrint('GetStorage read failed, defaulting to not-asked: $e');
      alreadyAsked = false;
    }

    if (!alreadyAsked || force) {
      final current = await _messaging.getNotificationSettings();
      final neverPrompted =
          current.authorizationStatus == AuthorizationStatus.notDetermined;

      if (!alreadyAsked || force || neverPrompted) {
        final settings = await _messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );
        try {
          await _box.write(_kAskedPermissionKey, true);
        } catch (e) {
          debugPrint('GetStorage write failed (non-fatal): $e');
        }
        debugPrint(
          'Notification permission status: ${settings.authorizationStatus}',
        );
        return settings;
      }
    }

    return _messaging.getNotificationSettings();
  }

  Future<NotificationSettings> requestPermission() async {
    final before = await _messaging.getNotificationSettings();

    final settings = await _requestPermissionIfNeeded(force: true);
    await refreshStatus();

    final stillDenied =
        settings.authorizationStatus == AuthorizationStatus.denied;
    final wasAlreadyDenied =
        before.authorizationStatus == AuthorizationStatus.denied;

    if (stillDenied && wasAlreadyDenied) {
      await openNotificationSettings();
    }

    return settings;
  }

  Future<void> openNotificationSettings() async {
    if (Platform.isIOS) {
      await ph.openAppSettings();
    } else {
      await ph.openAppSettings();
    }
  }

  Future<void> refreshStatus() async {
    final settings = await _messaging.getNotificationSettings();
    authorizationStatus.value = settings.authorizationStatus;
    isEnabled.value =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<NotificationSettings> getSettings() =>
      _messaging.getNotificationSettings();
}
