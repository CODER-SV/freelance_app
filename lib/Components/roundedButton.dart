import 'package:flutter/material.dart';

class RoundedButton extends StatefulWidget {
  final String text;
  final Color colour;
  final Future<void> Function() onPressed; // Updated type
  final Color textColour;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.colour,
    required this.textColour,
    required this.onPressed,
  }) : super(key: key);

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  bool _isLoading = false;

  void _handlePress() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await widget.onPressed(); // Now await is valid
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: widget.colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: _handlePress,
          minWidth: 125.0,
          height: 42.0,
          child:
              _isLoading
                  ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.textColour,
                      ),
                      strokeWidth: 2.5,
                    ),
                  )
                  : Text(
                    widget.text,
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontStyle: FontStyle.normal,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.textColour,
                    ),
                  ),
        ),
      ),
    );
  }
}
