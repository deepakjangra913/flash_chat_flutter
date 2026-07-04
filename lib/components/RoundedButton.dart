import 'package:flutter/material.dart';

class Roundedbutton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed()

  const Roundedbutton({super.key, required this.text, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: () {
            //Implement registration functionality.
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text('Register', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
