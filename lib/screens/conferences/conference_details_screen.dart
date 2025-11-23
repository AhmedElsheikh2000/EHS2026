import 'package:flutter/material.dart';
  import 'dart:async';
  import 'dart:ui';
  import '../../models/conference.dart';
  import 'tabs/contact_tab.dart';
  import 'tabs/program_tab.dart';
  import 'features/about_ehs_screen.dart';
  import 'tabs/speakers_tab.dart';

class ConferenceDetailsScreen extends StatefulWidget {
  final Conference conference;

  const ConferenceDetailsScreen({super.key, required this.conference});

  @override
  State<ConferenceDetailsScreen> createState() => _ConferenceDetailsScreenState();
}

class _ConferenceDetailsScreenState extends State<ConferenceDetailsScreen> with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late Timer _countdownTimer;
  Duration _timeRemaining = Duration.zero;
  late AnimationController _fabController;
  
  // Board members - DIFFERENT for each conference
  late List<BoardMember> _boardMembers;
  
  // Quick actions - SAME NAMES for both conferences
  late List<QuickActionItem> _quickActions;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeRemaining();
    });
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Initialize conference-specific data
    _initializeConferenceData();
  }

  void _initializeConferenceData() {
    if (widget.conference.id == 'accc2026') {
      // 🔴 ACCC 2026 - RED Cardiac Conference Data
      _boardMembers = [
        BoardMember(
          name: 'PROF.Wael Abou Shokka',
          title: 'Head of Organizing Committe',
          image: 'assets/board/member1.jpg',
          specialty: 'Interventional Cardiology',
        ),
        BoardMember(
          name: 'PROF.Ehab al saidy',
          title: 'Scientific Committee Head',
          image: 'assets/board/member2.jpg',
          specialty: 'Cardiac Surgery',
        ),
        BoardMember(
          name: 'PROF.Mohamed Nassef',
          title: 'Program Director',
          image: 'assets/board/member3.jpg',
          specialty: 'Electrophysiology',
        ),
        BoardMember(
          name: 'Mohamed Ashraf',
          title: 'International Relations',
          image: 'assets/board/member4.jpg',
          specialty: 'Preventive Cardiology',
        ),
      ];

      // ACCC Quick Actions - SAME NAMES
      _quickActions = [
        QuickActionItem(
          icon: Icons.badge_outlined,
          title: 'My Badge',
          color: const Color(0xFFEA160A),
          route: '/badge',
        ),
        QuickActionItem(
          icon: Icons.favorite_outline,
          title: 'Submissions',
          color: const Color(0xFFE74C3C),
          route: '/workshops',
        ),
        QuickActionItem(
          icon: Icons.medical_services_outlined,
          title: 'Partners',
          color: const Color(0xFFC0392B),
          route: '/partners',
        ),
        QuickActionItem(
          icon: Icons.bookmark_outline,
          title: 'Bookmarks',
          color: const Color(0xFFF39C12),
          route: '/bookmarks',
        ),
        QuickActionItem(
          icon: Icons.how_to_vote_outlined,
          title: 'Ask & Vote',
          color: const Color(0xFF9B59B6),
          route: '/ask-vote',
        ),
        QuickActionItem(
          icon: Icons.smart_toy_outlined,
          title: 'AI Bot',
          color: const Color(0xFFEA160A),
          route: '/ai-bot',
        ),
        QuickActionItem(
          icon: Icons.schedule_outlined,
          title: 'What Now',
          color: const Color(0xFFE67E22),
          route: '/what-now',
        ),
        QuickActionItem(
          icon: Icons.info_outline,
          title: 'About',
          color: const Color(0xFF85AF99),
          route: '/about',
        ),
        QuickActionItem(
          icon: Icons.workspace_premium_outlined,
          title: 'Certificate',
          color: const Color(0xFFD4AF37),
          route: '/certificate',
        ),
      ];
    } else if (widget.conference.id == 'iccod2026') {
      // 🔵 ICCOD 2026 - BLUE Critical Care Conference Data
      _boardMembers = [

         BoardMember(
          name: 'Suad Hussain Sajwani ',
          title: 'CONFERENCE VICE PRESIDENT',
          image: 'assets/board/member4.jpg',
          specialty: 'Intensive Care',
        ),
        
        BoardMember(
          name: 'PROF.Mohamed Nassef ',
          title: 'HEAD OF ORGANIZING COMMITTEE',
          image: 'assets/board/member1.jpg',
          specialty: 'Critical Care Medicine',
        ),
        BoardMember(
          name: 'PROF.Islam Elfeky',
          title: 'Transplant Committee',
          image: 'assets/board/member2.jpg',
          specialty: 'Organ Transplantation',
        ),
        BoardMember(
          name: 'PROF.Mahmoud Mousa',
          title: 'ICU Program Lead',
          image: 'assets/board/member3.jpg',
          specialty: 'Emergency Medicine',
        ),
        BoardMember(
          name: 'PROF.Ahmed Abdallah',
          title: 'Research Director',
          image: 'assets/board/member4.jpg',
          specialty: 'Intensive Care',
        ),
      ];

      // ICCOD Quick Actions - SAME NAMES
      _quickActions = [
        QuickActionItem(
          icon: Icons.badge_outlined,
          title: 'My Badge',
          color: const Color(0xFF00759E),
          route: '/badge',
        ),
        QuickActionItem(
          icon: Icons.emergency_outlined,
          title: 'Submissions',
          color: const Color(0xFF3498DB),
          route: '/workshops',
        ),
        QuickActionItem(
          icon: Icons.healing_outlined,
          title: 'Partners',
          color: const Color(0xFF27AE60),
          route: '/partners',
        ),
        QuickActionItem(
          icon: Icons.bookmark_outline,
          title: 'Bookmarks',
          color: const Color(0xFFF39C12),
          route: '/bookmarks',
        ),
        QuickActionItem(
          icon: Icons.how_to_vote_outlined,
          title: 'Ask & Vote',
          color: const Color(0xFF9B59B6),
          route: '/ask-vote',
        ),
        QuickActionItem(
          icon: Icons.smart_toy_outlined,
          title: 'AI Bot',
          color: const Color(0xFF00759E),
          route: '/ai-bot',
        ),
        QuickActionItem(
          icon: Icons.schedule_outlined,
          title: 'What Now',
          color: const Color(0xFF16A085),
          route: '/what-now',
        ),
        QuickActionItem(
          icon: Icons.info_outline,
          title: 'About',
          color: const Color(0xFF85AF99),
          route: '/about',
        ),
        QuickActionItem(
          icon: Icons.workspace_premium_outlined,
          title: 'Certificate',
          color: const Color(0xFFD4AF37),
          route: '/certificate',
        ),
      ];
    }
  }

  void _calculateTimeRemaining() {
    final now = DateTime.now();
    setState(() {
      _timeRemaining = widget.conference.date.difference(now);
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      extendBody: true,
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildHomeTab(),
          _buildBoardTab(),
          _buildSpeakersTab(),
          const ProgramTab(),
          const ContactTab(),
        ],
      ),
      bottomNavigationBar: _buildModernNavBar(),
      floatingActionButton: _buildModernFAB(),
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildModernAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGlassCountdownCard(),
              const SizedBox(height: 24),
              _buildEHSTrainingVillageSection(),
              const SizedBox(height: 24),
              _buildQuickAccessGrid(),
              const SizedBox(height: 32),
              _buildConferencePresidentSection(),
              const SizedBox(height: 32),
              _buildBoardMembersCarousel(),
              const SizedBox(height: 24),
              _buildModernInfoCards(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernAppBar() {
    // Get the banner image path based on conference
    final String bannerImage = widget.conference.id == 'accc2026' 
        ? 'assets/accc_banner.jpg'
        : 'assets/iccod_banner.jpg';

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image Banner - NO TEXT OVERLAY
            Image.asset(
              bannerImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to gradient if image not found
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.conference.color,
                        widget.conference.color.withOpacity(0.8),
                        widget.conference.color.withOpacity(0.9),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Light gradient overlay for better aesthetics
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          widget.conference.shortName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildGlassCountdownCard() {
    final days = _timeRemaining.inDays;
    final hours = _timeRemaining.inHours % 24;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.conference.color.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.conference.color,
                            widget.conference.color.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Event Countdown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildModernCountdownUnit(days.toString(), 'Days'),
                    _buildCountdownDivider(),
                    _buildModernCountdownUnit(hours.toString().padLeft(2, '0'), 'Hours'),
                    _buildCountdownDivider(),
                    _buildModernCountdownUnit(minutes.toString().padLeft(2, '0'), 'Min'),
                    _buildCountdownDivider(),
                    _buildModernCountdownUnit(seconds.toString().padLeft(2, '0'), 'Sec'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernCountdownUnit(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.conference.color.withOpacity(0.15),
                widget.conference.color.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.conference.color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: widget.conference.color,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownDivider() {
    return Text(
      ':',
      style: TextStyle(
        fontSize: 24,
        color: Colors.grey[400],
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEHSTrainingVillageSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: 0.9 + (value * 0.1),
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/training-village');
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.conference.color,
                          widget.conference.color.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: widget.conference.color.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                          spreadRadius: -5,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
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
                                widget.conference.id == 'accc2026' 
                                    ? 'Ehs Training Village'
                                    : 'Ehs Training Village',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.conference.id == 'accc2026'
                                    ? 'Ehs Training Village'
                                    : 'Ehs Training Village',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickAccessGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.conference.color,
                      widget.conference.color.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2C3E50),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            itemCount: _quickActions.length,
            itemBuilder: (context, index) {
              return _buildModernQuickActionCard(_quickActions[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModernQuickActionCard(QuickActionItem action, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 50)),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        final scale = (0.5 + (value * 0.5)).clamp(0.0, 1.0);
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _handleQuickAction(action),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.95),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: action.color.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              action.color,
                              action.color.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: action.color.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          action.icon,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          action.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C3E50),
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConferencePresidentSection() {
  final presidentName = widget.conference.id == 'accc2026'
      ? 'PROF. Arif Al Nooryani'
      : 'PROF. Sumaya AlZarooni';

  final presidentTitle = widget.conference.id == 'accc2026'
      ? 'President OF 1st EHS Cardiovascular International Congress'
      : 'President OF 3rd EHS International Critical Care Conference';

  // ✅ أضف صور الرؤساء
  final presidentImage = widget.conference.id == 'accc2026'
      ? 'assets/images/president_arif.jpg'
      : 'assets/images/president_sumaya.jpg';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 5,
              height: 28,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.conference.color,
                    widget.conference.color.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Conference President',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2C3E50),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (context, double value, child) {
            final scale = (0.8 + (value * 0.2)).clamp(0.0, 1.0);
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: widget.conference.color.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // ✅ صورة الرئيس داخل إطار دائري خفيف
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.conference.color.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          presidentImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    widget.conference.color,
                                    widget.conference.color.withOpacity(0.8),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  presidentName
                                      .split(' ')
                                      .map((e) => e[0])
                                      .take(2)
                                      .join(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              presidentName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2C3E50),
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              presidentTitle,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7F8C8D),
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
          },
        ),
      ],
    ),
  );
}


  Widget _buildBoardMembersCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.conference.color,
                      widget.conference.color.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Board Members',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2C3E50),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _boardMembers.length,
            itemBuilder: (context, index) {
              return _buildModernBoardCard(_boardMembers[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernBoardCard(BoardMember member, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Container(
              width: 180,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: widget.conference.color.withOpacity(0.12),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.conference.color.withOpacity(0.15),
                          widget.conference.color.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.conference.color,
                              widget.conference.color.withOpacity(0.8),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.conference.color.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.transparent,
                          child: Text(
                            member.name.split(' ').map((e) => e[0]).take(2).join(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          member.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2C3E50),
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.conference.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            member.title,
                            style: TextStyle(
                              fontSize: 11,
                              color: widget.conference.color,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      },
    );
  }

  Widget _buildModernInfoCards() {
    // Different info cards for each conference
    final cards = widget.conference.id == 'accc2026' 
        ? [
            {
              'title': 'Directions',
              'icon': Icons.map_outlined,
              'color': widget.conference.color,
              'description': 'Al Qassimi Hospital, Sharjah',
            },
            {
              'title': 'Cardiac Spotlights',
              'icon': Icons.favorite_outline,
              'color': const Color(0xFFE74C3C),
              'description': 'Featured cardiac procedures',
            },
            {
              'title': 'Latest Updates',
              'icon': Icons.newspaper_outlined,
              'color': const Color(0xFFF39C12),
              'description': 'Cardiology news',
            },
          ]
        : [
            {
              'title': 'Directions',
              'icon': Icons.map_outlined,
              'color': widget.conference.color,
              'description': 'Dubai World Trade Centre',
            },
            {
              'title': 'ICU Innovations',
              'icon': Icons.emergency_outlined,
              'color': const Color(0xFF27AE60),
              'description': 'Latest in critical care',
            },
            {
              'title': 'Congress Updates',
              'icon': Icons.newspaper_outlined,
              'color': const Color(0xFF3498DB),
              'description': 'Critical care news',
            },
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: cards.map((card) {
          final index = cards.indexOf(card);
          return TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 600 + (index * 100)),
            curve: Curves.easeOutCubic,
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.95),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: (card['color'] as Color).withOpacity(0.12),
                                blurRadius: 25,
                                offset: const Offset(0, 8),
                                spreadRadius: -5,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      card['color'] as Color,
                                      (card['color'] as Color).withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (card['color'] as Color).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  card['icon'] as IconData,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card['title'] as String,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF2C3E50),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      card['description'] as String,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                        height: 1.4,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (card['color'] as Color).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: card['color'] as Color,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  void _handleQuickAction(QuickActionItem action) {
    if (action.route == '/badge') {
      final userArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      Navigator.pushNamed(
        context,
        '/badge',
        arguments: {
          'attendeeName': userArgs?['userName'] ?? 'Guest',
          'phoneNumber': userArgs?['phoneNumber'] ?? '',
          'email': userArgs?['email'] ?? '',
          'organization': 'Emirates Health Services',
          'role': 'Attendee',
          'conferenceId': widget.conference.id,
        },
      );
    } else if (action.route == '/certificate') {
      final userArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      Navigator.pushNamed(
        context,
        '/certificate',
        arguments: {
          'attendeeName': userArgs?['userName'] ?? 'Guest',
        },
      );
    } else if (action.route == '/bookmarks') {
      Navigator.pushNamed(
        context,
        '/bookmarks',
        arguments: {
          'bookmarkedItems': <String>{},
          'onToggleBookmark': (String id) {},
        },
      );
    } else if (action.route == '/ask-vote') {
      Navigator.pushNamed(context, '/ask-vote');
    } else if (action.route == '/ai-bot') {
      Navigator.pushNamed(context, '/ai-bot');
      
    } else if (action.route == '/workshops') {
    Navigator.pushNamed(context, '/workshops');}else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      action.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Coming Soon!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: action.color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
          elevation: 8,
        ),
      );
    }
  }

  Widget _buildBoardTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5F7FA), Colors.white],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.conference.color.withOpacity(0.1),
                    widget.conference.color.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups_rounded,
                size: 80,
                color: widget.conference.color,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Board Members',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete list coming soon',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildSpeakersTab() {
  return SpeakersTab(
    conferenceColor: widget.conference.color,
    conferenceId: widget.conference.id,
  );
}
  

  Widget _buildModernNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: widget.conference.color.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => setState(() => _selectedTab = index),
          backgroundColor: Colors.transparent,
          selectedItemColor: widget.conference.color,
          unselectedItemColor: const Color(0xFF95A5A6),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.home_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.home_rounded, size: 26),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.groups_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.groups_rounded, size: 26),
              ),
              label: 'Board',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.mic_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.mic_rounded, size: 26),
              ),
              label: 'Speakers',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.calendar_today_outlined, size: 22),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.calendar_today_rounded, size: 24),
              ),
              label: 'Program',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.contact_mail_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.contact_mail_rounded, size: 26),
              ),
              label: 'Contact',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernFAB() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.conference.color,
            widget.conference.color.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.conference.color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _showModernHelp,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(
          Icons.support_agent_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  void _showModernHelp() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: widget.conference.color.withOpacity(0.2),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.conference.color,
                      widget.conference.color.withOpacity(0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.conference.color.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Help & Support',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  color: Color(0xFF2C3E50),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'How can we assist you with\nthe conference?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: widget.conference.color.withOpacity(0.1),
                      ),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: widget.conference.color,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.conference.color,
                            widget.conference.color.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: widget.conference.color.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/ai-bot');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Chat Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model Classes
class QuickActionItem {
  final IconData icon;
  final String title;
  final Color color;
  final String route;

  QuickActionItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.route,
  });
}

class BoardMember {
  final String name;
  final String title;
  final String image;
  final String specialty;

  BoardMember({
    required this.name,
    required this.title,
    required this.image,
    required this.specialty,
  });
}