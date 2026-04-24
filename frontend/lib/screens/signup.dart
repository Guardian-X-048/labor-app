import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _countryCode = '+91';
  String _role = 'worker';
  bool _isLoading = false;
  late AnimationController _cardAnimationController;
  late AnimationController _floatingController;
  late AnimationController _fieldStaggerController;
  late Animation<double> _cardRotation;
  late Animation<double> _cardScale;
  List<Animation<double>> _fieldAnimations = [];

  static const List<String> _countryCodes = ['+91', '+1', '+44', '+971'];

  @override
  void initState() {
    super.initState();
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat(reverse: true);

    _fieldStaggerController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _cardRotation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeOutCubic),
    );

    _cardScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeOutCubic),
    );

    _fieldAnimations = List.generate(
      5,
      (index) => Tween<double>(begin: -50, end: 0).animate(
        CurvedAnimation(
          parent: _fieldStaggerController,
          curve: Interval(index * 0.15, (index + 1) * 0.15 + 0.4,
              curve: Curves.easeOutCubic),
        ),
      ),
    );

    _cardAnimationController.forward();
    _fieldStaggerController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _cardAnimationController.dispose();
    _floatingController.dispose();
    _fieldStaggerController.dispose();
    super.dispose();
  }

  Future<void> _continue(BuildContext context) async {
    final fullName = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name.')),
      );
      return;
    }

    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number must be exactly 10 digits.')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.signup(
        name: fullName,
        phone: phone,
        password: password,
        role: _role,
      );

      final user = response['user'] as Map<String, dynamic>;
      final token = response['token'] as String;

      if (!context.mounted) {
        return;
      }

      final userArgs = {
        'fullName': user['name'] ?? fullName,
        'countryCode': _countryCode,
        'phone': phone,
        'role': user['role'] ?? _role,
        'token': token,
        'aadhaarStatus': (user['aadhaarVerified'] == true) ? 'Verified' : 'Pending',
      };

      if (_role == 'employer') {
        Navigator.pushNamed(context, '/jobs', arguments: userArgs);
      } else {
        Navigator.pushNamed(context, '/aadhaar-verify', arguments: userArgs);
      }
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                const Color(0xFFFFEDD5),
                const Color(0xFFFFF8ED).withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 470),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _cardScale,
                          _cardRotation,
                          _floatingController,
                        ]),
                        builder: (context, child) {
                          final floatingY =
                              math.sin(_floatingController.value * 2 * math.pi) * 8;
                          return Transform.translate(
                            offset: Offset(0, floatingY),
                            child: Transform.scale(
                              scale: _cardScale.value,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateX(_cardRotation.value * 0.25)
                                  ..rotateY(_cardRotation.value * -0.15),
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFB923C).withValues(alpha: 0.2),
                                        blurRadius: 40,
                                        offset: Offset(0, 20 + (floatingY * 0.5)),
                                        spreadRadius: 5,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFFFB923C).withValues(alpha: 0.05),
                                        blurRadius: 80,
                                        offset: const Offset(0, 40),
                                      ),
                                    ],
                                  ),
                                  child: child,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Set up your profile',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Get discovered by contractors and local job providers.',
                              style: TextStyle(color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 24),
                            _buildAnimatedField(
                              _fieldAnimations[0],
                              child: _build3DInputField(
                                child: TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Full Name',
                                    prefixIcon: Icon(Icons.badge_outlined),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildAnimatedField(
                              _fieldAnimations[1],
                              child: _build3DInputField(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: DropdownButtonFormField<String>(
                                        initialValue: _countryCode,
                                        decoration: const InputDecoration(
                                          labelText: 'Code',
                                          border: InputBorder.none,
                                        ),
                                        items: _countryCodes
                                            .map(
                                              (code) => DropdownMenuItem<String>(
                                                value: code,
                                                child: Text(code),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          if (value == null) {
                                            return;
                                          }
                                          setState(() {
                                            _countryCode = value;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 7,
                                      child: TextField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        decoration: const InputDecoration(
                                          labelText: 'Phone Number',
                                          hintText: '10 digits',
                                          prefixIcon: Icon(Icons.phone_outlined),
                                          counterText: '',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildAnimatedField(
                              _fieldAnimations[2],
                              child: _build3DInputField(
                                child: TextField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.lock_outline),
                                    border: InputBorder.none,
                                  ),
                                  obscureText: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildAnimatedField(
                              _fieldAnimations[3],
                              child: _build3DInputField(
                                child: DropdownButtonFormField<String>(
                                  initialValue: _role,
                                  decoration: const InputDecoration(
                                    labelText: 'Account Type',
                                    prefixIcon: Icon(Icons.groups_outlined),
                                    border: InputBorder.none,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'worker',
                                      child: Text('Worker'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'employer',
                                      child: Text('Employer'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }
                                    setState(() {
                                      _role = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildAnimatedField(
                              _fieldAnimations[4],
                              child: _build3DButton(
                                onPressed: _isLoading ? null : () => _continue(context),
                                label: _isLoading ? 'Creating account...' : 'Continue',
                              ),
                            ),
                          ],
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
  }

  Widget _buildAnimatedField(Animation<double> animation,
      {required Widget child}) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(-0.02),
          child: Transform.translate(
            offset: Offset(0, animation.value),
            child: Opacity(
              opacity: (animation.value + 50) / 50,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _build3DInputField({required Widget child}) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateZ(0.005),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFB923C).withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _build3DButton({
    required VoidCallback? onPressed,
    required String label,
  }) {
    return MouseRegion(
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedBuilder(
          animation: _floatingController,
          builder: (context, _) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0.008 * math.sin(_floatingController.value * 2 * math.pi))
                ..rotateY(0.008 * math.cos(_floatingController.value * 2 * math.pi)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFB923C).withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(label),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
