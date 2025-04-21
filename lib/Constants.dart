import 'package:flutter/material.dart';

const kTextFieldInputDecoration = InputDecoration(
  hintText: 'Enter your value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

var kboxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(32.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black26,
      // Shadow color with transparency
      spreadRadius: 1, // How far the shadow spreads
      blurRadius: 2, // Softness of the shadow
      offset: Offset(0, 5), // Offset of the shadow (x, y)
    ),
  ],

  // Match the borderRadius of the TextField
);

const kDivider = Divider(
  color: Colors.black,
  height: 10,
  thickness: 0.5,
  indent: 35,
  endIndent: 35,
);
const toggleTextStyle = TextStyle(
  fontFamily: 'Kanit',
  fontStyle: FontStyle.normal,
);
const Color backgroundDark = Color(0xff1C0F05);

const TextStyle loadingTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.white70,
  fontFamily: 'Kanit',
  fontWeight: FontWeight.w300,
);
