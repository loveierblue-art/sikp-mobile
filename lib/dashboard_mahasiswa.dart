import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/api_service.dart';
import 'login_page.dart';
import 'ajukan_kp_page.dart';
import 'download_surat_page.dart';
import 'riwayat_pengajuan_page.dart';
import 'lihat_jadwal_page.dart';
import 'pengumuman_page.dart';
import 'alur_kp_page.dart';

class DashboardMahasiswa extends StatefulWidget {
  const DashboardMahasiswa({super.key});

  @override
  State<DashboardMahasiswa> createState() => _DashboardMahasiswaState();
}

class _DashboardMahasiswaState extends State<DashboardMahasiswa> {
  final ApiService _apiService = ApiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;

  Widget _buildBackgroundBlob(double size, Color color, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(0.15), color.withOpacity(0.0)],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final user = ApiService.currentUser;
    final String nama = user?['name'] ?? 'Mahasiswa';
    final String npm = user?['id_user'] ?? '-';

    return Stack(
      children: [
        _buildBackgroundBlob(
          300,
          const Color(0xFF337418),
          const Alignment(-1.2, -0.8),
        ),
        _buildBackgroundBlob(
          250,
          const Color(0xFF5DD62C),
          const Alignment(1.2, 0.2),
        ),
        _buildBackgroundBlob(
          200,
          const Color(0xFFFFD700),
          const Alignment(-1.0, 1.2),
        ),

        SingleChildScrollView(
          child: Column(
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
                  bottom: 32,
                  left: 24,
                  right: 24,
                ),
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
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NPM: $npm',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Mahasiswa Informatika',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFFD700),
                          fontWeight: FontWeight.w600,
                        ),
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
                    // ── Notifikasi Jadwal Bimbingan ──
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          _firestore
                              .collection('jadwal_temu')
                              .where('npm', isEqualTo: npm)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          final belumDibaca =
                              snapshot.data!.docs.where((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return data['dibaca'] == false ||
                                    !data.containsKey('dibaca');
                              }).toList();

                          if (belumDibaca.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return GestureDetector(
                            onTap: () async {
                              for (var doc in belumDibaca) {
                                await doc.reference.update({'dibaca': true});
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LihatJadwalPage(),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B4D0C),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.notification_important_rounded,
                                    color: Color(0xFFFFD700),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Ada ${belumDibaca.length} jadwal bimbingan baru untukmu.',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white54,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // ── Status Pengajuan KP ──
                    const Text(
                      'Status Pengajuan KP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF337418),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStatusCard(),
                    const SizedBox(height: 28),

                    // ── Menu Utama ──
                    const Text(
                      'Menu Utama',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF337418),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream:
                              FirebaseFirestore.instance
                                  .collection('pengajuan_kp')
                                  .where(
                                    'uid',
                                    isEqualTo:
                                        ApiService.currentUser?['uid'] ?? '',
                                  )
                                  .orderBy('createdAt', descending: true)
                                  .limit(1)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            String status = 'Belum Diajukan';
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              status =
                                  snapshot.data!.docs.first['status'] ??
                                  'Belum Diajukan';
                            }
                            final bool sudahDisetujui =
                                status.toLowerCase() == 'disetujui';

                            return _buildMenuCard(
                              context,
                              icon:
                                  sudahDisetujui
                                      ? Icons.check_circle_rounded
                                      : Icons.assignment_add,
                              label: 'Ajukan KP',
                              subtitle:
                                  sudahDisetujui
                                      ? 'Pengajuan sudah disetujui'
                                      : 'Daftar Kerja Praktek',
                              color:
                                  sudahDisetujui
                                      ? Colors.grey
                                      : const Color(0xFF337418),
                              bgColor:
                                  sudahDisetujui
                                      ? const Color(0xFFEEEEEE)
                                      : const Color(0xFFF0FDF4),
                              onTap:
                                  sudahDisetujui
                                      ? () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Pengajuan KP Anda sudah disetujui.',
                                            ),
                                            backgroundColor: Color(0xFF337418),
                                          ),
                                        );
                                      }
                                      : () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const AjukanKpPage(),
                                        ),
                                      ),
                            );
                          },
                        ),
                        _buildMenuCard(
                          context,
                          icon: Icons.event_available_rounded,
                          label: 'Jadwal Temu',
                          subtitle: 'Cek agenda bimbingan',
                          color: const Color(0xFF1B4D0C),
                          bgColor: const Color(0xFFE8F5E9),
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LihatJadwalPage(),
                                ),
                              ),
                        ),
                        _buildMenuCard(
                          context,
                          icon: Icons.history_rounded,
                          label: 'Riwayat KP',
                          subtitle: 'Pantau status berkas',
                          color: const Color(0xFFFFD700),
                          bgColor: const Color(0xFFFFF8E1),
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const RiwayatPengajuanPage(),
                                ),
                              ),
                        ),
                        _buildMenuCard(
                          context,
                          icon: Icons.download_rounded,
                          label: 'Download Surat',
                          subtitle: 'Unduh surat balasan',
                          color: const Color(0xFF5DD62C),
                          bgColor: const Color(0xFFF1F8F1),
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const DownloadSuratPage(),
                                ),
                              ),
                        ),
                        _buildMenuCard(
                          context,
                          icon: Icons.route_rounded,
                          label: 'Alur KP',
                          subtitle: 'Prosedur Kerja Praktek',
                          color: const Color(0xFF1B4D0C),
                          bgColor: const Color(0xFFE8F5E9),
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AlurKpPage(),
                                ),
                              ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body:
          _selectedIndex == 0
              ? _buildDashboard(context)
              : const PengumumanPage(isDosen: false),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF337418),
          unselectedItemColor: Colors.black38,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_rounded),
              label: 'Pengumuman',
            ),
          ],
        ),
      ),
    );
  }

  // ── Status Card Real-time ──
  Widget _buildStatusCard() {
    final user = ApiService.currentUser;
    final String uid = user?['uid'] ?? '';

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('pengajuan_kp')
              .where('uid', isEqualTo: uid)
              .orderBy('createdAt', descending: true)
              .limit(1)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF337418)),
          );
        }

        String status = 'Belum Diajukan';
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          status = snapshot.data!.docs.first['status'] ?? 'Belum Diajukan';
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getStatusColor(status).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getStatusBgColor(status),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(status),
                      color: _getStatusColor(status),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(status),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusDesc(status),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (status == 'Disetujui' || status == 'Ditolak') ...[
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFE0E0E0)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RiwayatPengajuanPage(),
                        ),
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 14,
                        color: _getStatusColor(status),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Lihat detail di Riwayat KP',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(status),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: _getStatusColor(status),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return const Color(0xFF337418);
      case 'menunggu':
        return const Color(0xFFF9A825);
      case 'ditolak':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFF337418);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return const Color(0xFFF0FDF4);
      case 'menunggu':
        return const Color(0xFFFFF8E1);
      case 'ditolak':
        return const Color(0xFFFFEBEB);
      default:
        return const Color(0xFFF8F8F8);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return Icons.check_circle_outline_rounded;
      case 'menunggu':
        return Icons.hourglass_empty_rounded;
      case 'ditolak':
        return Icons.cancel_outlined;
      default:
        return Icons.assignment_outlined;
    }
  }

  String _getStatusDesc(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return 'Pengajuan KP Anda telah disetujui ✓';
      case 'menunggu':
        return 'Menunggu verifikasi dari dosen penanggung jawab';
      case 'ditolak':
        return 'Pengajuan KP Anda ditolak';
      default:
        return 'Anda belum mengajukan Kerja Praktek';
    }
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF337418).withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF337418),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
                      Icons.logout_rounded,
                      color: Color(0xFFD32F2F),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Keluar Aplikasi?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF337418),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Anda akan keluar dari akun ini. Yakin ingin melanjutkan?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
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
                              side: const BorderSide(
                                color: Color(0xFF337418),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Keluar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
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
}
