import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nescafe_flutter/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:nescafe_flutter/Screens/cart_screen.dart';
import 'package:nescafe_flutter/Screens/customisation_screen.dart';
import 'package:nescafe_flutter/Screens/home_screen.dart';
import 'package:nescafe_flutter/Screens/sigin_screens.dart';
import 'package:nescafe_flutter/Screens/splash_screen.dart';
import 'package:nescafe_flutter/Screens/welcome_screen_first.dart';
import 'package:nescafe_flutter/Screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
      ),
    );
  }
}
