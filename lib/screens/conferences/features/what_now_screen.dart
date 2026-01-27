import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatNowScreen extends StatelessWidget {
  const WhatNowScreen({super.key});

  // Links
  static const String cardioUrl = 'https://cardioehs.ae.org/registration';
  static const String criticalUrl = 'https://iccod.ae.org/registration';

  Future<void> _openLink(BuildContext context, String url) async {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF344E75),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Registration',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            // Header Card
            _HeaderCard(),

            const SizedBox(height: 16),

            // Two big buttons
            _ConferenceButtonCard(
              title: 'CardioEHS 2026',
              subtitle: 'Cardiovascular Medicine Conference',
              color1: const Color(0xFF344E75),
              color2: const Color(0xFF4A6B8A),
              icon: Icons.favorite_rounded,
              buttonText: 'Register for Cardio',
              onTap: () => _openLink(context, cardioUrl),
              urlText: cardioUrl,
            ),

            const SizedBox(height: 14),

            _ConferenceButtonCard(
              title: 'ICCOD 2026',
              subtitle: 'Critical Care & Organ Donation Conference',
              color1: const Color(0xFF85AF99),
              color2: const Color(0xFF4E8B73),
              icon: Icons.emergency_rounded,
              buttonText: 'Register for Critical Care',
              onTap: () => _openLink(context, criticalUrl),
              urlText: criticalUrl,
            ),

            const SizedBox(height: 18),

            // Benefits sections
            _SectionTitle(title: 'Why Register?'),

            const SizedBox(height: 10),

            _BenefitsCard(
              title: 'Critical Care Benefits',
              accent: const Color(0xFF4E8B73),
              items: const [
                BenefitItem(
                  title: 'Access',
                  desc:
                      'The best-in-class program in Critical Care delivered by experts in the field',
                ),
                BenefitItem(
                  title: 'Learn',
                  desc:
                      'New frameworks and skills that can be implemented in your practice',
                ),
                BenefitItem(
                  title: 'Experience',
                  desc: 'Incredible networking opportunities',
                ),
                BenefitItem(
                  title: 'Ask',
                  desc: 'Questions, challenge thinking',
                ),
                BenefitItem(
                  title: 'Join',
                  desc:
                      'A community of change makers working to build a better world',
                ),
                BenefitItem(
                  title: 'Advance',
                  desc:
                      'Enhance your professional growth and stay ahead in critical care practice',
                ),
              ],
            ),

            const SizedBox(height: 14),

            _BenefitsCard(
              title: 'Cardio Benefits',
              accent: const Color(0xFF344E75),
              items: const [
                BenefitItem(
                  title: 'Access',
                  desc:
                      'The best-in-class program in Cardiovascular Medicine delivered by world-renowned cardiologists and experts',
                ),
                BenefitItem(
                  title: 'Learn',
                  desc:
                      'Latest advances in cardiac care, innovative treatments, and evidence-based practices you can implement immediately',
                ),
                BenefitItem(
                  title: 'Experience',
                  desc:
                      'Incredible networking opportunities with leading cardiologists and cardiovascular specialists',
                ),
                BenefitItem(
                  title: 'Ask',
                  desc:
                      'Questions to international faculty, challenge thinking, and engage in interactive case discussions',
                ),
                BenefitItem(
                  title: 'Join',
                  desc:
                      'A community of cardiovascular pioneers working to improve cardiac care and patient outcomes',
                ),
                BenefitItem(
                  title: 'Advance',
                  desc:
                      'Your professional growth, earn CME credits, and stay ahead in cardiovascular medicine practice',
                ),
              ],
            ),

            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF344E75), Color(0xFF4A6B8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF344E75).withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.how_to_reg_rounded, color: Colors.white, size: 34),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Choose your conference and complete your registration online.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConferenceButtonCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color1;
  final Color color2;
  final IconData icon;
  final String buttonText;
  final VoidCallback onTap;
  final String urlText;

  const _ConferenceButtonCard({
    required this.title,
    required this.subtitle,
    required this.color1,
    required this.color2,
    required this.icon,
    required this.buttonText,
    required this.onTap,
    required this.urlText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color1, color2]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.open_in_new_rounded),
              label: Text(
                buttonText,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color1,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // url small
          Text(
            urlText,
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFF344E75),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }
}

class BenefitItem {
  final String title;
  final String desc;
  const BenefitItem({required this.title, required this.desc});
}

class _BenefitsCard extends StatelessWidget {
  final String title;
  final Color accent;
  final List<BenefitItem> items;

  const _BenefitsCard({
    required this.title,
    required this.accent,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((e) => _BenefitRow(accent: accent, item: e)).toList(),
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final Color accent;
  final BenefitItem item;

  const _BenefitRow({required this.accent, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, color: accent, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.35,
                  color: Color(0xFF2C3E50),
                ),
                children: [
                  TextSpan(
                    text: '${item.title}: ',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: item.desc,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
