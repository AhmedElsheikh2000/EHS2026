import 'package:flutter/material.dart';

class WorkshopsScreen extends StatefulWidget {
  const WorkshopsScreen({Key? key}) : super(key: key);

  @override
  State<WorkshopsScreen> createState() => _WorkshopsScreenState();
}

class _WorkshopsScreenState extends State<WorkshopsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'EHS Conference Features',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A1A2E)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E8EB), width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF2563EB),
              unselectedLabelColor: const Color(0xFF64748B),
              indicatorColor: const Color(0xFF2563EB),
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Future Speakers'),
                Tab(text: 'Championship'),
                Tab(text: 'Best Abstract'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FutureSpeakersForm(),
          ChampionshipForm(),
          BestAbstractForm(),
        ],
      ),
    );
  }
}

// Future Speakers Grant Form
class FutureSpeakersForm extends StatefulWidget {
  const FutureSpeakersForm({Key? key}) : super(key: key);

  @override
  State<FutureSpeakersForm> createState() => _FutureSpeakersFormState();
}

class _FutureSpeakersFormState extends State<FutureSpeakersForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _institutionController = TextEditingController();
  final _topicController = TextEditingController();
  final _motivationController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _institutionController.dispose();
    _topicController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Application submitted successfully! 🎉'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _institutionController.clear();
        _topicController.clear();
        _motivationController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              icon: Icons.mic_rounded,
              title: 'Future Speakers Grant',
              subtitle: 'Apply for funding to present your research',
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Name is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'your.email@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Email is required';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value!)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _institutionController,
              label: 'Institution/Organization',
              hint: 'Your university or company',
              icon: Icons.business_outlined,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Institution is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _topicController,
              label: 'Presentation Topic',
              hint: 'Brief title of your presentation',
              icon: Icons.topic_outlined,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Topic is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _motivationController,
              label: 'Motivation Statement',
              hint: 'Why should you receive this grant?',
              icon: Icons.description_outlined,
              maxLines: 5,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Motivation is required' : null,
            ),
            const SizedBox(height: 30),
            _buildSubmitButton(onPressed: _submitForm),
          ],
        ),
      ),
    );
  }
}

// Championship Form
class ChampionshipForm extends StatefulWidget {
  const ChampionshipForm({Key? key}) : super(key: key);

  @override
  State<ChampionshipForm> createState() => _ChampionshipFormState();
}

class _ChampionshipFormState extends State<ChampionshipForm> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _leaderNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _membersController = TextEditingController();
  final _projectController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _teamNameController.dispose();
    _leaderNameController.dispose();
    _emailController.dispose();
    _membersController.dispose();
    _projectController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registration completed successfully! 🏆'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        _formKey.currentState!.reset();
        _teamNameController.clear();
        _leaderNameController.clear();
        _emailController.clear();
        _membersController.clear();
        _projectController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              icon: Icons.emoji_events_rounded,
              title: 'EHS Championship',
              subtitle: 'Register your team for the competition',
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              controller: _teamNameController,
              label: 'Team Name',
              hint: 'Enter your team name',
              icon: Icons.group_outlined,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Team name is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _leaderNameController,
              label: 'Team Leader Name',
              hint: 'Enter team leader name',
              icon: Icons.person_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Leader name is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Contact Email',
              hint: 'team.email@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Email is required';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value!)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _membersController,
              label: 'Team Members',
              hint: 'List all team members (comma separated)',
              icon: Icons.people_outline,
              maxLines: 3,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Team members are required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _projectController,
              label: 'Project Description',
              hint: 'Describe your championship project',
              icon: Icons.lightbulb_outline,
              maxLines: 5,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Project description is required' : null,
            ),
            const SizedBox(height: 30),
            _buildSubmitButton(onPressed: _submitForm),
          ],
        ),
      ),
    );
  }
}

// Best Abstract Form
class BestAbstractForm extends StatefulWidget {
  const BestAbstractForm({Key? key}) : super(key: key);

  @override
  State<BestAbstractForm> createState() => _BestAbstractFormState();
}

class _BestAbstractFormState extends State<BestAbstractForm> {
  final _formKey = GlobalKey<FormState>();
  final _authorController = TextEditingController();
  final _emailController = TextEditingController();
  final _titleController = TextEditingController();
  final _abstractController = TextEditingController();
  final _keywordsController = TextEditingController();
  String _selectedCategory = 'Research';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _authorController.dispose();
    _emailController.dispose();
    _titleController.dispose();
    _abstractController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Abstract submitted successfully! 📄'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        _formKey.currentState!.reset();
        _authorController.clear();
        _emailController.clear();
        _titleController.clear();
        _abstractController.clear();
        _keywordsController.clear();
        setState(() => _selectedCategory = 'Research');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              icon: Icons.article_rounded,
              title: 'Best Abstract Award',
              subtitle: 'Submit your research abstract for evaluation',
              gradient: const LinearGradient(
                colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              controller: _authorController,
              label: 'Author Name',
              hint: 'Enter primary author name',
              icon: Icons.person_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Author name is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'author.email@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Email is required';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value!)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              value: _selectedCategory,
              label: 'Category',
              icon: Icons.category_outlined,
              items: const ['Research', 'Case Study', 'Review', 'Innovation'],
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _titleController,
              label: 'Abstract Title',
              hint: 'Enter your abstract title',
              icon: Icons.title_outlined,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Title is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _abstractController,
              label: 'Abstract Content',
              hint: 'Enter your complete abstract (max 300 words)',
              icon: Icons.notes_outlined,
              maxLines: 8,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Abstract content is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _keywordsController,
              label: 'Keywords',
              hint: 'Enter keywords (comma separated)',
              icon: Icons.tag_outlined,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Keywords are required' : null,
            ),
            const SizedBox(height: 30),
            _buildSubmitButton(onPressed: _submitForm),
          ],
        ),
      ),
    );
  }
}

// Shared Widgets
Widget _buildHeader({
  required IconData icon,
  required String title,
  required String subtitle,
  required Gradient gradient,
}) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: gradient.colors.first.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 32),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
  int maxLines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
          prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEF4444)),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    ],
  );
}

Widget _buildDropdown({
  required String value,
  required String label,
  required IconData icon,
  required List<String> items,
  required void Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    ],
  );
}

Widget _buildSubmitButton({required VoidCallback onPressed}) {
  return Builder(
    builder: (context) {
      final isSubmitting = context
          .findAncestorStateOfType<_FutureSpeakersFormState>()
          ?._isSubmitting ??
          context.findAncestorStateOfType<_ChampionshipFormState>()?._isSubmitting ??
          context.findAncestorStateOfType<_BestAbstractFormState>()?._isSubmitting ??
          false;

      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: const Color(0xFF94A3B8),
          ),
          child: isSubmitting
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Submit Application',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      );
    },
  );
}