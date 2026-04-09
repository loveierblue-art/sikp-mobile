import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/api_service.dart';

class PengumumanPage extends StatefulWidget {
  final bool isDosen;
  const PengumumanPage({super.key, this.isDosen = false});

  @override
  State<PengumumanPage> createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiService _apiService = ApiService();
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();

  void _showTambahDialog() {
    _judulController.clear();
    _isiController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Buat Pengumuman Baru',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF337418),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Judul
                  const Text(
                    'Judul',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF337418),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _judulController,
                    style: const TextStyle(color: Color(0xFF1B3F0D)),
                    decoration: InputDecoration(
                      hintText: 'Masukkan judul pengumuman',
                      hintStyle: const TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: const Color(0xFFF1F8F1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Isi
                  const Text(
                    'Isi Pengumuman',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF337418),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _isiController,
                    maxLines: 5,
                    style: const TextStyle(color: Color(0xFF1B3F0D)),
                    decoration: InputDecoration(
                      hintText: 'Tulis isi pengumuman di sini...',
                      hintStyle: const TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: const Color(0xFFF1F8F1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF337418), Color(0xFF4CAF50)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_judulController.text.isEmpty ||
                              _isiController.text.isEmpty) {
                            return;
                          }
                          final user = ApiService.currentUser;
                          Navigator.pop(context);
                          await _apiService.tambahPengumuman(
                            judul: _judulController.text,
                            isi: _isiController.text,
                            namaDosen: user?['name'] ?? 'Dosen',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Kirim Pengumuman',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
    );
  }

  void _showHapusDialog(String docId, String judul) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEBEB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFD32F2F),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Hapus Pengumuman?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF337418),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Pengumuman "$judul" akan dihapus permanen.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF337418),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              color: Color(0xFF337418),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD32F2F), Color(0xFFE57373)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await _apiService.hapusPengumuman(docId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Hapus',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
      backgroundColor: const Color(0xFFF8FAF8),
      floatingActionButton:
          widget.isDosen
              ? FloatingActionButton(
                onPressed: _showTambahDialog,
                backgroundColor: const Color(0xFF337418),
                child: const Icon(Icons.add_rounded, color: Colors.white),
              )
              : null,
      body: Column(
        children: [
          // ── Header ──
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF337418), Color(0xFF1B4D0C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 64,
              bottom: 40,
              left: 24,
              right: 24,
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.campaign_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Pengumuman',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.isDosen
                      ? 'Kelola pengumuman untuk mahasiswa'
                      : 'Informasi terbaru dari koordinator KP',
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),

          // ── List Pengumuman ──
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore
                      .collection('pengumuman')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF337418)),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          size: 64,
                          color: const Color(0xFF337418).withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada pengumuman',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF337418),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.isDosen
                              ? 'Tap tombol + untuk membuat pengumuman'
                              : 'Pengumuman dari koordinator KP akan muncul di sini',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final String judul = data['judul'] ?? '-';
                    final String isi = data['isi'] ?? '-';
                    final String namaDosen = data['namaDosen'] ?? '-';
                    final createdAt = data['createdAt'] as Timestamp?;
                    final String tanggal =
                        createdAt != null
                            ? _formatTanggal(createdAt.toDate())
                            : '-';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF337418).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header kartu
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF337418).withOpacity(0.05),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF337418,
                                    ).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.campaign_rounded,
                                    color: Color(0xFF337418),
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        judul,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF337418),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$namaDosen • $tanggal',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Tombol hapus hanya untuk dosen
                                if (widget.isDosen)
                                  GestureDetector(
                                    onTap:
                                        () => _showHapusDialog(doc.id, judul),
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFEBEB),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Color(0xFFD32F2F),
                                        size: 18,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Isi pengumuman
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              isi,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTanggal(DateTime date) {
    final List<String> bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${bulan[date.month]} ${date.year}';
  }
}
