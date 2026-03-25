import 'package:flutter/material.dart';
import 'services/api_service.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    //CEK SIAPA YANG LAGI LOGIN (Dosen atau Mahasiswa)
    final user = ApiService.currentUser;
    final String role = user?['role']?.toLowerCase() ?? 'mahasiswa';

    //BEDAKAN DATA NOTIFIKASI BERDASARKAN ROLE
    final List<Map<String, dynamic>> notifications = (role == 'dosen') 
      ? [
          {
            'title': 'Pengajuan Baru',
            'desc': 'Mahasiswa atas nama Muhammad Iki telah mengajukan KP baru.',
            'time': '10 menit yang lalu',
            'type': 'info', // Gold
          },
          {
            'title': 'Update Berkas',
            'desc': 'Fatimah telah mengunggah revisi laporan untuk kamu tinjau.',
            'time': '3 jam yang lalu',
            'type': 'success', // Hijau
          },
        ]
      : [
          {
            'title': 'Pengajuan Disetujui',
            'desc': 'Selamat! Pengajuan KP kamu di PT. Telkom telah disetujui.',
            'time': '2 jam yang lalu',
            'type': 'success',
          },
          {
            'title': 'Dosen Pembimbing',
            'desc': 'Dosen Pembimbing kamu telah ditetapkan: Dr. Ir. Iki, M.T.',
            'time': '5 jam yang lalu',
            'type': 'info',
          },
        ];


    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          // 🎨 LAYER BACKGROUND: BLOB GRADIENT 🎨
          _buildBackgroundBlob(300, const Color(0xFF337418), const Alignment(-1.2, -0.8)),
          _buildBackgroundBlob(200, const Color(0xFFFFD700), const Alignment(1.2, 0.5)),

          Column(
            children: [
              // ── Custom AppBar ──
              Container(
                padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF337418), Color(0xFF1B4D0C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Notifikasi',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // ── List Notifikasi ──
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return _buildNotificationCard(item);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    Color typeColor;
    IconData iconData;

    switch (item['type']) {
      case 'success':
        typeColor = const Color(0xFF337418);
        iconData = Icons.check_circle_rounded;
        break;
      case 'warning':
        typeColor = const Color(0xFFD32F2F);
        iconData = Icons.error_rounded;
        break;
      default:
        typeColor = const Color(0xFFFFD700);
        iconData = Icons.info_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), // Glassmorphism
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: typeColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF337418)),
                ),
                const SizedBox(height: 4),
                Text(
                  item['desc'],
                  style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  item['time'],
                  style: const TextStyle(fontSize: 11, color: Colors.black38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundBlob(double size, Color color, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(0.12), color.withOpacity(0)],
          ),
        ),
      ),
    );
  }
}