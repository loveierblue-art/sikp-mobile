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

    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack), 
      ),
    );

    _slideAnim = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

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

  // MODIFIKASI: Mengubah perpaduan radial gradient agar tampak seperti efek blur (soft glow)
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
            // Menggunakan 3 stop warna agar sebarannya jauh lebih halus seperti blur
            colors: [
              color.withOpacity(0.18), // Pusat agak terang
              color.withOpacity(0.05), // Sebaran tengah
              color.withOpacity(0.0),  // Menghilang di pinggir
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveLoading() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
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
          // MODIFIKASI: Gradient background dibuat lebih rapat transisinya untuk kesan moody/blur
          gradient: LinearGradient(
            colors: [Color(0xFF265411), Color(0xFF133608)], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Blob dibuat lebih besar agar area blurnya luas
            _buildBlob(500, const Color(0xFF5DD62C), top: -180, right: -120), 
            _buildBlob(400, const Color(0xFFFFD700), bottom: -150, left: -100), 
            _buildBlob(300, const Color(0xFF5DD62C), top: 200, left: -150),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Image.asset(
                        'assets/images/logo_unkhair.png', 
                        width: 180, 
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnim.value),
                      child: const Text(
                        'SiKP',
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 8,
                        ),
                      ),
                    ),
                  ),
                  
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnim.value),
                      child: const Text(
                        'Sistem Informasi Kerja Praktek',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),

                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        _buildWaveLoading(),
                        const SizedBox(height: 16),
                        const Text(
                          'Universitas Khairun',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: const Text(
                  'Fakultas Teknik • Teknik Informatika',
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
      ..color = const Color(0xFFFFD700).withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    Path path = Path();
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