import 'package:flutter/material.dart';
import 'services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isPressed = false;

  void _handleRegister() async {
    setState(() => _isLoading = true);
    final res = await _apiService.register(
      _idController.text,
      _nameController.text,
      _emailController.text,
      _passController.text,
    );
    setState(() => _isLoading = false);

    if (res['success']) {
      _showSuccessDialog();
    } else {
      _showErrorDialog(res['message'] ?? 'Gagal Mendaftar');
    }
  }

  void _showSuccessDialog() {
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
                decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF337418), size: 36),
              ),
              const SizedBox(height: 16),
              const Text('Aktivasi Berhasil!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF337418))),
              const SizedBox(height: 10),
              const Text('Akun Anda berhasil didaftarkan. Silakan login untuk melanjutkan.',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 46,
                child: ElevatedButton(
                  onPressed: () { Navigator.pop(context); Navigator.pop(context); },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF337418),
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
              const Text('Pendaftaran Gagal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F0F0F))),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF202020),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Coba Lagi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, String hint, IconData icon, {bool isPass = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF337418))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPass,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFF337418)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF337418), width: 2),
            ),
          ),
        ),
      ],
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
                gradient: const LinearGradient(
                  colors: [Color(0xFFF8F8F8), Color(0xFFF0F4EF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
                boxShadow: [BoxShadow(color: const Color(0xFF0F0F0F).withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              padding: const EdgeInsets.only(top: 64, bottom: 40, left: 24, right: 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(color: const Color(0xFF337418).withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF337418), size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Icon(Icons.person_add_rounded, size: 50, color: Color(0xFF337418)),
                  const SizedBox(height: 14),
                  const Text('Daftar Akun', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF337418))),
                  const Text('Lengkapi data untuk mengakses SiKP', style: TextStyle(fontSize: 13, color: Color(0xFF202020))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                children: [
                  _buildField(_idController, 'NPM / NIDN', 'Masukkan NPM atau NIDN', Icons.badge_outlined),
                  const SizedBox(height: 20),
                  _buildField(_nameController, 'Nama Lengkap', 'Masukkan nama lengkap', Icons.person_outline_rounded),
                  const SizedBox(height: 20),
                  _buildField(_emailController, 'Email', 'Masukkan email', Icons.email_outlined),
                  const SizedBox(height: 20),
                  _buildField(_passController, 'Buat Password', 'Minimal 8 karakter', Icons.lock_outline_rounded, isPass: true),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTapDown: (_) => setState(() => _isPressed = true),
                    onTapUp: (_) { setState(() => _isPressed = false); if (!_isLoading) _handleRegister(); },
                    onTapCancel: () => setState(() => _isPressed = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: double.infinity, height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF337418),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _isPressed ? [] : [BoxShadow(color: const Color(0xFF337418).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                      ),
                      transform: _isPressed ? Matrix4.translationValues(0, 3, 0) : Matrix4.identity(),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                            : const Text('Daftar Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah punya akun? ', style: TextStyle(color: Colors.black45, fontSize: 13)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text('Login di sini', style: TextStyle(color: Color(0xFF337418), fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ],
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