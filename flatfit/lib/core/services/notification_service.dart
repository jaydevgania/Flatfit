/// Channel options for multi-channel messaging in India (Push, WhatsApp, SMS).
enum NotificationChannel { push, whatsApp, sms, inApp }

/// Interface and default implementation for sending and handling notifications.
abstract class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermissions();
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    NotificationChannel channel = NotificationChannel.push,
    Map<String, dynamic>? data,
  });
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
}

class FlatFitNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {
    // Initializes push notification client, FCM / local notifications
  }

  @override
  Future<bool> requestPermissions() async {
    // Request OS-level notification permissions
    return true;
  }

  @override
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    NotificationChannel channel = NotificationChannel.push,
    Map<String, dynamic>? data,
  }) async {
    // In production, calls Supabase Edge Function 'send-notification'
  }

  @override
  Future<void> subscribeToTopic(String topic) async {}

  @override
  Future<void> unsubscribeFromTopic(String topic) async {}
}
