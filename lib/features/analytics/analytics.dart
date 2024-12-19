import 'package:firebase_analytics/firebase_analytics.dart';

// Initialize Firebase Analytics instance
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// Log user subscription/unsubscription
Future<void> logSubscriptionEvent(String channelId, bool subscribed) async {
  await analytics.logEvent(
    name: 'channel_subscription',
    parameters: {
      'channel_id': channelId,
      'status': subscribed ? 'subscribed' : 'unsubscribed',
    },
  );
}

// Log first-time login
Future<void> logFirstLogin() async {
  await analytics.logEvent(name: 'first_time_login');
}
