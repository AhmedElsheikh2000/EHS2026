import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTab extends StatefulWidget {
  const ContactTab({Key? key}) : super(key: key);

  @override
  State<ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Dr. John Smith');
  final _emailController = TextEditingController(text: 'john.smith@example.com');
  final _phoneController = TextEditingController(text: '+971 50 000 0000');
  final _subjectController = TextEditingController(text: 'Conference Registration Inquiry');
  final _messageController = TextEditingController(text: 'Please provide details about your inquiry...');

  String _preferredOffice = 'North Africa Office';

  // EHS Brand Colors
  static const Color primaryBlue = Color(0xFF344E75);
  static const Color secondaryGreen = Color(0xFF85af99);
  static const Color accentBlue = Color(0xFFb7d1da);
  static const Color lightGray = Color(0xFFF8FAFC);

  // Folder Group Social Links
  static const String _facebookUrl =
      'https://www.facebook.com/share/171eccWGqs/?mibextid=wwXIfr';
  static const String _instagramUrl =
      'https://www.instagram.com/foldermiddleeast?igsh=am5uYmNvaDFyMnk2';
  static const String _xUrl = 'https://x.com/FOLDERmiddleast';
  static const String _linkedinUrl =
      'https://www.linkedin.com/company/folder-group';
  static const String _tiktokUrl = 'https://www.tiktok.com/@folder_group';
  static const String _youtubeUrl = 'https://m.youtube.com/@FolderGroup';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open link: $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open phone dialer'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open email app'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      _phoneController.clear();
      _subjectController.clear();
      _messageController.clear();

      setState(() {
        _preferredOffice = 'North Africa Office';
      });
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

                    // ✅ Office Cards بدل cards القديمة
                    _buildOfficeCards(),

                    const SizedBox(height: 48),
                    _buildMainContent(),
                    const SizedBox(height: 48),
                    _buildNeedImmediateAssistance(),
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
          'Get in touch with the organizing team',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // =========================
  // ✅ Office Cards
  // =========================
  Widget _buildOfficeCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            children: [
              Expanded(child: _buildOfficeCard(isNorthAfrica: true)),
              const SizedBox(width: 24),
              Expanded(child: _buildOfficeCard(isNorthAfrica: false)),
            ],
          );
        } else {
          return Column(
            children: [
              _buildOfficeCard(isNorthAfrica: true),
              const SizedBox(height: 16),
              _buildOfficeCard(isNorthAfrica: false),
            ],
          );
        }
      },
    );
  }

  Widget _buildOfficeCard({required bool isNorthAfrica}) {
    final title = isNorthAfrica ? 'North Africa Office' : 'Gulf Office';
    final email = 'Info@foldergroup.com';
    final phone = isNorthAfrica ? '+20 10 97956307' : '+971 56 932 1297';
    final address = isNorthAfrica
        ? '142 Galal El-Desouky St., Wabour Al Meyah, Alexandria 21522, Egypt'
        : '303, WESTBURRY TOWER 1, BUSINESS BAY, DUBAI, UAE';
    final hours = isNorthAfrica
        ? 'Sun – Thu: 9:00 AM – 5:00 PM'
        : 'Sun – Thu: 9:00 AM – 6:00 PM';

    final Color color = isNorthAfrica ? primaryBlue : secondaryGreen;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isNorthAfrica ? Icons.location_city_rounded : Icons.apartment_rounded,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
              ),
              // optional logo (لو عندك asset)
              // Image.asset('assets/folder_logo.png', height: 26),
            ],
          ),

          const SizedBox(height: 18),

          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: email,
            onTap: () => _sendEmail(email),
            valueColor: primaryBlue,
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: phone,
            onTap: () => _callPhone(phone),
            valueColor: primaryBlue,
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: address,
            onTap: null,
            valueColor: Colors.black87,
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.access_time_rounded,
            label: 'Working Hours',
            value: hours,
            onTap: null,
            valueColor: Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback? onTap,
    required Color valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: onTap,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: onTap != null ? primaryBlue : valueColor,
                    fontWeight: onTap != null ? FontWeight.w600 : FontWeight.w500,
                    decoration: onTap != null ? TextDecoration.underline : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // Main Content: Form + Sidebar
  // =========================
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

  // ✅ Form updated: Full Name, Email, Phone, Preferred Office, Subject, Message
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
                  'Send Us a Message',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Please share your details and inquiry, and a member of the organizing team will get back to you shortly.',
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
            const SizedBox(height: 28),

            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Dr. John Smith',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'john.smith@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '+971 50 000 0000',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            _buildDropdownField(
              label: 'Preferred Office',
              value: _preferredOffice,
              items: const ['North Africa Office', 'Gulf Office'],
              onChanged: (val) => setState(() => _preferredOffice = val!),
              icon: Icons.apartment_rounded,
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: _subjectController,
              label: 'Subject',
              hint: 'Conference Registration Inquiry',
              icon: Icons.subject_rounded,
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: _messageController,
              label: 'Message',
              hint: 'Please provide details about your inquiry...',
              icon: Icons.message_outlined,
              maxLines: 5,
            ),
            const SizedBox(height: 28),

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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? icon,
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
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          decoration: InputDecoration(
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) return 'Please choose an office';
            return null;
          },
        ),
      ],
    );
  }

  // =========================
  // Sidebar
  // =========================
  Widget _buildSidebar() {
    return Column(
      children: [
        _buildOfficeHoursCard(),
        const SizedBox(height: 24),
        _buildSocialMediaFolder(),
      ],
    );
  }

  // ✅ Working Hours updated (Sun–Thu)
  Widget _buildOfficeHoursCard() {
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
            'Working Hours',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          _buildOfficeHourItem('North Africa Office', 'Sun – Thu: 9:00 AM – 5:00 PM'),
          const Divider(height: 24),
          _buildOfficeHourItem('Gulf Office', 'Sun – Thu: 9:00 AM – 6:00 PM'),
        ],
      ),
    );
  }

  Widget _buildOfficeHourItem(String office, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          office,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          time,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // ✅ Social Media Folder Group (Clickable)
  Widget _buildSocialMediaFolder() {
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
            'Folder Group Social Media',
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
            childAspectRatio: 2.6,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _socialBtn('Facebook', Icons.facebook, () => _openUrl(_facebookUrl)),
              _socialBtn('Instagram', Icons.camera_alt_rounded, () => _openUrl(_instagramUrl)),
              _socialBtn('X (Twitter)', Icons.close_rounded, () => _openUrl(_xUrl)),
              _socialBtn('LinkedIn', Icons.business_center_rounded, () => _openUrl(_linkedinUrl)),
              _socialBtn('TikTok', Icons.music_note_rounded, () => _openUrl(_tiktokUrl)),
              _socialBtn('YouTube', Icons.play_circle_fill_rounded, () => _openUrl(_youtubeUrl)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialBtn(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // Need Immediate Assistance
  // =========================
  Widget _buildNeedImmediateAssistance() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need Immediate Assistance?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'For urgent matters, please contact our offices directly during working hours. Our team will be happy to support you.',
            style: TextStyle(color: Colors.grey[700], height: 1.4),
          ),
          const SizedBox(height: 16),

          InkWell(
            onTap: () => _callPhone('+201097956307'),
            child: const Row(
              children: [
                Icon(Icons.phone, color: primaryBlue, size: 18),
                SizedBox(width: 8),
                Text(
                  'North Africa: +20 10 97956307',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => _callPhone('+971569321297'),
            child: const Row(
              children: [
                Icon(Icons.phone, color: primaryBlue, size: 18),
                SizedBox(width: 8),
                Text(
                  'Gulf: +971 56 932 1297',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // FAQ (زي ما هو بس خليته مناسب)
  // =========================
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
                            'How can I contact the organizing team?',
                            'Use the contact form above or call the office numbers during working hours.',
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
                            'What are the working hours?',
                            'Sun – Thu: 9:00 AM – 5:00 PM (North Africa) and 9:00 AM – 6:00 PM (Gulf).',
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildFAQItem(
                            'Which office should I choose?',
                            'Select the office closest to your region (North Africa or Gulf) so we can respond faster.',
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
                      'How can I contact the organizing team?',
                      'Use the contact form above or call the office numbers during working hours.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      'What are the working hours?',
                      'Sun – Thu: 9:00 AM – 5:00 PM (North Africa) and 9:00 AM – 6:00 PM (Gulf).',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      'Which office should I choose?',
                      'Select the office closest to your region (North Africa or Gulf) so we can respond faster.',
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
