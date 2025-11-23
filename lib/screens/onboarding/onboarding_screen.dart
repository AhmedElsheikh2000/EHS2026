import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Welcome to EHS Conferences',
      titleAr: 'مرحباً بك في مؤتمرات EHS',
      description: 'Your gateway to all Emirates Health Services conferences and events',
      descriptionAr: 'بوابتك لجميع مؤتمرات وفعاليات مؤسسة الإمارات للخدمات الصحية',
      icon: Icons.medical_services_rounded,
      gradientColors: [const Color(0xFF344E75), const Color(0xFF4A6FA5)],
    ),
    OnboardingData(
      title: 'Stay Connected',
      titleAr: 'ابق على اتصال',
      description: 'Network with healthcare professionals and experts from around the world',
      descriptionAr: 'تواصل مع المتخصصين والخبراء في الرعاية الصحية من جميع أنحاء العالم',
      icon: Icons.people_rounded,
      gradientColors: [const Color(0xFF395940), const Color(0xFF85AF99)],
    ),
    OnboardingData(
      title: 'Manage Your Schedule',
      titleAr: 'نظم جدولك',
      description: 'Track sessions, workshops, and create your personalized agenda',
      descriptionAr: 'تابع الجلسات وورش العمل وأنشئ جدولك الشخصي',
      icon: Icons.calendar_month_rounded,
      gradientColors: [const Color(0xFF4A6FA5), const Color(0xFF7EC8E3)],
    ),
    OnboardingData(
      title: 'Access Resources',
      titleAr: 'الوصول إلى الموارد',
      description: 'Download presentations, certificates, and conference materials instantly',
      descriptionAr: 'حمّل العروض التقديمية والشهادات ومواد المؤتمر على الفور',
      icon: Icons.folder_shared_rounded,
      gradientColors: [const Color(0xFF85AF99), const Color(0xFFB7D1DA)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _pages[_currentPage].gradientColors,
              ),
            ),
          ),
          // Pattern overlay
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: PatternPainter(
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                // Pages
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: _buildPage(_pages[index]),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Bottom section
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => _buildPageIndicator(index),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Previous button
                          _currentPage > 0
                              ? _buildNavButton(
                                  icon: Icons.arrow_back_ios_rounded,
                                  onPressed: () {
                                    _pageController.previousPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                )
                              : const SizedBox(width: 60),
                          // Main action button
                          _buildMainButton(),
                          // Next button
                          _currentPage < _pages.length - 1
                              ? _buildNavButton(
                                  icon: Icons.arrow_forward_ios_rounded,
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                )
                              : const SizedBox(width: 60),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated rings
                ...List.generate(3, (index) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800 + (index * 200)),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 120 - (index * 20),
                          height: 120 - (index * 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2 - (index * 0.05)),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      );
                    },
                  );
                }),
                // Main icon
                Icon(
                  data.icon,
                  size: 70,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Arabic title
          Text(
            data.titleAr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Description
          Text(
            data.description,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Arabic description
          Text(
            data.descriptionAr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Colors.white
            : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildMainButton() {
    final isLastPage = _currentPage == _pages.length - 1;
    return GestureDetector(
      onTap: () {
        if (isLastPage) {
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLastPage ? 'Get Started' : 'Continue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _pages[_currentPage].gradientColors[0],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              color: _pages[_currentPage].gradientColors[0],
            ),
          ],
        ),
      ),
    );
  }
}

// Data model for onboarding pages
class OnboardingData {
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final IconData icon;
  final List<Color> gradientColors;

  OnboardingData({
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.icon,
    required this.gradientColors,
  });
}

// Custom painter for background pattern
class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw geometric pattern
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 8; j++) {
        final centerX = (i + 0.5) * size.width / 5;
        final centerY = (j + 0.5) * size.height / 8;
        
        // Draw hexagon-like shapes
        final path = Path();
        for (int k = 0; k < 6; k++) {
          final angle = (k * 60) * math.pi / 180;
          final x = centerX + 30 * math.cos(angle);
          final y = centerY + 30 * math.sin(angle);
          if (k == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(PatternPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}