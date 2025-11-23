import 'package:flutter/material.dart';



class BookmarksScreen extends StatefulWidget {
  final Set<String> bookmarkedItems;

  final Function(String) onToggleBookmark;

  const BookmarksScreen({
    Key? key,
    required this.bookmarkedItems,
    required this.onToggleBookmark,
  }) : super(key: key);

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  // EHS Brand Colors
  static const Color primaryColor = Color(0xFF344E75);
  static const Color secondaryColor = Color(0xFF85af99);
  static const Color accentColor = Color(0xFFb7d1da);
  static const Color darkColor = Color(0xFF6F6C6F);

  List<BookmarkedItem> _bookmarkedItemsList = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarkedItems();
  }

  void _loadBookmarkedItems() {
    _bookmarkedItemsList = [];
    
    // Get all conference data (you should replace this with your actual data source)
    final allSessions = _getAllSessions();
    
    for (var dayData in allSessions) {
      for (var session in dayData['sessions']) {
        // Check if session is bookmarked
        if (widget.bookmarkedItems.contains(session.id)) {
          _bookmarkedItemsList.add(BookmarkedItem(
            type: BookmarkType.session,
            id: session.id,
            title: session.title,
            day: dayData['day'],
            startTime: session.startTime,
            endTime: session.endTime,
            hall: session.hall,
            sessionType: session.type,
            talksCount: session.talks.length,
          ));
        }
        
        // Check individual talks
        for (var talk in session.talks) {
          if (widget.bookmarkedItems.contains(talk.id)) {
            _bookmarkedItemsList.add(BookmarkedItem(
              type: BookmarkType.talk,
              id: talk.id,
              title: talk.title,
              day: dayData['day'],
              startTime: talk.startTime,
              endTime: talk.endTime,
              hall: session.hall,
              speaker: talk.speaker,
              role: talk.role,
              sessionTitle: session.title,
            ));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'My Bookmarks',
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
                    Positioned(
                      bottom: 60,
                      left: 20,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.bookmark_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_bookmarkedItemsList.length} saved ${_bookmarkedItemsList.length == 1 ? 'item' : 'items'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          _bookmarkedItemsList.isEmpty
              ? SliverFillRemaining(
                  child: _buildEmptyState(),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildBookmarkCard(_bookmarkedItemsList[index]);
                      },
                      childCount: _bookmarkedItemsList.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No bookmarks yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding sessions and talks\nto your favorites!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.explore),
            label: const Text('Explore Program'),
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(BookmarkedItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: item.type == BookmarkType.session
          ? _buildSessionBookmark(item)
          : _buildTalkBookmark(item),
    );
  }

  Widget _buildSessionBookmark(BookmarkedItem item) {
    return Padding(
      padding: const EdgeInsets.all(20),
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
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.dashboard_rounded,
                            size: 14,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Full Session',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    widget.onToggleBookmark(item.id);
                    setState(() {
                      _loadBookmarkedItems();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.favorite,
                      color: secondaryColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildInfoChip(
                Icons.calendar_today,
                item.day,
              ),
              _buildInfoChip(
                Icons.access_time,
                '${item.startTime} - ${item.endTime}',
              ),
              _buildInfoChip(
                Icons.location_on,
                item.hall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 18,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  '${item.talksCount} presentations',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTalkBookmark(BookmarkedItem item) {
    return Padding(
      padding: const EdgeInsets.all(20),
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
                        color: secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mic_rounded,
                            size: 14,
                            color: secondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Individual Talk',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    widget.onToggleBookmark(item.id);
                    setState(() {
                      _loadBookmarkedItems();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.favorite,
                      color: secondaryColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Speaker Info
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: accentColor,
                child: Text(
                  item.speaker?.substring(0, 1).toUpperCase() ?? 'S',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.speaker ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.role ?? '',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildInfoChip(
                Icons.calendar_today,
                item.day,
              ),
              _buildInfoChip(
                Icons.access_time,
                '${item.startTime} - ${item.endTime}',
              ),
              _buildInfoChip(
                Icons.location_on,
                item.hall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Part of: ${item.sessionTitle}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Mock data - Replace with actual data source
  List<Map<String, dynamic>> _getAllSessions() {
    return [
      {
        'day': '27 March 2025',
        'sessions': [
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
            ],
          ),
        ],
      },
      {
        'day': '28 March 2025',
        'sessions': [
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
            ],
          ),
        ],
      },
      {
        'day': '29 March 2025',
        'sessions': [
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
            ],
          ),
        ],
      },
    ];
  }
}

// Models
enum BookmarkType { session, talk }
enum SessionType { plenary, parallel }

class BookmarkedItem {
  final BookmarkType type;
  final String id;
  final String title;
  final String day;
  final String startTime;
  final String endTime;
  final String hall;
  final SessionType? sessionType;
  final int? talksCount;
  final String? speaker;
  final String? role;
  final String? sessionTitle;

  BookmarkedItem({
    required this.type,
    required this.id,
    required this.title,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.hall,
    this.sessionType,
    this.talksCount,
    this.speaker,
    this.role,
    this.sessionTitle,
  });
}

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