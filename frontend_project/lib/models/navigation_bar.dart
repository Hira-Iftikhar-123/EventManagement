import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  final List<NavigationDestination> destinations; // Takes different sections (icons and labels)
  final List<Widget> pages; // Different pages for each section
  final Color? indicatorColor; // Custom indicator color
  final Color? backgroundColor; // Custom background color
  final Color? borderColor; // Custom border color
  final double? borderWidth; // Custom border width

  const CustomNavigationBar({
    super.key,
    required this.destinations,
    required this.pages,
    this.indicatorColor = const Color.fromARGB(255, 33, 9, 78),
    this.backgroundColor = const Color.fromARGB(255, 19, 17, 17),
    this.borderColor = const Color.fromARGB(255, 33, 9, 78),
    this.borderWidth = 2.0, required MaterialAccentColor selectedItemColor, required MaterialColor unselectedItemColor,
  }) : assert(destinations.length == pages.length, "Destinations and pages must match in length");

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: widget.borderColor!, // Dynamic border color
              width: widget.borderWidth!, // Dynamic border thickness
            ),
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: widget.indicatorColor, // Dynamic indicator color
          backgroundColor: widget.backgroundColor, // Dynamic background color
          selectedIndex: currentPageIndex,
          destinations: widget.destinations, // Dynamic destinations
        ),
      ),
      body: widget.pages[currentPageIndex], // Show the corresponding page
    );
  }
}
