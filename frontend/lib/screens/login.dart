import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _countryCode = '+91';
  bool _isLoading = false;
  late AnimationController _cardAnimationController;
  late AnimationController _floatingController;
  late Animation<double> _cardRotation;
  late Animation<double> _cardScale;
  double _parallaxOffset = 0;

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

    _cardRotation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeOutCubic),
    );

    _cardScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeOutCubic),
    );

    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _cardAnimationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number must be exactly 10 digits.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.login(phone: phone, password: password);
      final user = response['user'] as Map<String, dynamic>;
      final token = response['token'] as String;

      if (!context.mounted) {
        return;
      }

      Navigator.pushNamed(
        context,
        '/jobs',
        arguments: {
          'countryCode': _countryCode,
          'phone': phone,
          'fullName': user['name'] ?? '',
          'role': user['role'] ?? 'worker',
          'aadhaarStatus': (user['aadhaarVerified'] == true) ? 'Verified' : 'Pending',
          'token': token,
        },
      );
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
      body: MouseRegion(
        onHover: (event) {
          setState(() {
            _parallaxOffset = event.localPosition.dy / 100;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFD1FAE5),
                const Color(0xFFFFF8ED).withValues(alpha: 0.8)
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(0.02 * _parallaxOffset)
                          ..rotateY(-0.02 * _parallaxOffset),
                        child: const Text(
                          'LaborLink',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0B3A37),
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Find daily work faster. Trusted jobs, fair pay, and one-tap apply.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF334155),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AnimatedBuilder(
                        animation: Listenable.merge(
                            [_cardScale, _cardRotation, _floatingController]),
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
                                  ..rotateX(_cardRotation.value * 0.3)
                                  ..rotateY(_cardRotation.value * -0.2),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0B3A37).withValues(alpha: 0.15),
                                        blurRadius: 40,
                                        offset: Offset(0, 20 + (floatingY * 0.5)),
                                        spreadRadius: 5,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF0B3A37).withValues(alpha: 0.05),
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
                              'Welcome back',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Login',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 18),
                            _build3DInputField(
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
                            const SizedBox(height: 12),
                            _build3DInputField(
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
                            const SizedBox(height: 20),
                            _build3DButton(
                              onPressed: _isLoading ? null : () => _login(context),
                              label: _isLoading ? 'Signing in...' : 'Login',
                            ),
                            const SizedBox(height: 6),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/signup'),
                              child: const Text('Create an account'),
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
      ),
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
              color: const Color(0xFF0B3A37).withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
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
                ..rotateX(0.01 * math.sin(_floatingController.value * 2 * math.pi))
                ..rotateY(0.01 * math.cos(_floatingController.value * 2 * math.pi)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0B3A37).withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                      spreadRadius: 2,
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
