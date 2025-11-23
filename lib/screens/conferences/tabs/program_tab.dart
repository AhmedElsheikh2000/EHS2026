import 'package:flutter/material.dart';
import '../features/bookmarks_screen.dart';



class ProgramTab extends StatefulWidget {
  const ProgramTab({Key? key}) : super(key: key);

  @override
  State<ProgramTab> createState() => _ProgramTabState();
}

class _ProgramTabState extends State<ProgramTab> with SingleTickerProviderStateMixin {
  // ... rest of your code
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Set<String> _bookmarkedItems = {};

  // EHS Brand Colors
  static const Color primaryColor = Color(0xFF344E75);
  static const Color secondaryColor = Color(0xFF85af99);
  static const Color accentColor = Color(0xFFb7d1da);
  static const Color darkColor = Color(0xFF6F6C6F);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleBookmark(String id) {
    setState(() {
      if (_bookmarkedItems.contains(id)) {
        _bookmarkedItems.remove(id);
      } else {
        _bookmarkedItems.add(id);
      }
    });
  }

  void _navigateToBookmarks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookmarksScreen(
          bookmarkedItems: _bookmarkedItems,
          onToggleBookmark: _toggleBookmark,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Conference Program',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor,
                        secondaryColor,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.bookmark_rounded),
                        onPressed: _navigateToBookmarks,
                        tooltip: 'My Bookmarks',
                      ),
                      if (_bookmarkedItems.isNotEmpty)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${_bookmarkedItems.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(110),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search sessions, speakers, topics...',
                            prefixIcon: const Icon(Icons.search, color: primaryColor),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: primaryColor, width: 2),
                            ),
                          ),
                        ),
                      ),
                      // Day Tabs
                      TabBar(
                        controller: _tabController,
                        labelColor: primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: primaryColor,
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        tabs: const [
                          Tab(text: '27 March 2025'),
                          Tab(text: '28 March 2025'),
                          Tab(text: '29 March 2025'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDaySchedule(_getDay1Sessions()),
            _buildDaySchedule(_getDay2Sessions()),
            _buildDaySchedule(_getDay3Sessions()),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySchedule(List<ConferenceSession> sessions) {
    final filteredSessions = sessions.where((session) {
      if (_searchQuery.isEmpty) return true;
      
      final sessionMatch = session.title.toLowerCase().contains(_searchQuery);
      final hallMatch = session.hall.toLowerCase().contains(_searchQuery);
      final talksMatch = session.talks.any((talk) =>
          talk.title.toLowerCase().contains(_searchQuery) ||
          talk.speaker.toLowerCase().contains(_searchQuery));
      
      return sessionMatch || hallMatch || talksMatch;
    }).toList();

    if (filteredSessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No sessions found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredSessions.length,
      itemBuilder: (context, index) {
        return _buildSessionCard(filteredSessions[index]);
      },
    );
  }

  Widget _buildSessionCard(ConferenceSession session) {
    final isSessionBookmarked = _bookmarkedItems.contains(session.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, secondaryColor],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              session.type == SessionType.plenary
                                  ? 'Plenary Session'
                                  : 'Parallel Session',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            session.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Material(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _toggleBookmark(session.id),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            isSessionBookmarked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${session.startTime} - ${session.endTime}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.location_on, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      session.hall,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Talks List
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: session.talks.asMap().entries.map((entry) {
                final index = entry.key;
                final talk = entry.value;
                return _buildTalkCard(talk, index + 1, session.id);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTalkCard(Talk talk, int number, String sessionId) {
    final isTalkBookmarked = _bookmarkedItems.contains(talk.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 2),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${talk.startTime} - ${talk.endTime}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      talk.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: accentColor,
                          child: Text(
                            talk.speaker.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                talk.speaker,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                talk.role,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
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
              const SizedBox(width: 8),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _toggleBookmark(talk.id),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      isTalkBookmarked ? Icons.favorite : Icons.favorite_border,
                      color: isTalkBookmarked ? secondaryColor : darkColor,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Mock Data
  List<ConferenceSession> _getDay1Sessions() {
    return [
      ConferenceSession(
        id: 's1',
        title: 'Opening Ceremony',
        hall: 'Main Hall A',
        startTime: '09:00',
        endTime: '10:00',
        type: SessionType.plenary,
        talks: [
          Talk(
            id: 't1',
            title: 'Welcome Address: Future of Healthcare in UAE',
            speaker: 'Dr. Ahmed Al Mansouri',
            role: 'Director General, EHS',
            startTime: '09:00',
            endTime: '09:30',
          ),
          Talk(
            id: 't2',
            title: 'Keynote: Digital Transformation in Health Services',
            speaker: 'Prof. Sarah Johnson',
            role: 'Harvard Medical School',
            startTime: '09:30',
            endTime: '10:00',
          ),
        ],
      ),
      ConferenceSession(
        id: 's2',
        title: 'Innovation in Patient Care',
        hall: 'Hall B',
        startTime: '10:30',
        endTime: '12:00',
        type: SessionType.parallel,
        talks: [
          Talk(
            id: 't3',
            title: 'AI-Powered Diagnostics',
            speaker: 'Dr. Michael Chen',
            role: 'Stanford University',
            startTime: '10:30',
            endTime: '11:00',
          ),
          Talk(
            id: 't4',
            title: 'Telemedicine Best Practices',
            speaker: 'Dr. Fatima Hassan',
            role: 'EHS Telemedicine Unit',
            startTime: '11:00',
            endTime: '11:30',
          ),
          Talk(
            id: 't5',
            title: 'Patient Experience Enhancement',
            speaker: 'Sarah Williams',
            role: 'Mayo Clinic',
            startTime: '11:30',
            endTime: '12:00',
          ),
        ],
      ),
      ConferenceSession(
        id: 's3',
        title: 'Healthcare Technology',
        hall: 'Hall C',
        startTime: '10:30',
        endTime: '12:00',
        type: SessionType.parallel,
        talks: [
          Talk(
            id: 't6',
            title: 'Blockchain in Healthcare',
            speaker: 'Dr. James Taylor',
            role: 'MIT',
            startTime: '10:30',
            endTime: '11:00',
          ),
          Talk(
            id: 't7',
            title: 'IoT Medical Devices',
            speaker: 'Dr. Laila Ahmed',
            role: 'Dubai Health Authority',
            startTime: '11:00',
            endTime: '11:30',
          ),
        ],
      ),
    ];
  }

  List<ConferenceSession> _getDay2Sessions() {
    return [
      ConferenceSession(
        id: 's4',
        title: 'Quality & Safety',
        hall: 'Main Hall A',
        startTime: '09:00',
        endTime: '11:00',
        type: SessionType.plenary,
        talks: [
          Talk(
            id: 't8',
            title: 'Patient Safety Standards',
            speaker: 'Dr. Omar Khalil',
            role: 'WHO Representative',
            startTime: '09:00',
            endTime: '10:00',
          ),
          Talk(
            id: 't9',
            title: 'Quality Improvement Strategies',
            speaker: 'Dr. Lisa Anderson',
            role: 'Johns Hopkins',
            startTime: '10:00',
            endTime: '11:00',
          ),
        ],
      ),
    ];
  }

  List<ConferenceSession> _getDay3Sessions() {
    return [
      ConferenceSession(
        id: 's5',
        title: 'Future of Healthcare',
        hall: 'Main Hall A',
        startTime: '09:00',
        endTime: '11:00',
        type: SessionType.plenary,
        talks: [
          Talk(
            id: 't10',
            title: 'Precision Medicine',
            speaker: 'Dr. Robert Kim',
            role: 'UCSF',
            startTime: '09:00',
            endTime: '10:00',
          ),
          Talk(
            id: 't11',
            title: 'Genomic Healthcare',
            speaker: 'Dr. Maria Garcia',
            role: 'Oxford University',
            startTime: '10:00',
            endTime: '11:00',
          ),
        ],
      ),
    ];
  }
}

// Models
enum SessionType { plenary, parallel }

class ConferenceSession {
  final String id;
  final String title;
  final String hall;
  final String startTime;
  final String endTime;
  final SessionType type;
  final List<Talk> talks;

  ConferenceSession({
    required this.id,
    required this.title,
    required this.hall,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.talks,
  });
}

class Talk {
  final String id;
  final String title;
  final String speaker;
  final String role;
  final String startTime;
  final String endTime;

  Talk({
    required this.id,
    required this.title,
    required this.speaker,
    required this.role,
    required this.startTime,
    required this.endTime,
  });
}