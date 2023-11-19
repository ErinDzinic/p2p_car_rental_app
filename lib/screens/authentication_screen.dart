import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p2p_renting_car_app/common/bubble.dart';
import 'package:p2p_renting_car_app/common/button_widget.dart';
import 'package:p2p_renting_car_app/common/constants.dart';
import 'package:p2p_renting_car_app/providers/shared_preferences_provider.dart';
import 'package:p2p_renting_car_app/screens/home/home_screen.dart';
import 'package:p2p_renting_car_app/screens/login_screen.dart';
import 'package:p2p_renting_car_app/screens/register_screen.dart';
import 'package:p2p_renting_car_app/services/firebase_authentication_service.dart';
import 'package:p2p_renting_car_app/services/local_auth_service.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  bool authenticated = false;
  bool alreadyHasAccount = false;
  bool firebaseAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    var prefs = ref.watch(sharedPreferencesProvider);
    var email = prefs.getString('email');
    var password = prefs.getString('password');
    alreadyHasAccount = email != null && password != null ? true : false;

    return !authenticated && !firebaseAuthenticated
        ? Container(
            decoration: gradientBoxDecoration(),
            child: Stack(
              children: [
                const Bubble(top: -50, left: -50),
                const Bubble(top: 0, left: 280),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Image.asset(
                        'assets/images/car.png',
                        scale: 2,
                      ),
                      gapH16,
                      Text(
                        'Welcome to Car - Rental'.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      ButtonWidget(
                        title: 'Login',
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => const LoginScreen())));
                        },
                      ),
                      gapH20,
                      alreadyHasAccount
                          ? ButtonWidget(
                              title: 'Fast-Login',
                              onPressed: () async {
                                await LocalAuth.authenticate()
                                    .then((value) async {
                                  var message = await FirebaseAuthService()
                                      .login(
                                          email: email!, password: password!);
                                  if (message!.contains('Success')) {
                                    setState(() {
                                      authenticated = true;
                                      firebaseAuthenticated = true;
                                    });
                                  }
                                });
                              },
                            )
                          : Container(),
                      gapH20,
                      ButtonWidget(
                        title: 'Register',
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                        },
                      ),
                      gapH24,
                      const Text(
                        'Copyright. All rights reserved, 2023.',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: Sizes.p12,
                            color: Colors.grey),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const HomeScreen();
  }
}
