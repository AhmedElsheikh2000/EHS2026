import 'package:flutter/material.dart';

class ConferenceListScreen extends StatelessWidget {
  const ConferenceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conferences"),
        backgroundColor: const Color(0xFF004B99), // CardioEHS Blue
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event,
              size: 80,
              color: Color(0xFF004B99),
            ),
            SizedBox(height: 20),
            Text(
              "Conference List Page",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Coming Soon",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF7F8C8D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}