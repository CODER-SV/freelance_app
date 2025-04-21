import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nescafe_flutter/Screens/login_screen.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import '../Constants.dart';
import 'loading_screen.dart';

class WelcomeScreenFirst extends StatefulWidget {
  static const String id = 'welcome_screen_first';
  @override
  _WelcomeScreenFirstState createState() => _WelcomeScreenFirstState();
}

class _WelcomeScreenFirstState extends State<WelcomeScreenFirst>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _logoController;
  late Animation<Color?> animation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool switchValue = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    animation = ColorTween(
      begin: Colors.white,
      end: const Color(0xff1C0F05),
    ).animate(_animationController);

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoController.forward().then((_) {
      _animationController.forward();
    });

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 120,
                    ),
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/images/logo2.png',
                        width: 318,
                        height: 200,
                      ),
                    ),
                  ),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: DefaultTextStyle.merge(
                  style: toggleTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.normal,
                  ),
                  child: IconTheme.merge(
                    data: const IconThemeData(color: Colors.white),
                    child: AnimatedToggleSwitch.dual(
                      current: switchValue,
                      first: false,
                      second: true,
                      spacing: 150,
                      animationDuration: const Duration(milliseconds: 600),
                      style: const ToggleStyle(
                        borderColor: Colors.transparent,
                        indicatorColor: Color(0xff1C0F05),
                        backgroundColor: Color(0xffD9D9D9),
                      ),
                      borderWidth: 15,
                      height: 64,
                      customStyleBuilder: (context, local, global) {
                        if (global.position <= 0) {
                          return const ToggleStyle(
                            backgroundColor: Color(0xff7C6565),
                          );
                        }
                        return ToggleStyle(
                          backgroundGradient: LinearGradient(
                            colors: [
                              const Color(0xffD9D9D9),
                              const Color(0xff7C6565),
                            ],
                            stops: [
                              global.position -
                                  (1 - 2 * max(0, global.position - 0.5)) * 0.7,
                              global.position +
                                  max(0, 2 * (global.position - 0.5)) * 0.7,
                            ],
                          ),
                        );
                      },
                      loadingIconBuilder:
                          (context, global) => CupertinoActivityIndicator(
                            color: Color.lerp(
                              const Color(0xffD9D9D9),
                              const Color(0xff7C6565),
                              global.position,
                            ),
                          ),
                      onChanged: (value) async {
                        HapticFeedback.lightImpact(); // subtle feedback
                        setState(() {
                          switchValue = value;
                        });

                        User? user = FirebaseAuth.instance.currentUser;

                        await Future.delayed(const Duration(milliseconds: 300));

                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 500,
                            ),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    user != null
                                        ? LoadingScreen()
                                        : LoginScreen(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              final curvedAnimation = CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              );
                              return FadeTransition(
                                opacity: curvedAnimation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.1),
                                    end: Offset.zero,
                                  ).animate(curvedAnimation),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );

                        await Future.delayed(const Duration(milliseconds: 600));

                        setState(() {
                          switchValue = false;
                        });
                      },
                      iconBuilder:
                          (value) => Icon(
                            value
                                ? Icons.arrow_back_ios_rounded
                                : Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                      textBuilder:
                          (value) => Text(
                            value ? 'GET STARTED' : 'GRAB IT NOW',
                            style: toggleTextStyle,
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
