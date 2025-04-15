import '../screens/queries_display.dart';
import '../../userPages/Attendee/attendee_feedback.dart';
import '../../userPages/Attendee/attendee_registered.dart';
import '../../userPages/Support/support_marketing.dart';
import 'package:flutter/material.dart';

class GlossyButtonsPage extends StatelessWidget {
  final String b1;
  final String b2;
  final String user;
  final String email;
  const GlossyButtonsPage(this.b1, this.b2, this.user, this.email, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: const Text('Glossy Buttons'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              if (user == 'attendee')
                _buildGlossyButton(
                  label: '      View\n Registered\n     Events',
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  RegisteredEvents(email: email),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),
              _buildGlossyButton(
                label: b1,
                color: Colors.orangeAccent,
                onPressed: () {
                  if (user == 'attendee') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FeedbackPage(),
                      ),
                    );
                  } else if (user == 'support') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Marketing(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildGlossyButton(
                label: b2,
                color: Colors.greenAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QueryAll(userType: user, email: email),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlossyButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 220,
        height: 170,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
              color.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(1, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
