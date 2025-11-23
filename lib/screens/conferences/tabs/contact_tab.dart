import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactTab extends StatefulWidget {
  const ContactTab({Key? key}) : super(key: key);

  @override
  State<ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  // EHS Brand Colors
  static const Color primaryBlue = Color(0xFF344E75);
  static const Color secondaryGreen = Color(0xFF85af99);
  static const Color accentBlue = Color(0xFFb7d1da);
  static const Color lightGray = Color(0xFFF8FAFC);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: primaryBlue,
        ),
      );
      // Clear form
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      body: Stack(
        children: [
          // Geometric Pattern Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(
                painter: GeometricPatternPainter(),
              ),
            ),
          ),
          
          // Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 48),
                    _buildContactCards(),
                    const SizedBox(height: 48),
                    _buildMainContent(),
                    const SizedBox(height: 48),
                    _buildFAQSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 96,
          height: 4,
          decoration: BoxDecoration(
            color: secondaryGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Get in touch with the EHS Conferences team',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildContactCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            children: [
              Expanded(child: _buildContactCard(
                icon: Icons.phone,
                title: 'Phone',
                content: '+971 4 6650000',
                subtitle: 'Mon-Fri: 8:00 AM - 5:00 PM',
                color: primaryBlue,
              )),
              const SizedBox(width: 24),
              Expanded(child: _buildContactCard(
                icon: Icons.email,
                title: 'Email',
                content: 'conferences@ehs.gov.ae',
                subtitle: "We'll respond within 24 hours",
                color: secondaryGreen,
              )),
              const SizedBox(width: 24),
              Expanded(child: _buildContactCard(
                icon: Icons.location_on,
                title: 'Location',
                content: 'Dubai, United Arab Emirates',
                subtitle: 'P.O. BOX 2299',
                color: accentBlue,
              )),
            ],
          );
        } else {
          return Column(
            children: [
              _buildContactCard(
                icon: Icons.phone,
                title: 'Phone',
                content: '+971 4 6650000',
                subtitle: 'Mon-Fri: 8:00 AM - 5:00 PM',
                color: primaryBlue,
              ),
              const SizedBox(height: 16),
              _buildContactCard(
                icon: Icons.email,
                title: 'Email',
                content: 'conferences@ehs.gov.ae',
                subtitle: "We'll respond within 24 hours",
                color: secondaryGreen,
              ),
              const SizedBox(height: 16),
              _buildContactCard(
                icon: Icons.location_on,
                title: 'Location',
                content: 'Dubai, United Arab Emirates',
                subtitle: 'P.O. BOX 2299',
                color: accentBlue,
              ),
            ],
          );
        }
      },
    );
  }

 Widget _buildContactCard({
  required IconData icon,
  required String title,
  required String content,
  required String subtitle,
  required Color color,
}) {
  return Container(
    width: double.infinity, // ✅ ياخد عرض الشاشة كله
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border(left: BorderSide(color: color, width: 6)), // ✅ خط جانبي ملون
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05), // ✅ لازم جوة BoxShadow
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    padding: const EdgeInsets.all(20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // أيقونة الكارت
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(width: 16),

        // النصوص
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  Widget _buildMainContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _buildContactForm(),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: _buildSidebar(),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              _buildContactForm(),
              const SizedBox(height: 24),
              _buildSidebar(),
            ],
          );
        }
      },
    );
  }

  Widget _buildContactForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryBlue, Color(0xFF4a6a95)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Send us a Message',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'your.email@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _subjectController,
              label: 'Subject',
              hint: 'What is this regarding?',
              icon: null,
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _messageController,
              label: 'Message',
              hint: 'Tell us more about your inquiry...',
              icon: Icons.message_outlined,
              maxLines: 5,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Send Message',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        _buildQuickLinks(),
        const SizedBox(height: 24),
        _buildOfficeHours(),
        const SizedBox(height: 24),
        _buildSocialMedia(),
      ],
    );
  }

  Widget _buildQuickLinks() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryBlue, Color(0xFF4a6a95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Links',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickLinkItem(Icons.language, 'www.ehs.gov.ae'),
          const SizedBox(height: 12),
          _buildQuickLinkItem(Icons.email, 'Support Portal'),
          const SizedBox(height: 12),
          _buildQuickLinkItem(Icons.phone, 'Emergency Line'),
        ],
      ),
    );
  }

  Widget _buildQuickLinkItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildOfficeHours() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Office Hours',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          _buildOfficeHourItem('Monday - Thursday', '8:00 AM - 5:00 PM'),
          const Divider(height: 24),
          _buildOfficeHourItem('Friday', '8:00 AM - 12:00 PM'),
          const Divider(height: 24),
          _buildOfficeHourItem('Saturday - Sunday', 'Closed', isRed: true),
        ],
      ),
    );
  }

  Widget _buildOfficeHourItem(String day, String time, {bool isRed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            color: isRed ? Colors.red : Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialMedia() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [secondaryGreen, Color(0xFFa5cfb9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Follow Us',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildSocialButton('Twitter'),
              _buildSocialButton('LinkedIn'),
              _buildSocialButton('Facebook'),
              _buildSocialButton('Instagram'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '@EHSUAE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String platform) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          platform,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 700) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildFAQItem(
                            'How do I register for a conference?',
                            'Visit the conference details page and click on the registration button to complete your registration.',
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildFAQItem(
                            'What is the cancellation policy?',
                            'Please contact us at least 48 hours before the event for cancellation or rescheduling requests.',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildFAQItem(
                            'Are the conferences certified?',
                            'Yes, all our conferences provide official certificates upon completion.',
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildFAQItem(
                            'Can I attend virtually?',
                            'Many of our conferences offer virtual attendance options. Check the conference details for availability.',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildFAQItem(
                      'How do I register for a conference?',
                      'Visit the conference details page and click on the registration button to complete your registration.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      'What is the cancellation policy?',
                      'Please contact us at least 48 hours before the event for cancellation or rescheduling requests.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      'Are the conferences certified?',
                      'Yes, all our conferences provide official certificates upon completion.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      'Can I attend virtually?',
                      'Many of our conferences offer virtual attendance options. Check the conference details for availability.',
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryBlue,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Geometric Pattern
class GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF344E75)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final spacing = 50.0;
    
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawLine(
          Offset(x, y),
          Offset(x + spacing, y),
          paint,
        );
        canvas.drawLine(
          Offset(x, y),
          Offset(x, y + spacing),
          paint,
        );
        canvas.drawCircle(Offset(x, y), 1, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}