import 'package:flutter/material.dart';
import 'package:p2p_renting_car_app/common/app_bar_widget.dart';
import 'package:p2p_renting_car_app/common/button_widget.dart';
import 'package:p2p_renting_car_app/common/constants.dart';
import 'package:p2p_renting_car_app/common/custom_textfield_widget.dart';
import 'package:p2p_renting_car_app/helpers/validator.dart';
import 'package:p2p_renting_car_app/screens/home/home_screen.dart';
import 'package:p2p_renting_car_app/services/firebase_authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final authService = FirebaseAuthService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void _submitForm() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      var message = await FirebaseAuthService().login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (message!.contains('Success')) {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => const HomeScreen()),
          ),
        );
      }

      sharedPreferences.setString('email', emailController.text);
      sharedPreferences.setString('password', passwordController.text);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Container(
        height: double.maxFinite,
        decoration: gradientBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/car.png',
                    scale: 2,
                  ),
                  gapH12,
                  Text(
                    'Login'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  CustomTextFieldWidget(
                      changeColors: true,
                      controller: emailController,
                      title: 'E-Mail',
                      validator: validation),
                  gapH16,
                  CustomTextFieldWidget(
                      changeColors: true,
                      isPasswordField: true,
                      controller: passwordController,
                      title: 'Password',
                      validator: validation),
                  gapH48,
                  ButtonWidget(
                    homeColor: true,
                    onPressed: _submitForm,
                    title: 'Login',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
