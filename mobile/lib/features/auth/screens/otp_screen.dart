import 'package:flutter/material.dart';
import '../services/auth_api.dart';
import '../services/token_storage.dart';
import '../../portfolio/screens/dashboard_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpScreen({super.key, required this.mobileNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
//------
void _verifyOtp() async {
  final otp = _otpController.text.trim();
  if (otp.length != 6) return;

  try {
    final token =
        await AuthApi.verifyOtp(widget.mobileNumber, otp);

    await TokenStorage.saveToken(token);

    Navigator.pushAndRemoveUntil(
      context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),

      (_) => false,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid OTP')),
    );
  }
}


//-------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OTP sent to ${widget.mobileNumber}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                hintText: 'Enter 6-digit OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyOtp,
                child: const Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
