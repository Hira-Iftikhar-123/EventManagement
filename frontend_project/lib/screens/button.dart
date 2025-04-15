import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 65),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        backgroundColor: const Color.fromARGB(255, 33, 9, 78),
        // Button background color
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        // Text color (white)
        textStyle: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20,
          letterSpacing: 0.4,
        ),
        elevation: 0,
        side: const BorderSide(
          color: Color.fromARGB(255, 189, 197, 36), // Border color
          width: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Border radius
        ),
      ),
      child: Text(buttonText),
    );
  }
}