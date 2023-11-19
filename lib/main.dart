import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:p2p_renting_car_app/api/firebase_api.dart';
import 'package:p2p_renting_car_app/providers/shared_preferences_provider.dart';
import 'package:p2p_renting_car_app/services/firebase_messaging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:p2p_renting_car_app/screens/authentication_screen.dart';

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) =>
      FirebaseMessagingService().handleFcmMessage(message));

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences)
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: AuthenticationScreen(),
      ),
      navigatorKey: GlobalVariable.navState,
    );
  }
}
