import 'package:flutter/material.dart';
import 'services/api_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isPressed = false;

  final Color primaryGreen = const Color(0xFF337418);
  final Color backgroundWhite = const Color(0xFFF8F8F8);
  final Color darkText = const Color(0xFF202020);

  void _handleReset() async {
    if (_emailController.text.isEmpty) {
      _showErrorDialog('Masukkan email Anda terlebih dahulu.');
      return;
    }
    setState(() => _isLoading = true);
    final res = await _apiService.sendResetPasswordEmail(_emailController.text);
    setState(() => _isLoading = false);

    if (res['success']) {
      _showSuccessDialog();
    } else {
      _showErrorDialog(res['message'] ?? 'Email tidak terdaftar.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64, height: 64,
                decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                child: Icon(Icons.check_circle_outline_rounded, color: primaryGreen, size: 36),
              ),
              const SizedBox(height: 16),
              Text('Email Terkirim!', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen)),
              const SizedBox(height: 10),
              const Text(
                'Kami telah mengirimkan link untuk mengatur ulang password ke email Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Login Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64, height: 64,
                decoration: const BoxDecoration(color: Color(0xFFFFEBEB), shape: BoxShape.circle),
                child: const Icon(Icons.error_outline_rounded, color: Color(0xFFD32F2F), size: 36),
              ),
              const SizedBox(height: 16),
              const Text('Gagal Reset', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F))),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [backgroundWhite, const Color(0xFFF0F4EF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 64, bottom: 40, left: 24, right: 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryGreen, size: 20),
                    ),
                  ),
                  Container(
                    width: 70, height: 70,
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lock_reset_rounded, size: 36, color: primaryGreen),
                  ),
                  const SizedBox(height: 16),
                  Text('Reset Password', 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen)),
                  const SizedBox(height: 6),
                  Text('Masukkan email akun SiKP Anda', style: TextStyle(fontSize: 13, color: darkText.withOpacity(0.6))),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email Akun', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: primaryGreen)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan email terdaftar',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: Icon(Icons.email_outlined, color: primaryGreen),
                      filled: true,
                      fillColor: backgroundWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  //tombol update password
                  GestureDetector(
                    onTap: () { if (!_isLoading) _handleReset(); },
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: primaryGreen.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Center(
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : const Text('Kirim Link Reset', 
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Kembali ke Login', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}