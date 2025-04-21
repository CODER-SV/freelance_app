import 'dart:async';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nescafe_flutter/Constants.dart';
import 'package:nescafe_flutter/Components/roundedButton.dart';
import 'package:nescafe_flutter/Screens/loading_screen.dart';

bool svalue = false;
late String phoneNumber;
late var code;

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1, milliseconds: 500), // Animation duration
    );

    // Define the fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff1C0F05),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding:
                  screenHeight < 900
                      ? EdgeInsets.only(top: 0)
                      : EdgeInsets.only(top: 70),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/images/logo2.png',
                        width: 135,
                        height: 42,
                      ),
                    ),
                    SizedBox(height: 40),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        height: 497,
                        width: 380,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(34)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: AnimatedToggleSwitch<bool>.size(
                                  current: svalue,
                                  values: [false, true],
                                  iconOpacity: 0.2,
                                  indicatorSize: const Size.fromWidth(100),
                                  customIconBuilder:
                                      (context, local, global) => Text(
                                        local.value ? 'SignUp' : 'Login',
                                        style: TextStyle(
                                          fontFamily: 'Katin',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Color.lerp(
                                            Colors.black,
                                            Colors.white,
                                            local.animationValue,
                                          ),
                                        ),
                                      ),
                                  borderWidth: 5.0,
                                  height: 43,
                                  iconAnimationType: AnimationType.onHover,
                                  style: ToggleStyle(
                                    indicatorColor: Color(0xff5F4B48),
                                    borderColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      const BoxShadow(
                                        color: Colors.black26,
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  selectedIconScale: 1.0,
                                  onChanged: (value) {
                                    setState(() {
                                      svalue = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 60),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: _hoverFunction(svalue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(padding: const EdgeInsets.only(right: 45.0)),
                    SizedBox(height: screenHeight < 900 ? 93 : 93),
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: Color(0xff7C6565),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'By continuing,you agree to our\nTerms of Conditions,Privacy policy,Promotion T&C\nNutrition Information',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _hoverFunction extends StatefulWidget {
  late final bool isSign;
  _hoverFunction(this.isSign);

  @override
  State<_hoverFunction> createState() => _hoverFunctionState();
}

class _hoverFunctionState extends State<_hoverFunction> {
  void showEmailVerificationDialog(BuildContext context, User user) {
    bool isChecking = false;
    bool isResending = false;
    int resendCooldown = 0;
    Timer? cooldownTimer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Start cooldown timer from within the StatefulBuilder
            void startCooldown() {
              resendCooldown = 30;
              cooldownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                if (resendCooldown > 0) {
                  setState(() {
                    resendCooldown--;
                  });
                } else {
                  timer.cancel();
                }
              });
            }

            return AlertDialog(
              title: Text("Verify your Email"),
              content: Text(
                "A verification email has been sent to ${user.email}. Please verify it, then click below to proceed.",
              ),
              actions: [
                TextButton(
                  onPressed:
                      isChecking
                          ? null
                          : () async {
                            setState(() {
                              isChecking = true;
                            });

                            await user.reload();
                            final refreshedUser =
                                FirebaseAuth.instance.currentUser;

                            if (refreshedUser != null &&
                                refreshedUser.emailVerified) {
                              Navigator.of(dialogContext).pop();
                              Navigator.pushReplacement(
                                dialogContext,
                                MaterialPageRoute(
                                  builder: (context) => LoadingScreen(),
                                ),
                              );
                            } else {
                              setState(() {
                                isChecking = false;
                              });
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(
                                  content: Text("Email not verified yet!"),
                                ),
                              );
                            }
                          },
                  child: Text(isChecking ? "Checking..." : "I have verified"),
                ),
                TextButton(
                  onPressed:
                      (resendCooldown > 0 || isResending)
                          ? null
                          : () async {
                            setState(() {
                              isResending = true;
                            });

                            await user.sendEmailVerification();

                            setState(() {
                              isResending = false;
                            });

                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                content: Text("Verification email resent!"),
                              ),
                            );

                            startCooldown();
                          },
                  child: Text(
                    isResending
                        ? "Resending..."
                        : resendCooldown > 0
                        ? "Resend Email (${resendCooldown}s)"
                        : "Resend Email",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  final _auth = FirebaseAuth.instance;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  late String email;
  late String password;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant _hoverFunction oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When switching between Login and SignUp, reset the email and password fields
    if (widget.isSign != oldWidget.isSign) {
      emailController.clear(); // Clear email field
      passwordController.clear(); // Clear password field
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 292,
          height: 47,
          decoration: kboxDecoration,
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            onChanged: (value) {
              email = value;
            },
            decoration: kTextFieldInputDecoration.copyWith(
              hintText: 'Enter your Email',
            ),
          ),
        ),
        SizedBox(height: 20),

        Container(
          width: 292,
          height: 47,
          decoration: kboxDecoration,
          child: TextField(
            controller: passwordController,
            textAlign: TextAlign.center,
            obscureText: true,
            onChanged: (value1) {
              password = value1;
            },
            decoration: kTextFieldInputDecoration.copyWith(
              hintText: 'Enter your Password',
            ),
          ),
        ),

        SizedBox(height: 15),
        widget.isSign
            ? Container(
              height: 47,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                'Minimum password length should be 6',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 9,
                  fontFamily: 'Kanit',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w100,
                ),
              ),
            )
            : GestureDetector(
              onTap: () async {
                if (emailController.text.isEmpty ||
                    !emailController.text.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Please enter a valid email address first.",
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await _auth.sendPasswordResetEmail(
                    email: emailController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Password reset email sent! Check your inbox.",
                      ),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.message}")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Something went wrong. Try again.")),
                  );
                }
              },
              child: Text(
                'Forget your Password?',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

        SizedBox(height: widget.isSign ? 100 : 130),
        RoundedButton(
          text: widget.isSign ? 'Sign up' : 'Login',
          colour: Color(0xff5F4B48),
          textColour: Colors.white,
          onPressed: () async {
            if (widget.isSign) {
              try {
                final userCredential = await _auth
                    .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                final user = userCredential.user;

                if (user != null && !user.emailVerified) {
                  await user.sendEmailVerification();
                  showEmailVerificationDialog(context, user);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Account already exists! Try logging in instead.",
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } else if (e.code == 'weak-password') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Weak password. Please choose a stronger one.",
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } else if (e.code == 'invalid-email') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Invalid email format."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Signup failed: ${e.message}"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Something went wrong: $e"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            } else {
              try {
                final userCredential = await _auth.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                final user = userCredential.user;

                if (user != null) {
                  if (!user.emailVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Please verify your email before logging in.",
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(seconds: 2),
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              LoadingScreen(),
                    ),
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("No user found with this email."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } else if (e.code == 'wrong-password') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Incorrect password."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Login failed: ${e.message}"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Something went wrong: $e"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }
            ;
          },
        ),
      ],
    );
  }
}
