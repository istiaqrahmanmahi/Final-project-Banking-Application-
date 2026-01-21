
import 'package:banking_app/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:banking_app/widgets/custom_text_field.dart';
import 'package:banking_app/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text !=
        _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final AuthResponse response =
          await SupabaseService.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;

      if (user == null) {
        throw const AuthException('User creation failed');
      }

      await SupabaseService.client.from('profile').insert({
        'id': user.id,
        'full_name': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'avatar_url': '',
      });

      if (!mounted) return;

      // 3️⃣ Success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully. Please check your email to verify.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();

    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      backgroundColor: const Color.fromARGB(255, 147, 202, 202),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 95, 198, 219),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Let\'s set up your account.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please enter your details exactly as they appear on your legal documents.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 32),

                InputField(
                  controller: _fullNameController,
                  keyboardType: TextInputType.text,
                  label: 'Full Name',
                  hintText: 'R Rahman',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    } else if (!RegExp(r'^[A-Za-z .]{3,}$')
                        .hasMatch(value)) {
                      return 'Invalid format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                InputField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  label: 'Email Address',
                  hintText: 'example@email.com',
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Invalid format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                InputField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  label: 'Mobile Number',
                  hintText: '+8801XXXXXXXXX',
                  prefixIcon: Icons.phone_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    } else if (!RegExp(
                            r'^(?:\+88)?01[3-9]\d{8}$')
                        .hasMatch(value)) {
                      return 'Invalid format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                InputField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  label: 'Password (min 8 chars)',
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (!RegExp(
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$')
                        .hasMatch(value)) {
                      return 'Password too weak';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                InputField(
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  label: 'Confirm Password',
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                CustomButton(
                  text: _isLoading
                      ? 'Creating...'
                      : 'Create Account',
                  onPressed:
                      _isLoading ? null : _handleCreateAccount,
                  icon: Icons.arrow_forward,
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
