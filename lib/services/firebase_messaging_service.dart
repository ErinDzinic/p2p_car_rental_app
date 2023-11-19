import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:p2p_renting_car_app/main.dart';
import 'package:p2p_renting_car_app/models/car_model.dart';
import 'package:p2p_renting_car_app/screens/car_details_overview_screen.dart';
import 'package:p2p_renting_car_app/screens/home/home_screen.dart';

class FirebaseMessagingService {
  FirebaseMessagingService();

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined permission');
    }
  }

  void saveToken(String token) async => await FirebaseFirestore.instance
      .collection('UserTokens')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .set({'token': token});

  Future<bool> sendPushMessage(String token, String body, String title,
      String? carJson, String notificationSenderId) async {
    try {
      const postUrl = 'https://fcm.googleapis.com/fcm/send';

      final headers = {
        'content-type': 'application/json',
        'Authorization':
            'key=AAAAHcfQ2cE:APA91bFU4VvLQm2M0iq67rOSHz6t7DU4zGo2U_jdLRxFOf6XSYo4C_oE7OVkEQt6yzI2exjEW55VSPl8Zqru1NC45DrOzrvZVm61W5pvHKkWWyG7YRnxsYY5JsF2j_9-NoBB7Vym5MaG'
      };

      final data = {
        "notification": {
          "body": body,
          "title": title,
        },
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done",
          "car": carJson,
          "notificationSenderId": notificationSenderId
        },
        "to": token
      };

      final response = await http.post(Uri.parse(postUrl),
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void handleFcmMessage(RemoteMessage message) {
    final Map<String, dynamic> data = message.data;
    final String? carJson = data['car'];
    final String notificationSenderId = data['notificationSenderId'];

    if (carJson != null && carJson.isNotEmpty) {
      final Map<String, dynamic> carMap = jsonDecode(carJson);
      final Car car = Car.fromMap(carMap);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(GlobalVariable.navState.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => CarDetailsOverviewScreen(
              car: car,
              notificationSenderId: notificationSenderId,
            ),
          ),
        );
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(GlobalVariable.navState.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      });
    }
  }
}
