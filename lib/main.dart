import 'package:flutter/material.dart';
import 'package:nescafe_flutter/Screens/cart_screen.dart';
import 'package:nescafe_flutter/Screens/customisation_screen.dart';
import 'package:nescafe_flutter/Screens/home_screen.dart';
import 'package:nescafe_flutter/Screens/sigin_screens.dart';
import 'package:nescafe_flutter/Screens/splash_screen.dart';
import 'package:nescafe_flutter/Screens/welcome_screen_first.dart';
import 'package:nescafe_flutter/Screens/login_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreenFirst.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        WelcomeScreenFirst.id: (context) => WelcomeScreenFirst(),
        LoginScreen.id: (context) => LoginScreen(),
        SiginScreens.id: (context) => SiginScreens(),
        HomeScreen.id: (context) => HomeScreen(),
        CustomisationScreen.id: (context) => CustomisationScreen(),
        CartScreen.id: (context) => CartScreen(),
      },
    );
  }
}
