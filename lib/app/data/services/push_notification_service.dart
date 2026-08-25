import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Must be a top-level function (not a class method) so it can run
/// in the background isolate when the app is fully closed/terminated.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Keep this light. Avoid UI/Get calls here — this runs in an isolate
  // that has no widget tree. Good for logging, local DB writes, etc.
  debugPrint('BG FCM message: ${message.messageId}');
}

/// Handles requesting notification permission and registering the
/// device with Firebase Cloud Messaging.
///
/// You are sending notifications manually via the Firebase console,
/// so this service only needs to:
///  1. Ask the user for permission
///  2. Fetch + (optionally) store the FCM token
///  3. Listen for messages while the app is open (foreground) or
///     backgrounded/terminated-then-opened (onMessageOpenedApp)
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // IMPORTANT: do NOT initialize this eagerly as a field (e.g.
  // `final _box = GetStorage();`). That runs the moment
  // `PushNotificationService.instance` is first referenced, which can
  // race with `await GetStorage.init()` in main() and throw:
  // "FileSystemException: An async operation is currently pending".
  // Access it lazily instead, only once initialize() actually runs
  // (by which point main() has already awaited GetStorage.init()).
  GetStorage? _boxCache;
  GetStorage get _box => _boxCache ??= GetStorage();

  static const _kAskedPermissionKey = 'fcm_asked_permission';

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Reactive, live permission status. Bind to this from Settings so the
  /// toggle always reflects reality — including the case where the user
  /// grants/revokes notification access from the OS Settings app while
  /// your app is backgrounded, not just via requestPermission().
  final RxBool isEnabled = false.obs;

  /// True once the OS has given a final (non-"not asked yet") answer,
  /// i.e. the user has been prompted at least once, successfully or not.
  final Rx<AuthorizationStatus> authorizationStatus =
      AuthorizationStatus.notDetermined.obs;

  /// Call once during app startup, after Firebase.initializeApp().
  Future<void> initialize() async {
    // Required so a killed app can still receive & display messages,
    // and so onMessageOpenedApp fires correctly if the user taps a
    // notification that launched the app from a terminated state.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermissionIfNeeded();
    await refreshStatus();

    _fcmToken = await _messaging.getToken();
    debugPrint('FCM token: $_fcmToken');

    // Token can rotate; refresh your backend/analytics record if you
    // store tokens anywhere (you said you're sending from console
    // manually via topics, so this may just be for logging/testing).
    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      debugPrint('FCM token refreshed: $newToken');
    });

    // Foreground messages: iOS/Android do NOT show a system banner
    // automatically while the app is open. Handle it yourself (e.g.
    // show an in-app snackbar/dialog) if you want a foreground alert.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground FCM message: ${message.notification?.title}');
      // TODO: show your own in-app UI here if desired.
    });

    // User tapped a notification and the app opened from background.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification opened app: ${message.data}');
      // TODO: navigate based on message.data if you attach deep-link data.
    });

    // If the app was fully terminated and got opened via a notification tap.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from terminated state via notification');
      // TODO: navigate based on initialMessage.data if needed.
    }
  }

  /// Requests notification permission from the user.
  /// - iOS: shows the native system permission dialog.
  /// - Android 13+: shows the native system permission dialog.
  /// - Android <13: permission is granted by default, this is a no-op.
  ///
  /// Only prompts once per install unless [force] is true, so you don't
  /// nag the user every app launch after they've already answered.
  Future<NotificationSettings> _requestPermissionIfNeeded({
    bool force = false,
  }) async {
    bool alreadyAsked = false;
    try {
      alreadyAsked = _box.read<bool>(_kAskedPermissionKey) ?? false;
    } catch (e) {
      // If GetStorage read fails for any reason, fail open (treat as
      // "not asked yet") rather than silently skipping the prompt.
      debugPrint('GetStorage read failed, defaulting to not-asked: $e');
      alreadyAsked = false;
    }

    // Even if our own flag says "already asked", double check the real
    // OS-level status. `notDetermined` means Android/iOS itself has never
    // shown the dialog (e.g. our previous write failed/crashed before
    // persisting), so we should still show it.
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

  /// Call this from a Settings screen when the user turns the toggle ON.
  ///
  /// Important platform behavior: on both Android 13+ and iOS, the native
  /// system dialog is a ONE-TIME prompt. If the user already denied it
  /// once, calling requestPermission() again will NOT show the dialog
  /// again — it just immediately returns the still-denied status. In that
  /// case, this method automatically falls back to opening the app's
  /// system notification settings page so the user can enable it manually.
  Future<NotificationSettings> requestPermission() async {
    final before = await _messaging.getNotificationSettings();

    final settings = await _requestPermissionIfNeeded(force: true);
    await refreshStatus();

    final stillDenied =
        settings.authorizationStatus == AuthorizationStatus.denied;
    final wasAlreadyDenied =
        before.authorizationStatus == AuthorizationStatus.denied;

    // If it was already denied before this call (meaning the OS dialog
    // was a no-op just now) and it's still denied, the only remaining
    // path is the system settings screen.
    if (stillDenied && wasAlreadyDenied) {
      await openNotificationSettings();
    }

    return settings;
  }

  /// Opens the OS-level notification settings screen for this app.
  /// Use this as the fallback when requestPermission() can't show the
  /// native dialog anymore (already answered once).
  Future<void> openNotificationSettings() async {
    if (Platform.isIOS) {
      await ph.openAppSettings();
    } else {
      // Android: openAppSettings() opens the general app info page,
      // which includes a "Notifications" entry the user can tap.
      await ph.openAppSettings();
    }
  }

  /// Call this whenever you need the latest permission status — e.g. when
  /// the Settings screen appears, or when the app resumes from background
  /// (the user may have just come back from the OS settings screen).
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