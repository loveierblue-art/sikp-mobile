import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'services/api_service.dart';
import 'login_page.dart';
import 'ajukan_kp_page.dart';
import 'download_surat_page.dart';
import 'riwayat_pengajuan_page.dart';
import 'lihat_jadwal_page.dart'; 

class DashboardMahasiswa extends StatefulWidget {
  const DashboardMahasiswa({super.key});

  @override
  State<DashboardMahasiswa> createState() => _DashboardMahasiswaState();
}

class _DashboardMahasiswaState extends State<DashboardMahasiswa> {
  final ApiService _apiService = ApiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentStatus = 'Belum Diajukan';

  //blob background
  Widget _buildBackgroundBlob(double size, Color color, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ApiService.currentUser;
    final String nama = user?['name'] ?? 'Mahasiswa';
    final String npm = user?['id_user'] ?? '-';
    final String email = user?['email'] ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          _buildBackgroundBlob(300, const Color(0xFF337418), const Alignment(-1.2, -0.8)),
          _buildBackgroundBlob(250, const Color(0xFF5DD62C), const Alignment(1.2, 0.2)),
          _buildBackgroundBlob(200, const Color(0xFFFFD700), const Alignment(-1.0, 1.2)),

          SingleChildScrollView(
            child: Column(
              children: [
                // Header
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
                  padding: const EdgeInsets.only(top: 64, bottom: 32, left: 24, right: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'SiKP',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showLogoutDialog(context),
                            child: Container(
                              width: 38, height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.logout_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(nama, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('NPM: $npm', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Mahasiswa Informatika',
                          style: TextStyle(fontSize: 12, color: Color(0xFFFFD700), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- NOTIFIKASI JADWAL BIMBINGAN ---
                      StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection('jadwal_temu').where('npm', isEqualTo: npm).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                            int totalJadwal = snapshot.data!.docs.length;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B4D0C),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.notification_important_rounded, color: Color(0xFFFFD700)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Ada $totalJadwal jadwal bimbingan aktif untukmu.',
                                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 14),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      const Text(
                        'Status Pengajuan KP',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF337418)),
                      ),
                      const SizedBox(height: 12),
                      _buildStatusCard(),
                      const SizedBox(height: 28),

                      const Text('Menu Utama', style: TextStyle(fontSize: 16, 
                      fontWeight: FontWeight.w600, color: Color(0xFF337418)),
                      ),
                      const SizedBox(height: 12),

                      // --- GRID MENU UTAMA ---
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                        children: [
                          _buildMenuCard(
                            context,
                            icon: Icons.assignment_add,
                            label: 'Ajukan KP',
                            subtitle: 'Daftar Kerja Praktek',
                            color: const Color(0xFF337418),
                            bgColor: const Color(0xFFF0FDF4),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AjukanKpPage())),
                          ),
                          // --- MENU JADWAL TEMU ---
                          _buildMenuCard(
                            context,
                            icon: Icons.event_available_rounded,
                            label: 'Jadwal Temu',
                            subtitle: 'Cek agenda bimbingan',
                            color: const Color(0xFF1B4D0C),
                            bgColor: const Color(0xFFE8F5E9),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LihatJadwalPage())),
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.history_rounded,
                            label: 'Riwayat KP',
                            subtitle: 'Pantau status berkas',
                            color: const Color(0xFFFFD700),
                            bgColor: const Color(0xFFFFF8E1),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RiwayatPengajuanPage())),
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.download_rounded,
                            label: 'Download Surat',
                            subtitle: 'Unduh surat balasan',
                            color: const Color(0xFF5DD62C),
                            bgColor: const Color(0xFFF1F8F1),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DownloadSuratPage())),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //komponen buat kartu menu (biar ga nulis ulang-ulang)
  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF337418).withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: _getStatusBgColor(currentStatus), shape: BoxShape.circle),
            child: Icon(_getStatusIcon(currentStatus), color: _getStatusColor(currentStatus), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentStatus, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _getStatusColor(currentStatus))),
                const SizedBox(height: 4),
                Text(_getStatusDesc(currentStatus), style: const TextStyle(fontSize: 12, color: Colors.black45)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Disetujui') return const Color(0xFF337418);
    if (status == 'Menunggu') return const Color(0xFFFFD700);
    return const Color(0xFF337418);
  }

  Color _getStatusBgColor(String status) {
    if (status == 'Disetujui') return const Color(0xFFF0FDF4);
    return const Color(0xFFF8F8F8);
  }

  IconData _getStatusIcon(String status) => status == 'Disetujui' ? Icons.check_circle_outline_rounded : Icons.hourglass_empty_rounded;
  
  String _getStatusDesc(String status) => status == 'Disetujui' ? 'Pengajuan KP Anda telah disetujui' : 'Anda belum mengajukan Kerja Praktek';

  Widget _buildMenuCard(BuildContext context, {required IconData icon, required String label, required String subtitle, required Color color, required Color bgColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF337418).withOpacity(0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const Spacer(),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF337418))),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.black45)),
          ],
        ),
      ),
    );
  }

  //pop-up Logout
  void _showLogoutDialog(BuildContext context) {
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
                width: 64,
                height: 64,
                decoration: const BoxDecoration(color: Color(0xFFFFEBEB), shape: BoxShape.circle),
                child: const Icon(Icons.logout_rounded, color: Color(0xFFD32F2F), size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Keluar Aplikasi?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF337418)), 
              ),
              const SizedBox(height: 10),
              const Text(
                'Anda akan keluar dari akun ini. Yakin ingin melanjutkan?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF337418), width: 1.5), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Batal', style: TextStyle(color: Color(0xFF337418), 
                        fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD32F2F), Color(0xFFE57373)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            await ApiService().logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Keluar', style: TextStyle(color: Colors.white, 
                          fontWeight: FontWeight.w600)),
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
}