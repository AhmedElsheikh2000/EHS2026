import 'package:flutter/material.dart';

class AboutEHSScreen extends StatefulWidget {
  const AboutEHSScreen({super.key});

  @override
  State<AboutEHSScreen> createState() => _AboutEHSScreenState();
}

class _AboutEHSScreenState extends State<AboutEHSScreen> with SingleTickerProviderStateMixin {
  String _activeTab = 'vision';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          _buildHeroSection(),
          _buildStatsSection(),
          _buildTabsSection(),
          _buildCoreValuesSection(),
          _buildServicesSection(),
          _buildCTASection(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: 420,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF344E75), Color(0xFF4A6FA5)],
            ),
          ),
          child: Stack(
            children: [
              // Geometric Pattern
              CustomPaint(
                size: Size.infinite,
                painter: GeometricPatternPainter(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              
              // Animated Blobs
              Positioned(
                top: 80,
                left: 40,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF85AF99).withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                right: 40,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF4A6FA5).withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              
              // Content
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  'EHS',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF344E75),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Emirates Health Services',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFB7D1DA),
                                  ),
                                ),
                                Text(
                                  'مؤسسة الإمارات للخدمات الصحية',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF9BB4C4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      const Text(
                        'Transforming',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF85AF99), Color(0xFFB7D1DA)],
                        ).createShader(bounds),
                        child: const Text(
                          'Healthcare Excellence',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Leading the future of integrated healthcare services across the United Arab Emirates',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFB7D1DA),
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
  final stats = [
    {'icon': Icons.people, 'value': '50K+', 'label': 'Healthcare\nProfessionals', 'color': const Color(0xFF344E75)},
    {'icon': Icons.local_hospital, 'value': '100+', 'label': 'Healthcare\nFacilities', 'color': const Color(0xFF27AE60)},
    {'icon': Icons.emoji_events, 'value': '15+', 'label': 'Centers of\nExcellence', 'color': const Color(0xFF85AF99)},
    {'icon': Icons.favorite, 'value': '24/7', 'label': 'Patient\nCare', 'color': const Color(0xFF4A6FA5)},
  ];

  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1, // Changed from 1.3 to 1.1 to give more vertical space
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          final stat = stats[index];
          return Container(
            padding: const EdgeInsets.all(16), // Reduced from 20 to 16
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Added this
              children: [
                Container(
                  width: 44, // Reduced from 48
                  height: 44, // Reduced from 48
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [stat['color'] as Color, (stat['color'] as Color).withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    stat['icon'] as IconData,
                    color: Colors.white,
                    size: 22, // Reduced from 24
                  ),
                ),
                const SizedBox(height: 10), // Reduced from 12
                Text(
                  stat['value'] as String,
                  style: const TextStyle(
                    fontSize: 24, // Reduced from 28
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Flexible( // Wrapped with Flexible
                  child: Text(
                    stat['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11, // Reduced from 12
                      color: Color(0xFF7F8C8D),
                      fontWeight: FontWeight.w600,
                      height: 1.2, // Added line height
                    ),
                    maxLines: 2, // Added max lines
                    overflow: TextOverflow.ellipsis, // Added overflow handling
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

  Widget _buildTabsSection() {
    final tabs = {
      'vision': {
        'title': 'Our Vision',
        'content': 'To be the leading healthcare provider in the UAE, recognized for excellence in patient care, medical innovation, and community health promotion.',
        'icon': Icons.public,
        'gradient': [const Color(0xFF344E75), const Color(0xFF85AF99)],
      },
      'mission': {
        'title': 'Our Mission',
        'content': 'Delivering integrated, patient-centered healthcare services through a network of excellence, innovation, and compassionate care that improves community health outcomes.',
        'icon': Icons.favorite,
        'gradient': [const Color(0xFFE74C3C), const Color(0xFFF39C12)],
      },
      'goals': {
        'title': 'Strategic Goals',
        'content': 'Enhancing healthcare quality, expanding medical services, fostering innovation, developing healthcare professionals, and ensuring sustainable health system excellence.',
        'icon': Icons.trending_up,
        'gradient': [const Color(0xFF27AE60), const Color(0xFF85AF99)],
      },
    };

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: tabs.keys.map((key) {
                  final isActive = _activeTab == key;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeTab = key),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: isActive
                              ? const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFFEBF5FB), Colors.transparent],
                                )
                              : null,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              tabs[key]!['icon'] as IconData,
                              color: isActive ? const Color(0xFF344E75) : Colors.grey,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              (tabs[key]!['title'] as String).split(' ').last,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isActive ? const Color(0xFF344E75) : Colors.grey,
                              ),
                            ),
                            if (isActive)
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                height: 3,
                                width: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: tabs[key]!['gradient'] as List<Color>,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: tabs[_activeTab]!['gradient'] as List<Color>,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (tabs[_activeTab]!['gradient'] as List<Color>)[0].withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      tabs[_activeTab]!['icon'] as IconData,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tabs[_activeTab]!['title'] as String,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tabs[_activeTab]!['content'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF7F8C8D),
                            height: 1.6,
                          ),
                        ),
                      ],
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

  Widget _buildCoreValuesSection() {
    final values = [
      {
        'icon': Icons.favorite,
        'title': 'Patient-Centered Care',
        'description': 'Delivering compassionate, integrated healthcare services focused on patient wellbeing',
        'gradient': [const Color(0xFFE74C3C), const Color(0xFFF39C12)],
      },
      {
        'icon': Icons.emoji_events,
        'title': 'Excellence & Quality',
        'description': 'Committed to the highest standards of medical excellence and continuous improvement',
        'gradient': [const Color(0xFFF39C12), const Color(0xFFE67E22)],
      },
      {
        'icon': Icons.trending_up,
        'title': 'Innovation & Research',
        'description': 'Advancing healthcare through cutting-edge technology and medical research',
        'gradient': [const Color(0xFF344E75), const Color(0xFF4A6FA5)],
      },
      {
        'icon': Icons.security,
        'title': 'Safety & Trust',
        'description': 'Ensuring patient safety and building trust through transparency and accountability',
        'gradient': [const Color(0xFF27AE60), const Color(0xFF85AF99)],
      },
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Core Values',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The principles that guide everything we do',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF7F8C8D),
              ),
            ),
            const SizedBox(height: 32),
            
            ...values.map((value) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: value['gradient'] as List<Color>,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: (value['gradient'] as List<Color>)[0].withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      value['icon'] as IconData,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value['title'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          value['description'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7F8C8D),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    final services = [
      {
        'title': 'Primary Healthcare',
        'items': ['General Medicine', 'Preventive Care', 'Family Medicine', 'Health Screening'],
        'icon': Icons.medical_services,
        'color': const Color(0xFF344E75),
      },
      {
        'title': 'Specialized Services',
        'items': ['Cardiology', 'Oncology', 'Neurology', 'Orthopedics'],
        'icon': Icons.local_hospital,
        'color': const Color(0xFF27AE60),
      },
      {
        'title': 'Emergency Care',
        'items': ['24/7 Emergency', 'Critical Care', 'Trauma Services', 'Ambulance Services'],
        'icon': Icons.emergency,
        'color': const Color(0xFFE74C3C),
      },
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.all(40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C3E50), Color(0xFF344E75), Color(0xFF4A6FA5)],
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Our Services',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Comprehensive healthcare solutions for every need',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFB7D1DA),
              ),
            ),
            const SizedBox(height: 32),
            
            ...services.map((service) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          service['icon'] as IconData,
                          color: service['color'] as Color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        service['title'] as String,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ...(service['items'] as List<String>).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF85AF99),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFFB7D1DA),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCTASection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF344E75), Color(0xFF85AF99)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF344E75).withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Join Our Medical Conferences',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Stay updated with the latest medical innovations, research, and networking opportunities',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFB7D1DA),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF344E75),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore Conferences',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GeometricPatternPainter extends CustomPainter {
  final Color color;

  GeometricPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 3; j++) {
        final x = i * size.width / 4;
        final y = j * size.height / 2;
        
        final path = Path()
          ..moveTo(x, y)
          ..lineTo(x + 40, y + 20)
          ..lineTo(x + 20, y + 40)
          ..close();
        
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(GeometricPatternPainter oldDelegate) => false;
}