import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgramTab extends StatelessWidget {
  /// ✅ ابعت conferenceType: "cardio" أو "critical"
  final String conferenceType;

  /// ✅ لينكات Drive لكل مؤتمر
  final String cardioProgramUrl;
  final String criticalProgramUrl;

  const ProgramTab({
    Key? key,
    required this.conferenceType,
    required this.cardioProgramUrl,
    required this.criticalProgramUrl,
  }) : super(key: key);

  Future<void> _openProgramLink(BuildContext context, String url) async {
    if (url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No program link available'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final uri = Uri.parse(url);
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) throw Exception('Could not launch');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening link: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCardio = conferenceType == 'accc2026';

    final String programUrl = isCardio ? cardioProgramUrl : criticalProgramUrl;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.description_rounded,
                  size: 56,
                  color: isCardio ? const Color(0xFF344E75) : const Color(0xFF85af99),
                ),
                const SizedBox(height: 14),
                Text(
                  isCardio ? 'Cardio Conference Program' : 'Critical Care Program',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Open the official program PDF on Google Drive',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openProgramLink(context, programUrl),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text(
                      'View Program (PDF)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
