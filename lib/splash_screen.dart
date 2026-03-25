import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dart:math' as Math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _slideAnim = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Pindah ke LoginPage setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => LoginPage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper untuk membuat Bubble Gradient yang estetik
  Widget _buildBlob(double size, Color color, {double top = 0, double right = 0, double? bottom, double? left}) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0)],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveLoading() {
  return AnimatedBuilder(
    animation: _controller,
    builder: (context, child) {
      return Container(
        width: 160,
        height: 10,
        child: CustomPaint(
          painter: WavePainter(_controller.value),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // GANTI: Sekarang menggunakan palet Hijau Tua Khairun
            colors: [Color(0xFF337418), Color(0xFF1B4D0C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // ── LAYER BACKGROUND: BLOB GRADIENT ──
            _buildBlob(300, const Color(0xFF5DD62C), top: -100, right: -50), // Hijau Muda
            _buildBlob(250, const Color(0xFFFFD700), bottom: -50, left: -50), // Gold
            _buildBlob(150, Colors.white, top: 200, right: -30),

            // ── LAYER KONTEN UTAMA ──
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo dengan Background Glass tipis
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: ScaleTransition(
                          scale: _scaleAnim,
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              // GANTI: Warna background glass sekarang Hijau Tua Khairun
                              color: const Color(0xFF337418).withOpacity(0.5), 
                              shape: BoxShape.circle,
                              border: Border.all(
                                // GANTI: Warna border juga Hijau Tua yang lebih tipis
                                color: const Color(0xFF337418).withOpacity(0.7),
                                width: 1.5,
                              ),
                              // Tambahkan Shadow lembut agar logonya lebih menonjol
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              size: 56,
                              color: Colors.white, // GANTI: Ikon Topi sekarang warna PUTIH bersih
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Nama aplikasi
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnim.value),
                          child: const Text(
                            'SiKP',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 6,
                            ),
                          ),
                        ),
                      ),
                      
                      // Subtitle dengan aksen Gold
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnim.value),
                          child: const Text(
                            'Sistem Informasi Kerja Praktek',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFFFD700), // Teks Gold lembut
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),

                      // Loading indicator (Ganti ke Gold agar terlihat mewah)
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: Column(
                          children: [
                            _buildWaveLoading(), // Panggil fungsi gelombang di sini
                            const SizedBox(height: 16),
                            const Text(
                              'Menghubungkan ke server...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Versi aplikasi
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: const Text(
                  'Universitas Khairun • v1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.white30, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double value;
  WavePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white // Warna Putih sesuai request kamu
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    path.moveTo(0, size.height / 2);

    for (double i = 0; i <= size.width; i++) {
      // Logic gelombang: Sinusoida yang bergerak berdasarkan value controller
      path.lineTo(
        i,
        size.height / 2 + (5 * Curves.easeInOut.transform(value) * (i / 20 + value * 10).remainder(2.0 * 3.14).sign * 0.5), 
        // Note: Kamu bisa sederhanakan ini, tapi intinya dia membuat path meliuk
      );
      
      // Cara yang lebih smooth:
      double y = size.height / 2 + 4 * (i / 20 + value * 5).remainder(6.28);
      // Tapi untuk kemudahan, mari pakai sinus sederhana:
      double dy = 4 * (i / 15 + value * 10);
      path.lineTo(i, size.height / 2 + (3 * (i % 20 < 10 ? 1 : -1)));
    }
    
    // Versi Sinus murni agar lebih bergelombang cantik:
    path = Path();
    for (double i = 0; i <= size.width; i++) {
      double y = size.height / 2 + 4 * Math.sin((i / size.width * 2 * 3.14) + (value * 10));
      if (i == 0) path.moveTo(i, y);
      else path.lineTo(i, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Tambahkan import math di paling atas file:
// import 'dart:math' as Math;