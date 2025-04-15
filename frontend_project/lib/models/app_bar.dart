/*import 'package:flutter/material.dart';

class CustomAppBar {
  // Constructor that takes the title text as a parameter
  final String titleText;
  final bool imply;

  CustomAppBar(this.imply, {required this.titleText});

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 33, 9, 78),
      automaticallyImplyLeading: imply,
      title: Align(
        alignment: const AlignmentDirectional(0, 0),
        child: Text(
          titleText,  // Use the passed title text here
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontSize: 35,
            letterSpacing: 0.0,
          ),
        ),
      ),
      elevation: 2,
    );
  }
}*/
import 'package:flutter/material.dart';

class CustomAppBar {
  final String titleText;
  final bool imply;
  final bool centerTitle;

  CustomAppBar(this.imply,this.centerTitle, {required this.titleText});


  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 33, 9, 78),
      automaticallyImplyLeading: imply,
      iconTheme: const IconThemeData(color: Colors.white), // Set back arrow color
      title: Text(
        titleText,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.white,
          fontSize: 35,
          letterSpacing: 0.0,
        ),
      ),
      centerTitle: centerTitle, // Use the centerTitle parameter
      elevation: 2,
    );
  }
}
