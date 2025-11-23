import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../conferences/conference_details_screen.dart';
import '../../models/conference.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String phoneNumber;
  final String email;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.phoneNumber,
    required this.email,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isDarkMode = false;
  final ScrollController _scrollController = ScrollController();

  final List<Conference> _conferences = [
    Conference(
      id: 'accc2026',
      title: '1st EHS Cardiovascular International Congress ',
      titleAr: 'المؤتمر الدولي الأول لأمراض القلب والأوعية الدموية ',
      shortName: 'ACCC 2026',
      date: DateTime(2026, 3, 27),
      endDate: DateTime(2026, 3, 29),
      location: 'Intercontinental Dubai Festival City, Dubai, UAE.',
      locationAr: 'فندق إنتركونتيننتال دبي فستيفال سيتي، دبي، الإمارات العربية المتحدة',
      description: 'Leading cardiac care conference featuring international experts and cutting-edge research in cardiovascular medicine.',
      imageUrl: 'assets/accc_banner.jpg',
      color: const Color(0xFFEA160A),
      category: 'Cardiac Care',
      attendees: 500,
    ),
    Conference(
      id: 'iccod2026',
      title: '3rd EHS International Critical Care and Organ Donation Transplantation Conference',
      titleAr: 'المؤتمر الدولي الثالث للرعاية الحرجة وزراعة الأعضاء والتبرع بها التابع لجمعية الصحة والسلامة المهنية',
      shortName: 'ICCOD 2026',
      date: DateTime(2026, 3, 27),
      endDate: DateTime(2026, 3, 30),
      location: 'Intercontinental Dubai Festival City, Dubai, UAE.',
      locationAr: 'فندق إنتركونتيننتال دبي فستيفال سيتي، دبي، الإمارات العربية المتحدة',
      description: 'International congress on critical care management and organ transplantation excellence.',
      imageUrl: 'assets/iccod_banner.jpg',
      color: const Color(0xFF00759E),
      category: 'Critical Care',
      attendees: 750,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF0F1419) : const Color(0xFFF5F7FA),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildLandingPage(),
          _buildAllConferencesPage(),
          _buildMyConferencesPage(),
          _buildProfilePage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildLandingPage() {
    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
        SliverToBoxAdapter(
  child: FadeTransition(
    opacity: _fadeAnimation,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // الخلفية البانر
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/home_banner.jpg',
            width: double.infinity,
            height: 260,
            fit: BoxFit.cover,
          ),
        ),

        // المحتوى فوق البانر
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/ehs_logo.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'EHS Conferences',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.waving_hand, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Welcome, ${widget.userName}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  ),
),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _buildStatCard(
                    '${_conferences.length}',
                    'Available',
                    Icons.event_available_rounded,
                    const Color(0xFF00759E),
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    '2',
                    'Registered',
                    Icons.how_to_reg_rounded,
                    const Color(0xFF66C5B5),
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    '5',
                    'Certificates',
                    Icons.workspace_premium_rounded,
                    const Color(0xFFEA160A),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : const Color(0xFF1A2332),
                      letterSpacing: 0.3,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _selectedIndex = 1),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('See All'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF00759E),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildEnhancedConferenceCard(_conferences[index], index);
                },
                childCount: _conferences.length,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why Choose EHS?',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : const Color(0xFF1A2332),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureItem(
                    Icons.stars_rounded,
                    'World-Class Speakers',
                    'Learn from leading healthcare professionals',
                    const Color(0xFFEA160A),
                  ),
                  _buildFeatureItem(
                    Icons.people_alt_rounded,
                    'Networking Opportunities',
                    'Connect with peers and industry experts',
                    const Color(0xFF00759E),
                  ),
                  _buildFeatureItem(
                    Icons.verified_rounded,
                    'Certified Programs',
                    'Earn internationally recognized certificates',
                    const Color(0xFF66C5B5),
                  ),
                  _buildFeatureItem(
                    Icons.smart_toy_rounded,
                    'AI-Powered Assistant',
                    'Get instant help with EHS-BOT',
                    const Color(0xFFEA160A),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildEnhancedConferenceCard(Conference conference, int index) {
    final now = DateTime.now();
    final difference = conference.date.difference(now);
    final days = difference.inDays;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _navigateToConference(conference),
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: _isDarkMode ? const Color(0xFF1A2332) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: conference.color.withOpacity(0.15),
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(_isDarkMode ? 0.4 : 0.05),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // FIND THIS in your code (around line 318):
// Stack(
//   children: [
//     Container(
//       height: 200,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//
// DELETE from "Stack(" all the way down to the closing brackets before "Padding("
// Then PASTE THIS EXACT CODE:

// Replace the Stack widget starting at line 333
// Remove from line 333 to line 531 (before Padding widget)
// Replace with this code:

Stack(
  children: [
    // Background Image instead of gradient
    ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(28),
      ),
      child: Stack(
        children: [
          // Conference Background Image
          Image.asset(
            conference.id == 'accc2026' 
                ? 'assets/accc_banner.jpg'
                : 'assets/iccod_banner.jpg',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      conference.color,
                      conference.color.withOpacity(0.75),
                    ],
                  ),
                ),
              );
            },
          ),
          // Overlay gradient
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
          // Pattern overlay
          CustomPaint(
            size: const Size(double.infinity, 200),
            painter: ConferencePatternPainter(
              color: Colors.white.withOpacity(0.06),
            ),
          ),
        ],
      ),
    ),
    
    // Days countdown (top right)
    Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule_rounded,
              color: conference.color,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              '$days Days',
              style: TextStyle(
                color: conference.color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    ),
    
    // Category badge (top left)
    Positioned(
      top: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Text(
          conference.category,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    ),
  ],
),

// RIGHT AFTER THIS CLOSING BRACKET, you should see:
// Padding(
//   padding: const EdgeInsets.all(24),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conference.title,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : const Color(0xFF1A2332),
                        height: 1.3,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      conference.titleAr,
                      style: TextStyle(
                        fontSize: 17,
                        color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                        fontFamily: 'Cairo',
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      conference.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                        height: 1.6,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: conference.color.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: conference.color.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 18,
                                color: conference.color,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${conference.date.day}/${conference.date.month}/${conference.date.year}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _isDarkMode ? Colors.white : const Color(0xFF1A2332),
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.people_rounded,
                                size: 18,
                                color: conference.color,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${conference.attendees}+',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _isDarkMode ? Colors.white : const Color(0xFF1A2332),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 18,
                                color: conference.color,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  conference.location,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navigateToConference(conference),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: conference.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          shadowColor: conference.color.withOpacity(0.4),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Explore Event',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: _isDarkMode ? const Color(0xFF1A2332) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : const Color(0xFF1A2332),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _isDarkMode ? const Color(0xFF1A2332) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isDarkMode ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.15),
                    color.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : const Color(0xFF1A2332),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  void _navigateToConference(Conference conference) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConferenceDetailsScreen(conference: conference),
        settings: RouteSettings(arguments: {
          'userName': widget.userName,
          'phoneNumber': widget.phoneNumber,
          'email': widget.email,
        }),
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _isDarkMode ? const Color(0xFF1A2332) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : const Color(0xFF1A2332),
              ),
            ),
            const SizedBox(height: 24),
            Icon(
              Icons.notifications_none_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No new notifications',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _isDarkMode ? const Color(0xFF1A2332) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : const Color(0xFF1A2332),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF0F1419) : const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(18),
              ),
              child: SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: _isDarkMode ? Colors.white : const Color(0xFF1A2332),
                  ),
                ),
                subtitle: Text(
                  'Switch to ${_isDarkMode ? 'light' : 'dark'} theme',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() => _isDarkMode = value);
                  Navigator.pop(context);
                },
                activeColor: const Color(0xFF00759E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAllConferencesPage() {
    return Center(
      child: Text(
        'All Conferences',
        style: TextStyle(
          color: _isDarkMode ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMyConferencesPage() {
    return Center(
      child: Text(
        'My Conferences',
        style: TextStyle(
          color: _isDarkMode ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return ProfileScreen(
      userName: widget.userName,
      email: widget.email,
      phoneNumber: widget.phoneNumber,
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: _isDarkMode ? const Color(0xFF1A2332) : Colors.white,
        selectedItemColor: const Color(0xFF00759E),
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event_rounded),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class MedicalPatternPainter extends CustomPainter {
  final Color color;

  MedicalPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 4; j++) {
        final x = i * size.width / 5 - 20;
        final y = j * size.height / 3;
        
        canvas.drawCircle(Offset(x, y), 25, paint);
        
        final crossPaint = Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        
        canvas.drawLine(
          Offset(x - 8, y),
          Offset(x + 8, y),
          crossPaint,
        );
        canvas.drawLine(
          Offset(x, y - 8),
          Offset(x, y + 8),
          crossPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(MedicalPatternPainter oldDelegate) => false;
}

class ConferencePatternPainter extends CustomPainter {
  final Color color;

  ConferencePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 5; j++) {
        final x = i * size.width / 7;
        final y = j * size.height / 4;
        
        final path = Path()
          ..moveTo(x, y)
          ..lineTo(x + 30, y + 15)
          ..lineTo(x + 15, y + 35)
          ..close();
        
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(ConferencePatternPainter oldDelegate) => false;
}