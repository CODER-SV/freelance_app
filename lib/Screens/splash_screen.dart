import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:nescafe_flutter/Screens/welcome_screen_first.dart';
import 'welcome_screen_first.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _gifOpacity = 1.0; // Start with full opacity for the GIF

  @override
  void initState() {
    super.initState();

    // Fade out the GIF after 2 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _gifOpacity = 0.0; // Fade out the GIF
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: AnimatedOpacity(
        opacity: _gifOpacity, // Fade out effect
        duration: Duration(seconds: 2),
        child: Transform.scale(
          scale: 1.5, // Set the scale factor here (1.5 means 1.5x the size)
          child: Image.asset('assets/nescafe_animation.gif'), // Your GIF
        ),
      ),
      splashIconSize: 2000.0,
      centered: true,
      nextScreen:
          WelcomeScreenFirst(), // Navigate to the next screen after splash
      backgroundColor: Colors.white,
      duration: 4000,
      splashTransition:
          SplashTransition.fadeTransition, // Fade transition for splash
    );
  }
}
