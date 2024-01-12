import 'package:booking_system_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../screens/auth/auth_user_services.dart';
import 'constant.dart';

Future<void> initializeOneSignal() async {
  OneSignal.initialize(getStringAsync(ONESIGNAL_API_KEY));
  OneSignal.Notifications.requestPermission(true);
  OneSignal.User.pushSubscription.optIn();

  saveOneSignalPlayerId();
}

Future<void> saveOneSignalPlayerId() async {
  if (appStore.isLoggedIn) {
    await OneSignal.login(appStore.userId.validate().toString()).then((value) {
      OneSignal.User.addTagWithKey(ONESIGNAL_TAG_KEY, ONESIGNAL_TAG_VALUE);

      if (OneSignal.User.pushSubscription.id.validate().isNotEmpty) {
        appStore.setPlayerId(OneSignal.User.pushSubscription.id.validate());
        updatePlayerId(playerId: OneSignal.User.pushSubscription.id.validate());
      }
    }).catchError((e) {
      log('Error saving subscription id - $e');
    });
  }
}
