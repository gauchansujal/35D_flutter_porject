import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repositories.dart';
import 'package:hive_flutter/hive_flutter.dart'; // For debug print

import 'package:flutter_application_1/features/auth/data/datasources/local/auth_local_datasource.dart';

import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _batchController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isLoading = false;

  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl(AuthLocalDataSourceImpl());
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate() || !_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields correctly and agree to terms'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final exists = await _authRepository.isEmailTaken(email);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already registered!')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final user = AuthEntity(
      fullName: _fullNameController.text.trim(),
      email: email,
      phoneNumber: _phoneController.text.trim(),
      batch: _batchController.text.trim(),
      password: _passwordController.text,
    );

    await _authRepository.signup(user);

    // ============ DEBUG: Check Hive Data ============
    final box = await Hive.openBox<AuthEntity>('users');
    debugPrint('=== HIVE USERS BOX ===');
    debugPrint('Total users saved: ${box.length}');
    for (var key in box.keys) {
      final savedUser = box.get(key);
      debugPrint('Key: $key');
      debugPrint('Name: ${savedUser?.fullName}');
      debugPrint('Email: ${savedUser?.email}');
      debugPrint('Phone: ${savedUser?.phoneNumber}');
      debugPrint('Batch: ${savedUser?.batch}');
      debugPrint('-------------------');
    }
    // ===============================================

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup successful! Check console for saved data.'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 40,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Join Us Today',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your account to get started',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 40),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    labelText: 'Full Name',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator:
                      (value) =>
                          value?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: 'Email Address',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) return 'Required';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value!)) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_outlined),
                    labelText: 'Phone Number',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator:
                      (value) =>
                          value?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Batch
                TextFormField(
                  controller: _batchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.school_outlined),
                    labelText: 'Batch (e.g., 36A)',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator:
                      (value) =>
                          value?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    labelText: 'Password',
                    suffixIcon: const Icon(Icons.visibility_off),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator:
                      (value) =>
                          (value?.length ?? 0) < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    labelText: 'Confirm Password',
                    suffixIcon: const Icon(Icons.visibility_off),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text)
                      return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Terms & Conditions
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged:
                          (v) => setState(() => _agreeToTerms = v ?? false),
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the Terms & Conditions and Privacy Policy',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Link
                TextButton(
                  onPressed:
                      () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Already have an account? Login'),
                ),

                // Optional: Debug Button to Check Saved Users Anytime
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    final box = await Hive.openBox<AuthEntity>('users');
                    debugPrint('Current users in Hive: ${box.length}');
                    for (var user in box.values) {
                      debugPrint('Saved: ${user.fullName} - ${user.email}');
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Check console: ${box.length} users saved',
                        ),
                      ),
                    );
                  },
                  child: const Text('CHECK SAVED USERS (Debug)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _batchController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
