import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  Carousel({required this.text, required this.colour, required this.onPressed});

  final String text;
  final Color colour;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(6.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 74,
          height: 0,
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Kanit',
                fontStyle: FontStyle.normal,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
