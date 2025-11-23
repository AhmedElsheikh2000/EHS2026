import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpeakersTab extends StatefulWidget {
  final Color conferenceColor;
  final String? conferenceId;
  
  const SpeakersTab({
    Key? key,
    this.conferenceColor = const Color(0xFF2196F3),
    this.conferenceId,
  }) : super(key: key);

  @override
  State<SpeakersTab> createState() => _SpeakersTabState();
}

class _SpeakersTabState extends State<SpeakersTab> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isGridView = false;
  late AnimationController _animationController;

  final List<String> _filters = ['All', 'Keynote', 'Workshop', 'Panel', 'Lightning Talk'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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
    final filteredSpeakers = _getFilteredSpeakers();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSearchHeader(),
          _buildFilterChips(),
          _buildSpeakersList(filteredSpeakers),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.conferenceColor,
                widget.conferenceColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      title: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Search speakers...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
          onPressed: () => setState(() => _isGridView = !_isGridView),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _filters.map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(filter),
                  onSelected: (selected) {
                    setState(() => _selectedFilter = filter);
                  },
                  backgroundColor: Colors.white,
                  selectedColor: widget.conferenceColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  elevation: isSelected ? 4 : 1,
                  shadowColor: widget.conferenceColor.withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeakersList(List<Speaker> speakers) {
    if (speakers.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_search, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'No speakers found',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return _isGridView
        ? SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildSpeakerGridCard(speakers[index], index),
                childCount: speakers.length,
              ),
            ),
          )
        : SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildSpeakerListCard(speakers[index], index),
                childCount: speakers.length,
              ),
            ),
          );
  }

  Widget _buildSpeakerListCard(Speaker speaker, int index) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1, curve: Curves.easeOut),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(index * 0.1, 1, curve: Curves.easeOut),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showSpeakerDetails(speaker),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'speaker_${speaker.id}',
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.conferenceColor.withOpacity(0.8),
                              widget.conferenceColor,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.conferenceColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            speaker.name.split(' ').map((e) => e[0]).take(2).join(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            speaker.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            speaker.title,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSessionInfo(speaker),
                          const SizedBox(height: 12),
                          _buildSocialIcons(speaker),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeakerGridCard(Speaker speaker, int index) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1, curve: Curves.easeOut),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _showSpeakerDetails(speaker),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'speaker_${speaker.id}',
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.conferenceColor.withOpacity(0.8),
                            widget.conferenceColor,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          speaker.name.split(' ').map((e) => e[0]).take(2).join(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    speaker.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    speaker.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  _buildSocialIcons(speaker),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionInfo(Speaker speaker) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(Icons.topic_outlined, speaker.topic, Colors.purple),
        const SizedBox(height: 6),
        _buildInfoRow(Icons.room_outlined, speaker.hall, Colors.orange),
        const SizedBox(height: 6),
        _buildInfoRow(Icons.access_time, speaker.time, Colors.green),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcons(Speaker speaker) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (speaker.email != null) _buildSocialButton(Icons.email, speaker.email!, Colors.red),
        if (speaker.linkedin != null) _buildSocialButton(Icons.business, speaker.linkedin!, Colors.blue[700]!),
        if (speaker.twitter != null) _buildSocialButton(Icons.tag, speaker.twitter!, Colors.blue[400]!),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String contact, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => _handleContactTap(contact),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }

  void _handleContactTap(String contact) {
    Clipboard.setData(ClipboardData(text: contact));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $contact'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSpeakerDetails(Speaker speaker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Hero(
                tag: 'speaker_${speaker.id}',
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.conferenceColor.withOpacity(0.8),
                          widget.conferenceColor,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.conferenceColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        speaker.name.split(' ').map((e) => e[0]).take(2).join(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                speaker.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                speaker.title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildDetailSection('Biography', speaker.bio, Icons.person),
              const SizedBox(height: 24),
              _buildDetailSection('Topic', speaker.topic, Icons.topic),
              const SizedBox(height: 24),
              _buildDetailSection('Session Details', '${speaker.sessionType} • ${speaker.time}', Icons.event),
              const SizedBox(height: 24),
              _buildDetailSection('Location', speaker.hall, Icons.room),
              const SizedBox(height: 32),
              Text(
                'Connect',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (speaker.email != null)
                    _buildContactChip(Icons.email, speaker.email!, Colors.red),
                  if (speaker.linkedin != null)
                    _buildContactChip(Icons.business, speaker.linkedin!, Colors.blue[700]!),
                  if (speaker.twitter != null)
                    _buildContactChip(Icons.tag, speaker.twitter!, Colors.blue[400]!),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: widget.conferenceColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContactChip(IconData icon, String contact, Color color) {
    return InkWell(
      onTap: () => _handleContactTap(contact),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              contact,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Speaker> _getFilteredSpeakers() {
    List<Speaker> speakers = _getSampleSpeakers();

    if (_searchQuery.isNotEmpty) {
      speakers = speakers
          .where((s) =>
              s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.topic.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_selectedFilter != 'All') {
      speakers = speakers.where((s) => s.sessionType == _selectedFilter).toList();
    }

    return speakers;
  }

  List<Speaker> _getSampleSpeakers() {
    // Check conference ID to return different speakers
    if (widget.conferenceId == 'accc2026') {
      return _getACCCSpeakers();
    } else if (widget.conferenceId == 'iccod2026') {
      return _getICCODSpeakers();
    }
    
    // Default speakers
    return _getDefaultSpeakers();
  }

  List<Speaker> _getACCCSpeakers() {
    return [
      Speaker(
        id: '1',
        name: 'Dr. Ahmed Hassan',
        title: 'Chief Cardiologist at Dubai Heart Center',
        topic: 'Advances in Interventional Cardiology',
        sessionType: 'Keynote',
        hall: 'Main Hall A',
        time: 'Day 1, 09:00 AM - 10:30 AM',
        bio: 'Dr. Ahmed Hassan is a leading expert in interventional cardiology with over 20 years of experience. He has performed thousands of cardiac procedures and pioneered new techniques.',
        email: 'ahmed.h@dubaiheartcenter.ae',
        linkedin: 'linkedin.com/in/ahmedhassan',
        twitter: '@drahmedcardio',
      ),
      Speaker(
        id: '2',
        name: 'Prof. Fatima Al Mansoori',
        title: 'Head of Cardiac Surgery, Al Qassimi Hospital',
        topic: 'Minimally Invasive Cardiac Surgery',
        sessionType: 'Workshop',
        hall: 'Hall B',
        time: 'Day 1, 11:00 AM - 12:30 PM',
        bio: 'Professor Fatima is an internationally recognized cardiac surgeon specializing in minimally invasive techniques. She has trained surgeons across the Middle East.',
        email: 'f.almansoori@alqassimi.ae',
        linkedin: 'linkedin.com/in/fatimamansoori',
      ),
      Speaker(
        id: '3',
        name: 'Dr. Mohammed Ibrahim',
        title: 'Electrophysiology Specialist',
        topic: 'Arrhythmia Management in 2026',
        sessionType: 'Panel',
        hall: 'Conference Room 1',
        time: 'Day 2, 02:00 PM - 03:00 PM',
        bio: 'Dr. Mohammed is an expert in cardiac electrophysiology with a focus on complex arrhythmia ablation procedures.',
        email: 'm.ibrahim@ehscardio.ae',
        twitter: '@drmohcardio',
      ),
    ];
  }

  List<Speaker> _getICCODSpeakers() {
    return [
      Speaker(
        id: '1',
        name: 'Dr. Sumaya AlZarooni',
        title: 'Critical Care Director, Emirates Health Services',
        topic: 'ICU Management Protocols in Critical Care',
        sessionType: 'Keynote',
        hall: 'Main Hall A',
        time: 'Day 1, 09:00 AM - 10:30 AM',
        bio: 'Dr. Sumaya is the President of the conference and a leading expert in critical care medicine with extensive experience in ICU management.',
        email: 'sumaya.alzarooni@ehs.gov.ae',
        linkedin: 'linkedin.com/in/sumayaalzarooni',
        twitter: '@drsumayaicu',
      ),
      Speaker(
        id: '2',
        name: 'Prof. Islam Elfeky',
        title: 'Transplant Committee Head',
        topic: 'Organ Transplantation in Critical Care',
        sessionType: 'Workshop',
        hall: 'Hall B',
        time: 'Day 1, 11:00 AM - 12:30 PM',
        bio: 'Professor Islam is a renowned expert in organ transplantation and critical care management for transplant patients.',
        email: 'i.elfeky@ehs.gov.ae',
        linkedin: 'linkedin.com/in/islamelfeky',
      ),
      Speaker(
        id: '3',
        name: 'Dr. Mahmoud Mousa',
        title: 'ICU Program Lead',
        topic: 'Emergency Medicine in Critical Care Settings',
        sessionType: 'Panel',
        hall: 'Conference Room 1',
        time: 'Day 2, 02:00 PM - 03:00 PM',
        bio: 'Dr. Mahmoud specializes in emergency medicine and leads the ICU program with innovative approaches to critical care.',
        email: 'm.mousa@ehs.gov.ae',
        twitter: '@drmahmoudicu',
      ),
    ];
  }

  List<Speaker> _getDefaultSpeakers() {
    return [
      Speaker(
        id: '1',
        name: 'Dr. Sarah Johnson',
        title: 'Chief Technology Officer at TechCorp',
        topic: 'AI in Healthcare: Transforming Patient Care',
        sessionType: 'Keynote',
        hall: 'Main Hall A',
        time: 'Today, 09:00 AM - 10:30 AM',
        bio: 'Dr. Sarah Johnson is a renowned expert in artificial intelligence with over 15 years of experience in healthcare technology.',
        email: 'sarah.j@techcorp.com',
        linkedin: 'linkedin.com/in/sarahjohnson',
        twitter: '@sarahjtech',
      ),
    ];
  }
}

class Speaker {
  final String id;
  final String name;
  final String title;
  final String topic;
  final String sessionType;
  final String hall;
  final String time;
  final String bio;
  final String? email;
  final String? linkedin;
  final String? twitter;

  Speaker({
    required this.id,
    required this.name,
    required this.title,
    required this.topic,
    required this.sessionType,
    required this.hall,
    required this.time,
    required this.bio,
    this.email,
    this.linkedin,
    this.twitter,
  });
}