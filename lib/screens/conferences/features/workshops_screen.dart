import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkshopsScreen extends StatefulWidget {
  final String conferenceId; // 'accc2026' or 'iccod2026'
  
  const WorkshopsScreen({
    Key? key,
    required this.conferenceId,
  }) : super(key: key);

  @override
  State<WorkshopsScreen> createState() => _WorkshopsScreenState();
}

class _WorkshopsScreenState extends State<WorkshopsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Changed to 2 tabs
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
          'Conference Submissions',
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
                Tab(text: 'Abstract Submission'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const FutureSpeakersForm(),
          AbstractSubmissionInfo(conferenceId: widget.conferenceId),
        ],
      ),
    );
  }
}

// Abstract Submission Info Screen
class AbstractSubmissionInfo extends StatelessWidget {
  final String conferenceId;
  
  const AbstractSubmissionInfo({
    Key? key,
    required this.conferenceId,
  }) : super(key: key);

  // Get conference-specific data
  Map<String, dynamic> get _conferenceData {
    if (conferenceId == 'accc2026') {
      return {
        'title': 'Call for Abstracts',
        'subtitle': 'Share Your Research in Cardiovascular Medicine',
        'submissionUrl': 'https://sys.foldergroup.com/abstracts/abstractsubmission?confid=18509',
        'gradient': const LinearGradient(
          colors: [Color(0xFF004B99), Color(0xFF0066CC)],
        ),
        'icon': Icons.favorite,
        'categories': [
          'Coronary interventions',
          'Interventions for valvular disease',
          'Interventions for heart failure',
          'Peripheral interventions',
          'Interventions for hypertension',
          'Interventions for stroke',
          'Others',
        ],
      };
    } else {
      return {
        'title': 'Call for Abstracts',
        'subtitle': 'Share Your Research in Critical Care and Organ Donation',
        'submissionUrl': 'https://sys.foldergroup.com/abstracts/abstractsubmission?confid=18507',
        'gradient': const LinearGradient(
          colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
        ),
        'icon': Icons.medical_services,
        'categories': [
          'Critical Care Medicine',
          'Organ Donation & Transplantation',
          'Brain Death & Neurological Assessment',
          'Intensive Care Management',
          'Donor Management & Preservation',
          'Transplant Surgery & Techniques',
          'Ethics in Organ Donation',
          'Pediatric Critical Care & Transplantation',
          'Post-Transplant Care',
          'Innovation in Critical Care Technology',
          'Others',
        ],
      };
    }
  }

  Future<void> _launchSubmissionUrl(BuildContext context) async {
  final url = _conferenceData['submissionUrl'] as String;
  final uri = Uri.parse(url);
  
  try {
    // استخدم externalApplication عشان يفتح في البراوزر الخارجي
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    
    if (!launched) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open submission form'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final data = _conferenceData;
    final categories = data['categories'] as List<String>;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(
            icon: data['icon'] as IconData,
            title: data['title'] as String,
            subtitle: data['subtitle'] as String,
            gradient: data['gradient'] as Gradient,
          ),
          
          const SizedBox(height: 24),
          
          // Conference Details
          _buildInfoCard(
            icon: Icons.calendar_today,
            title: '27 – 29 March 2026',
            subtitle: 'Dubai, UAE',
          ),
          
          const SizedBox(height: 24),
          
          // Important Dates
          const Text(
            'Important Dates',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildDateCard(
                  label: 'OPEN',
                  date: '01/12',
                  year: '2025',
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateCard(
                  label: 'DEADLINE',
                  date: '15/02',
                  year: '2026',
                  color: const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateCard(
                  label: 'DECISION',
                  date: '01/03',
                  year: '2026',
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Key Rules
          const Text(
            'Key Submission Rules',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          
          _buildRuleItem('Maximum 250 words, Arial 10pt, English only'),
          _buildRuleItem('One figure/table/graph permitted'),
          _buildRuleItem('Include authors\' names, degrees, and affiliations'),
          _buildRuleItem('Provide corresponding author\'s email'),
          _buildRuleItem('Accepted as e-poster or oral presentation'),
          _buildRuleItem('⚠️ Presenting authors must register before 1 March 2026', isWarning: true),
          
          const SizedBox(height: 24),
          
          // Abstract Categories
          const Text(
            'Abstract Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          
          ...categories.asMap().entries.map((entry) {
            return _buildCategoryItem(entry.key + 1, entry.value);
          }).toList(),
          
          const SizedBox(height: 24),
          
          // Required Sections
          const Text(
            'Required Abstract Sections',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          
          _buildRequiredSection('Title'),
          _buildRequiredSection('Introduction'),
          _buildRequiredSection('Aim/Objective'),
          _buildRequiredSection('Methods'),
          _buildRequiredSection('Results'),
          _buildRequiredSection('Conclusion'),
          
          const SizedBox(height: 32),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _launchSubmissionUrl(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.open_in_new, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Submit Your Abstract',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard({
    required String label,
    required String date,
    required String year,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            year,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String text, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isWarning 
                  ? const Color(0xFFFEF3C7) 
                  : const Color(0xFF2563EB).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isWarning ? Icons.warning_amber : Icons.check,
              size: 14,
              color: isWarning ? const Color(0xFFF59E0B) : const Color(0xFF2563EB),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isWarning ? const Color(0xFFB45309) : const Color(0xFF475569),
                fontWeight: isWarning ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(int number, String category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E8EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredSection(String section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.arrow_right,
            color: Color(0xFF2563EB),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            section,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}

// Future Speakers Grant Form (keeping the same)
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
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: const Color(0xFF94A3B8),
                ),
                child: _isSubmitting
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
            ),
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