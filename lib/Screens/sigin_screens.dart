import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:nescafe_flutter/Screens/login_screen.dart';
import 'package:nescafe_flutter/Screens/sigin_screens.dart';
import 'package:nescafe_flutter/Constants.dart';
import 'package:nescafe_flutter/Components/roundedButton.dart';

bool svalue = true;
late String email;
late String password;

class SiginScreens extends StatefulWidget {
  static const String id = 'SiginScreen';
  const SiginScreens({super.key});

  @override
  State<SiginScreens> createState() => _SiginScreensState();
}

class _SiginScreensState extends State<SiginScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1C0F05),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
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
                Container(
                  height: 497,
                  width: 337,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(34)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
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
                      SizedBox(height: 60),
                      conti(),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 45.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/googlelogo.png',
                        width: 33,
                        height: 33,
                      ),
                      SizedBox(width: 15),
                      Image.asset(
                        'assets/images/facebook_logo.png',
                        width: 33,
                        height: 33,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60),
                Expanded(
                  child: Container(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class conti extends StatelessWidget {
  const conti({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: 292,
            height: 47,
            decoration: kboxDecoration,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldInputDecoration.copyWith(
                hintText: 'Enter your email',
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 292,
            height: 47,
            decoration: kboxDecoration,
            child: TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldInputDecoration.copyWith(
                hintText: 'Enter your Password',
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: 292,
            height: 47,
            decoration: kboxDecoration,
            child: TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldInputDecoration.copyWith(
                hintText: 'Confirm your Password',
              ),
            ),
          ),
          SizedBox(height: 100),
          RoundedButton(
            text: 'Sign up',
            colour: Color(0xff5F4B48),
            textColour: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
