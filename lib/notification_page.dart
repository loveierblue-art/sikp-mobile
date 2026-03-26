import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl di pubspec.yaml jika belum ada

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          // 🎨 LAYER BACKGROUND: BLOB GRADIENT
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

              // ── List Notifikasi (REAL-TIME) ──
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .where('recipient_id', isEqualTo: currentUserId)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF337418)));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            const Text("Belum ada notifikasi", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data!.docs[index];
                        var data = doc.data() as Map<String, dynamic>;
                        return _buildNotificationCard(data, doc.id);
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

  Widget _buildNotificationCard(Map<String, dynamic> data, String docId) {
    // Logika warna berdasarkan isi pesan atau judul
    Color typeColor = const Color(0xFFFFD700); // Default Gold/Info
    IconData iconData = Icons.info_rounded;

    if (data['title'].toString().contains('Setuju')) {
      typeColor = const Color(0xFF337418);
      iconData = Icons.check_circle_rounded;
    } else if (data['title'].toString().contains('Tolak') || data['title'].toString().contains('Revisi')) {
      typeColor = const Color(0xFFD32F2F);
      iconData = Icons.error_rounded;
    }

    // Format Waktu
    String timeString = "Baru saja";
    if (data['timestamp'] != null) {
      DateTime dt = (data['timestamp'] as Timestamp).toDate();
      timeString = DateFormat('dd MMM, HH:mm').format(dt);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data['is_read'] == true ? Colors.white.withOpacity(0.6) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: data['is_read'] == true ? Colors.transparent : const Color(0xFF337418).withOpacity(0.1),
          width: 1.5,
        ),
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
                  data['title'] ?? 'Notifikasi',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF337418)),
                ),
                const SizedBox(height: 4),
                Text(
                  data['message'] ?? '-',
                  style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  timeString,
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