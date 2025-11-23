import 'package:flutter/material.dart';

class AskVoteScreen extends StatefulWidget {
  const AskVoteScreen({Key? key}) : super(key: key);

  @override
  State<AskVoteScreen> createState() => _AskVoteScreenState();
}

class _AskVoteScreenState extends State<AskVoteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _questionController = TextEditingController();
  
  // EHS Brand Colors
  static const Color primaryColor = Color(0xFF344E75);
  static const Color secondaryColor = Color(0xFF85af99);
  static const Color accentColor = Color(0xFFb7d1da);
  static const Color darkColor = Color(0xFF6F6C6F);

  final List<Question> _questions = [
    Question(
      id: '1',
      text: 'What are the latest advances in AI-powered diagnostics?',
      author: 'Dr. Sarah Ahmed',
      time: '5 min ago',
      upvotes: 12,
      isUpvoted: false,
    ),
    Question(
      id: '2',
      text: 'How can we improve patient safety in emergency departments?',
      author: 'Mohammed Ali',
      time: '15 min ago',
      upvotes: 8,
      isUpvoted: false,
    ),
    Question(
      id: '3',
      text: 'What is the future of telemedicine in UAE?',
      author: 'Dr. Layla Hassan',
      time: '30 min ago',
      upvotes: 24,
      isUpvoted: true,
    ),
  ];

  final List<Poll> _polls = [
    Poll(
      id: '1',
      question: 'Which topic interests you most for the next session?',
      options: [
        PollOption(text: 'AI in Critical Care', votes: 24),
        PollOption(text: 'Future of Organ Donation', votes: 15),
        PollOption(text: 'Ethics in Transplantation', votes: 32),
        PollOption(text: 'Precision Medicine', votes: 18),
      ],
      selectedIndex: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _questionController.dispose();
    super.dispose();
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
                  'Ask & Vote',
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
                      colors: [primaryColor, secondaryColor],
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
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            Icon(
                              Icons.question_answer_rounded,
                              size: 60,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Interactive Q&A',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: primaryColor,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.question_answer_rounded),
                        text: 'Ask Questions',
                      ),
                      Tab(
                        icon: Icon(Icons.how_to_vote_rounded),
                        text: 'Vote on Topics',
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
            _buildAskTab(),
            _buildVoteTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAskTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSubmitQuestionCard(),
        const SizedBox(height: 24),
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Recent Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._questions.map((question) => _buildQuestionCard(question)),
      ],
    );
  }

  Widget _buildSubmitQuestionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.edit_note_rounded,
                  color: primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Ask Your Question',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _questionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Type your question for the speaker...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_questionController.text.trim().isNotEmpty) {
                  setState(() {
                    _questions.insert(
                      0,
                      Question(
                        id: DateTime.now().toString(),
                        text: _questionController.text.trim(),
                        author: 'You',
                        time: 'Just now',
                        upvotes: 0,
                        isUpvoted: false,
                      ),
                    );
                  });
                  _questionController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 12),
                          const Text('Your question has been submitted!'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.send_rounded, size: 20),
              label: const Text(
                'Submit Question',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: accentColor,
                child: Text(
                  question.author.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      question.time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question.text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() {
                      question.isUpvoted = !question.isUpvoted;
                      question.upvotes += question.isUpvoted ? 1 : -1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: question.isUpvoted
                          ? secondaryColor.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          question.isUpvoted
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          size: 18,
                          color: question.isUpvoted
                              ? secondaryColor
                              : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${question.upvotes}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: question.isUpvoted
                                ? secondaryColor
                                : Colors.grey[700],
                          ),
                        ),
                      ],
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

  Widget _buildVoteTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ..._polls.map((poll) => _buildPollCard(poll)),
      ],
    );
  }

  Widget _buildPollCard(Poll poll) {
    final totalVotes = poll.options.fold<int>(
      0,
      (sum, option) => sum + option.votes,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.poll_rounded,
                  color: secondaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Live Poll',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$totalVotes votes',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            poll.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ...poll.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final percentage = totalVotes > 0
                ? (option.votes / totalVotes * 100).round()
                : 0;
            final isSelected = poll.selectedIndex == index;

            return _buildPollOption(
              option,
              percentage,
              isSelected,
              () {
                setState(() {
                  if (poll.selectedIndex == null) {
                    poll.selectedIndex = index;
                    option.votes++;
                  }
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPollOption(
    PollOption option,
    int percentage,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? secondaryColor.withOpacity(0.1)
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? secondaryColor : Colors.grey[200]!,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        option.text,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? secondaryColor : Colors.grey[800],
                        ),
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? secondaryColor : primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isSelected ? secondaryColor : primaryColor,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Models
class Question {
  final String id;
  final String text;
  final String author;
  final String time;
  int upvotes;
  bool isUpvoted;

  Question({
    required this.id,
    required this.text,
    required this.author,
    required this.time,
    required this.upvotes,
    required this.isUpvoted,
  });
}

class Poll {
  final String id;
  final String question;
  final List<PollOption> options;
  int? selectedIndex;

  Poll({
    required this.id,
    required this.question,
    required this.options,
    this.selectedIndex,
  });
}

class PollOption {
  final String text;
  int votes;

  PollOption({
    required this.text,
    required this.votes,
  });
}