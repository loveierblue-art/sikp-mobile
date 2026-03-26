import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/api_service.dart';
import 'dart:ui';

class LihatJadwalPage extends StatelessWidget {
  const LihatJadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = ApiService.currentUser;
    final String npmMahasiswa = user?['id_user'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8EE), // Background Hijau Sangat Muda
      body: Stack(
        children: [
          // ── Efek Blob (Latar Belakang) ──
          Positioned(
            top: 150, right: -50,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [const Color(0xFF337418).withOpacity(0.3), Colors.transparent]),
              ),
            ),
          ),
          Positioned(
            bottom: 100, left: -50,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [const Color(0xFFFFD700).withOpacity(0.2), Colors.transparent]),
              ),
            ),
          ),

          Column(
            children: [
              // ── Header (Gradient Hijau) ──
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF337418), Color(0xFF4E942D)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
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
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.event_available_rounded, size: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 14),
                    const Text('Jadwal Temu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                    const SizedBox(height: 6),
                    const Text('Pantau jadwal bimbingan aktif dari dosen pembimbing', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.white70)),
                  ],
                ),
              ),

              // ── List Jadwal dengan Glassmorphism ──
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('jadwal_temu')
                      .where('npm', isEqualTo: npmMahasiswa)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF337418)));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return _buildJadwalCard(data);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF337418).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, size: 16, color: Color(0xFF337418)),
                          const SizedBox(width: 8),
                          Text(data['tanggal'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF337418))),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(data['jam'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4E942D))),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Perihal Bimbingan:', style: TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  data['perihal'] ?? 'Pembahasan Kerja Praktek',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1B3F0D)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 16, color: Color(0xFFFFD700)),
                    const SizedBox(width: 8),
                    const Text('Gedung Informatika Unkhair', style: TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 80, color: const Color(0xFF337418).withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text('Belum ada jadwal masuk.', style: TextStyle(color: Color(0xFF337418), fontWeight: FontWeight.w500)),
          const Text('Hubungi dosen pembimbing jika diperlukan.', style: TextStyle(color: Colors.black38, fontSize: 12)),
        ],
      ),
    );
  }
}