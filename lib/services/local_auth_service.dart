import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await _canAuthenticate()) return false;

      return await _auth.authenticate(
          localizedReason: 'Use biometrics to proceed to next screen.',
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true));
    } on PlatformException catch (e) {
      debugPrint('error $e');
      return false;
    }
  }
}
