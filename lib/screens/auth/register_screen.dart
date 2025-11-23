import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  String? _memberType;
  String? _subMemberType;

  final _membershipIdController = TextEditingController();
  final _hospitalController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  DateTime? _selectedDate;
  bool _showRegisterForm = false;

  @override
  void dispose() {
    _membershipIdController.dispose();
    _hospitalController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _proceedToRegister() {
    if (_memberType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select member type")),
      );
      return;
    }

    if (_memberType == "Member") {
      if (_subMemberType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select In-source or Out-source")),
        );
        return;
      }
      if (_subMemberType == "In-source" && _membershipIdController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter Membership ID")),
        );
        return;
      }
      if (_subMemberType == "Out-source" && _hospitalController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter Hospital/Organization")),
        );
        return;
      }
    }

    setState(() => _showRegisterForm = true);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF344E75),
              onPrimary: Colors.white,
              onSurface: Color(0xFF344E75),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF344E75), Color(0xFF4A6FA5)],
          ),
        ),
        child: Stack(
          children: [
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: NetworkBackgroundPainter(color: Colors.white.withOpacity(0.05)),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: !_showRegisterForm ? _buildMemberSelection() : _buildRegisterForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberSelection() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          ),
          child: const Icon(Icons.how_to_reg, color: Colors.white, size: 64),
        ),
        const SizedBox(height: 24),
        const Text(
          "Create Account",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          "Join EHS Conferences Today",
          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
        ),
        const SizedBox(height: 40),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                value: "Member",
                groupValue: _memberType,
                onChanged: (val) => setState(() {
                  _memberType = val;
                  _subMemberType = null;
                }),
                activeColor: Colors.white,
                title: const Text("EHS Member", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              RadioListTile<String>(
                value: "Non-Member",
                groupValue: _memberType,
                onChanged: (val) => setState(() {
                  _memberType = val;
                  _subMemberType = null;
                }),
                activeColor: Colors.white,
                title: const Text("EHS Non-Member", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ),

              if (_memberType == "Member") ...[
                const Divider(color: Colors.white30, height: 32),
                RadioListTile<String>(
                  value: "In-source",
                  groupValue: _subMemberType,
                  onChanged: (val) => setState(() => _subMemberType = val),
                  activeColor: Colors.white,
                  title: const Text("In-source", style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
                if (_subMemberType == "In-source")
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _membershipIdController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Membership ID",
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                        prefixIcon: const Icon(Icons.badge, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),
                RadioListTile<String>(
                  value: "Out-source",
                  groupValue: _subMemberType,
                  onChanged: (val) => setState(() => _subMemberType = val),
                  activeColor: Colors.white,
                  title: const Text("Out-source", style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
                if (_subMemberType == "Out-source")
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _hospitalController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Hospital / Organization",
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                        prefixIcon: const Icon(Icons.local_hospital, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _proceedToRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF344E75),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: const Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
          child: const Text(
            "Already have an account? Sign In",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        TextButton(
  onPressed: () {
    Navigator.pushReplacementNamed(context, "/home");
  },
  child: const Text(
    "Skip",
    style: TextStyle(
      color: Colors.white70,
      fontSize: 12,
      fontStyle: FontStyle.italic,
    ),
  ),
),

      ],
    );
  }
  

  Widget _buildRegisterForm() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          "Complete Your Profile",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          "Please provide your details",
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name *",
                    prefixIcon: Icon(Icons.person_outline, color: Color(0xFF344E75)),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? "Please enter your full name" : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email Address *",
                    prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF344E75)),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || !v.contains("@") ? "Please enter a valid email" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: "UAE Phone Number *",
                    prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF344E75)),
                    prefixText: "+971 ",
                    border: OutlineInputBorder(),
                    hintText: "50 123 4567",
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Please enter your phone number";
                    if (v.trim().length < 9) return "Phone number must be at least 9 digits";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: "Date of Birth *",
                      prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF344E75)),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? "Select your birth date"
                          : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                      style: TextStyle(
                        color: _selectedDate == null ? Colors.grey[600] : Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password *",
                    prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF344E75)),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Please enter a password";
                    if (v.length < 6) return "Password must be at least 6 characters";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password *",
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF344E75)),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v != _passwordController.text ? "Passwords do not match" : null,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please select your date of birth")),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Registration Successful!"),
                            backgroundColor: Color(0xFF27AE60),
                          ),
                        );

                        Navigator.pushReplacementNamed(
                          context,
                          "/home",
                          arguments: {
                            "userName": _nameController.text.trim(),
                            "phoneNumber": "+971${_phoneController.text.trim()}",
                            "email": _emailController.text.trim(),
                            "birthDate": _selectedDate,
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF344E75),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NetworkBackgroundPainter extends CustomPainter {
  final Color color;
  NetworkBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final random = math.Random(42);
    for (int i = 0; i < 10; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final endX = random.nextDouble() * size.width;
      final endY = random.nextDouble() * size.height;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
    final dotPaint = Paint()..color = color..style = PaintingStyle.fill;
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(NetworkBackgroundPainter oldDelegate) => color != oldDelegate.color;
}