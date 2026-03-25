import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'dashboard_mahasiswa.dart';
import 'dashboard_dosen.dart';
import 'register_page.dart';
import 'forgot_password.dart';

// --- CLIPPER OMBAK PERSIS REFERENSI ---
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.85);

    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.70);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.85);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 0.75, size.height * 1.0);
    var secondEndPoint = Offset(size.width, size.height * 0.80);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final ApiService _apiService = ApiService();

  final Color primaryGreen = const Color(0xFF337418);
  final Color lightGreen = const Color(0xFF4CAF50);

  void _handleLogin() async {
    final result = await _apiService.login(_idController.text, _passController.text);
    if (result['success'] == true) {
      if (result['role'].toString().toLowerCase() == 'dosen') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardDosen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardMahasiswa()));
      }
    } else {
      _showErrorDialog(result['message']);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, color: Color(0xFFD32F2F), size: 48),
              const SizedBox(height: 16),
              const Text('Login Gagal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
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
            Stack(
              children: [
                Opacity(
                  opacity: 0.2,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: 330,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [lightGreen, primaryGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 315,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryGreen, const Color(0xFF1B4D0C)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 55),
                          Image.asset('assets/images/logo_unkhair.png', width: 100, height: 100),
                          const SizedBox(height: 12),
                          const Text('SiKP', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
                          const Text('Sistem Informasi Kerja Praktek', style: TextStyle(fontSize: 13, color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NPM / NIDN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryGreen)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan NPM/NIDN',
                      prefixIcon: Icon(Icons.person, color: primaryGreen),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Password', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryGreen)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Password',
                      prefixIcon: Icon(Icons.lock, color: primaryGreen),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: const Text('Masuk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())), // SUDAH DIPERBAIKI
                        child: Text('Daftar Akun', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage())), // SUDAH DIPERBAIKI
                        child: Text('Lupa Password?', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 13)),
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