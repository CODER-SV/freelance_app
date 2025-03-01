import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nescafe_flutter/Screens/home_screen.dart';
import 'package:nescafe_flutter/Screens/login_screen.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class WelcomeScreenFirst extends StatefulWidget {
  static const String id = 'welcome_screen_first';
  @override
  _WelcomeScreenFirstState createState() => _WelcomeScreenFirstState();
}

class _WelcomeScreenFirstState extends State<WelcomeScreenFirst>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  AnimationController? controller;
  Animation? animation;
  bool switchValue = false;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Animation duration
    );

    // Define the fade animation
    animation = ColorTween(
      begin: Colors.white,
      end: Color(0xff1C0F05),
    ).animate(controller as Animation<double>);
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start the animation
    _animationController.forward();
    controller?.forward();
    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation?.value,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 200,
                  bottom: 200,
                  left: 60,
                  right: 60,
                ),
                child: FadeTransition(
                  opacity:
                      _fadeAnimation, // Use the fade animation for the logo
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo2.png', // Your logo
                      width: 318,
                      height: 200,
                    ),
                  ),
                ),
              ),
              Container(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.normal,
                    ),
                    child: IconTheme.merge(
                      data: IconThemeData(color: Colors.white),
                      child: AnimatedToggleSwitch.dual(
                        current: switchValue,
                        first: false,
                        second: true,
                        spacing: 150,
                        animationDuration: Duration(milliseconds: 600),
                        style: const ToggleStyle(
                          borderColor: Colors.transparent,
                          indicatorColor: Color(0xff1C0F05),
                          backgroundColor: Color(0xffD9D9D9),
                        ),
                        borderWidth: 15,
                        height: 64,
                        customStyleBuilder: (context, local, global) {
                          if (global.position <= 0) {
                            return ToggleStyle(
                              backgroundColor: Color(0xffD9D9D9),
                            );
                          }
                          return ToggleStyle(
                            backgroundGradient: LinearGradient(
                              colors: [Color(0xff7C6565), Color(0xffD9D9D9)!],
                              stops: [
                                global.position -
                                    (1 - 2 * max(0, global.position - 0.5)) *
                                        0.7,
                                global.position +
                                    max(0, 2 * (global.position - 0.5)) * 0.7,
                              ],
                            ),
                          );
                        },
                        loadingIconBuilder:
                            (context, global) => CupertinoActivityIndicator(
                              color: Color.lerp(
                                Color(0xffD9D9D9),
                                Color(0xff7C6565),
                                global.position,
                              ),
                            ),
                        onChanged: (value) async {
                          setState(() {
                            switchValue = value;
                          });

                          // Check Firebase Authentication State
                          User? user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            // User is already logged in, go to HomeScreen
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(seconds: 2),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        HomeScreen(),
                              ),
                            );
                          } else {
                            // User not logged in, go to LoginScreen
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(seconds: 2),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        LoginScreen(),
                              ),
                            );
                          }

                          setState(() {
                            switchValue = false;
                          });
                        },
                        iconBuilder:
                            (value) =>
                                value
                                    ? Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: Colors.white,
                                    )
                                    : Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                    ),
                        textBuilder:
                            (value) =>
                                value
                                    ? Text(
                                      'GET STARTED',
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontStyle: FontStyle.normal,
                                      ),
                                    )
                                    : Text(
                                      'GRAB IT NOW',
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
