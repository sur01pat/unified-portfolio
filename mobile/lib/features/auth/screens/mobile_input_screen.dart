// lib/features/auth/screens/mobile_input_screen.dart
// UI-ONLY REWORK — NO LOGIC CHANGE, NO SIDE EFFECTS

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'otp_screen.dart';
import '../services/auth_api.dart';

class MobileInputScreen extends StatefulWidget {
  const MobileInputScreen({super.key});

  @override
  State<MobileInputScreen> createState() => _MobileInputScreenState();
}

class _MobileInputScreenState extends State<MobileInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController(text:'9876543210');// ✅ PREPOPULATE DEFAULT NUMBER

  String _countryCode = '+91';
  bool _loading = false;

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final fullNumber = '$_countryCode${_mobileController.text.trim()}';

    setState(() => _loading = true);

    try {
      await AuthApi.sendOtp(fullNumber);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(mobileNumber: fullNumber),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
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
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                /// HERO
                const Text(
                  'Your Investments.\nOne Clear View.',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Track stocks, gold, fixed income & real estate — all in one place.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 32),

                /// VALUE BULLETS
                const _Bullet(icon: Icons.pie_chart, text: 'Real-time portfolio view'),
                const _Bullet(icon: Icons.insights, text: 'Risk & diversification insights'),
                const _Bullet(icon: Icons.notifications, text: 'Maturity & alert reminders'),

                const SizedBox(height: 40),

                /// INPUT CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Continue with mobile number',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'We use OTP for secure, password-free access. Enter 9876543210 to test,DO NOT USE ANY OTHER NUMBER',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              height: 56,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _countryCode,
                                  items: const [
                                    DropdownMenuItem(
                                      value: '+91',
                                      child: Text('+91 🇮🇳'),
                                    ),
                                    DropdownMenuItem(
                                      value: '+1',
                                      child: Text('+1 🇺🇸'),
                                    ),
                                    DropdownMenuItem(
                                      value: '+44',
                                      child: Text('+44 🇬🇧'),
                                    ),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _countryCode = v!),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _mobileController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  hintText: 'Mobile number',
                                  border: OutlineInputBorder(),
                                  counterText: '',
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Mobile number required';
                                  }
                                  if (v.length != 10) {
                                    return 'Enter valid 10-digit number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _sendOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF203A43),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Continue Securely',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// TRUST FOOTER
                const Center(
                  child: Text(
                    '🔒 We never share your number. No spam. Ever.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
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

class _Bullet extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Bullet({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

