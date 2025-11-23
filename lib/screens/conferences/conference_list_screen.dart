import 'package:flutter/material.dart';

class ConferenceListScreen extends StatelessWidget {
  const ConferenceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conferences")),
      body: const Center(child: Text("Conference List Page")),
    );
  }
}
