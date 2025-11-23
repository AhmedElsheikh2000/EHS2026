import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class BadgeScreen extends StatefulWidget {
  final String attendeeName;
  final String phoneNumber;
  final String email;
  final String organization;
  final String role;
  final String conferenceId;

  const BadgeScreen({
    Key? key,
    required this.attendeeName,
    required this.phoneNumber,
    this.email = '',
    this.organization = '',
    this.role = '',
    this.conferenceId = '',
  }) : super(key: key);

  @override
  State<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // EHS Brand Colors
  static const Color primaryBlue = Color(0xFF344E75);
  static const Color secondaryGray = Color(0xFF6F6C6F);
  static const Color accentGreen = Color(0xFF395940);
  static const Color lightBlue = Color(0xFFB7D1DA);
  static const Color successGreen = Color(0xFF85af99);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _generateVCard() {
    return '''BEGIN:VCARD
VERSION:3.0
FN:${widget.attendeeName}
TEL;TYPE=CELL:${widget.phoneNumber}
EMAIL:${widget.email}
ORG:${widget.organization}
TITLE:${widget.role}
NOTE:EHS Conference ${widget.conferenceId}
END:VCARD''';
  }

  Future<void> _saveContact() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        final Contact contact = Contact(
          name: Name(first: widget.attendeeName.split(' ').first, 
                     last: widget.attendeeName.split(' ').length > 1 
                         ? widget.attendeeName.split(' ').last 
                         : ''),
          phones: [Phone(widget.phoneNumber, label: PhoneLabel.mobile)],
          emails: widget.email.isNotEmpty 
            ? [Email(widget.email, label: EmailLabel.work)] 
            : [],
          organizations: widget.organization.isNotEmpty
            ? [Organization(company: widget.organization, title: widget.role)]
            : [],
          notes: [Note('EHS Conference ${widget.conferenceId}')],
        );

        await FlutterContacts.insertContact(contact);
        _showSuccessSnackBar('Contact saved successfully! 📱');
      } else {
        _showErrorSnackBar('Permission denied to access contacts');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving contact: $e');
    }
  }

  Future<void> _shareContact() async {
    try {
      final String vCard = _generateVCard();
      await Share.share(
        vCard,
        subject: 'Contact: ${widget.attendeeName}',
      );
    } catch (e) {
      _showErrorSnackBar('Error sharing contact: $e');
    }
  }

  void _copyPhoneNumber() {
    Clipboard.setData(ClipboardData(text: widget.phoneNumber));
    _showSuccessSnackBar('Phone number copied! 📋');
  }

  Future<void> _callPhoneNumber() async {
    final Uri launchUri = Uri(scheme: 'tel', path: widget.phoneNumber);
    
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showErrorSnackBar('Cannot make phone calls');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  Future<void> _sendEmail() async {
    if (widget.email.isEmpty) return;
    
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: widget.email);
    
    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        _showErrorSnackBar('Cannot open email client');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 15))),
          ],
        ),
        backgroundColor: successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 15))),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        title: const Text(
          'Digital Badge',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.ios_share_rounded),
              tooltip: 'Share Contact',
              onPressed: _shareContact,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Modern Header with gradient
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryBlue, accentGreen],
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 25,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'EHS',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: primaryBlue,
                                letterSpacing: 4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'EMIRATES HEALTH SERVICES',
                              style: TextStyle(
                                fontSize: 9,
                                color: secondaryGray.withOpacity(0.8),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'مؤسسة الإمارات للخدمات الصحية',
                              style: TextStyle(
                                fontSize: 10,
                                color: secondaryGray.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),

                // Main Card
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.12),
                          blurRadius: 35,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Profile Section
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                lightBlue.withOpacity(0.25),
                                lightBlue.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Avatar with modern gradient border
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [primaryBlue, accentGreen],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryBlue.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 56,
                                    backgroundColor: primaryBlue.withOpacity(0.1),
                                    child: Text(
                                      widget.attendeeName.isNotEmpty
                                          ? widget.attendeeName[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w900,
                                        color: primaryBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Name
                              Text(
                                widget.attendeeName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: primaryBlue,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 14),
                              // Role Badge
                              if (widget.role.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [accentGreen, accentGreen.withOpacity(0.85)],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: accentGreen.withOpacity(0.35),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    widget.role,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              // Organization
                              if (widget.organization.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.business_rounded,
                                      size: 18,
                                      color: secondaryGray.withOpacity(0.6),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        widget.organization,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: secondaryGray.withOpacity(0.8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // QR & Barcode Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              // Section Header
                              Row(
                                children: [
                                  Container(
                                    width: 5,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [primaryBlue, accentGreen],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Scan to Connect',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w800,
                                      color: primaryBlue,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // QR Code
                              Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      lightBlue.withOpacity(0.18),
                                      lightBlue.withOpacity(0.08),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: lightBlue.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: primaryBlue.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.qr_code_2_rounded,
                                            color: primaryBlue,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'QR Code',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: primaryBlue,
                                              ),
                                            ),
                                            Text(
                                              'Scan to save contact',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: secondaryGray.withOpacity(0.8),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    Container(
                                      padding: const EdgeInsets.all(22),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryBlue.withOpacity(0.1),
                                            blurRadius: 20,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: QrImageView(
                                        data: _generateVCard(),
                                        version: QrVersions.auto,
                                        size: 200,
                                        backgroundColor: Colors.white,
                                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                                        eyeStyle: const QrEyeStyle(
                                          eyeShape: QrEyeShape.square,
                                          color: primaryBlue,
                                        ),
                                        dataModuleStyle: const QrDataModuleStyle(
                                          dataModuleShape: QrDataModuleShape.circle,
                                          color: primaryBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 18),

                              // Barcode
                              Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: lightBlue.withOpacity(0.5),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryBlue.withOpacity(0.06),
                                      blurRadius: 18,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: accentGreen.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.view_week_rounded,
                                            color: accentGreen,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Barcode',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: primaryBlue,
                                              ),
                                            ),
                                            Text(
                                              'Scanner compatible',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: secondaryGray.withOpacity(0.8),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    BarcodeWidget(
                                      barcode: Barcode.code128(),
                                      data: widget.phoneNumber,
                                      width: 280,
                                      height: 75,
                                      drawText: true,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: primaryBlue,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Contact Info Section
                              Row(
                                children: [
                                  Container(
                                    width: 5,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [primaryBlue, accentGreen],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Contact Information',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w800,
                                      color: primaryBlue,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // Phone
                              _buildInfoCard(
                                icon: Icons.phone_rounded,
                                label: 'Phone Number',
                                value: widget.phoneNumber,
                                onTap: _copyPhoneNumber,
                                onSecondaryTap: _callPhoneNumber,
                                secondaryIcon: Icons.call_rounded,
                                iconColor: primaryBlue,
                              ),

                              // Email
                              if (widget.email.isNotEmpty) ...[
                                const SizedBox(height: 14),
                                _buildInfoCard(
                                  icon: Icons.email_rounded,
                                  label: 'Email',
                                  value: widget.email,
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: widget.email));
                                    _showSuccessSnackBar('Email copied! 📧');
                                  },
                                  onSecondaryTap: _sendEmail,
                                  secondaryIcon: Icons.send_rounded,
                                  iconColor: accentGreen,
                                ),
                              ],

                              // Conference ID
                              if (widget.conferenceId.isNotEmpty) ...[
                                const SizedBox(height: 14),
                                _buildInfoCard(
                                  icon: Icons.event_rounded,
                                  label: 'Conference ID',
                                  value: widget.conferenceId,
                                  onTap: null,
                                  iconColor: secondaryGray,
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 34),

                        // Action Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              // Save to Contacts
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [primaryBlue, accentGreen],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryBlue.withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _saveContact,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 60,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.person_add_rounded, size: 24, color: Colors.white),
                                          SizedBox(width: 12),
                                          Text(
                                            'Save to Contacts',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              // Share Contact
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    width: 2.5,
                                    color: primaryBlue,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  child: InkWell(
                                    onTap: _shareContact,
                                    borderRadius: BorderRadius.circular(18),
                                    child: Container(
                                      height: 60,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.ios_share_rounded, size: 24, color: primaryBlue),
                                          SizedBox(width: 12),
                                          Text(
                                            'Share Contact',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: primaryBlue,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 34),
                      ],
                    ),
                  ),
                ),

                // Footer
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      Text(
                        'EHS CONFERENCES',
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryGray.withOpacity(0.6),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Emirates Health Services',
                        style: TextStyle(
                          fontSize: 10,
                          color: secondaryGray.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
    VoidCallback? onSecondaryTap,
    IconData? secondaryIcon,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: lightBlue.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [iconColor, iconColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryGray.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          color: primaryBlue,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: lightBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.content_copy_rounded,
                      color: primaryBlue.withOpacity(0.6),
                      size: 20,
                    ),
                  ),
                if (onSecondaryTap != null && secondaryIcon != null) ...[
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: onSecondaryTap,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [iconColor, iconColor.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: iconColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        secondaryIcon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}