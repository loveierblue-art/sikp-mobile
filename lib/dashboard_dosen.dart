import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/api_service.dart';
import 'login_page.dart';
import 'detail_pengajuan_page.dart';
import 'pembimbing_page.dart';
import 'list_pengajuan_page.dart';
import 'daftar_bimbingan_page.dart';
import 'jadwal_temu_page.dart';
import 'pengumuman_page.dart';

class DashboardDosen extends StatefulWidget {
  const DashboardDosen({super.key});

  @override
  State<DashboardDosen> createState() => _DashboardDosenState();
}

class _DashboardDosenState extends State<DashboardDosen> {
  List<Map<String, dynamic>> _pengajuanList = [];
  bool _isLoading = true;
  final ApiService _apiService = ApiService();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPengajuan();
  }

  void _loadPengajuan() async {
    final result = await _apiService.getAllPengajuanKP();
    if (mounted) {
      setState(() {
        _pengajuanList = List<Map<String, dynamic>>.from(result['data'] ?? []);
        _isLoading = false;
      });
    }
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
            colors: [color.withOpacity(0.15), color.withOpacity(0.0)],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final user = ApiService.currentUser;
    final String nama = user?['name'] ?? 'Dosen';
    final String nidn = user?['id_user'] ?? '-';
    final String email = user?['email'] ?? '-';

    final int totalPengajuan = _pengajuanList.length;
    final int menunggu =
        _pengajuanList.where((p) => p['status'] == 'Menunggu').length;
    final int disetujui =
        _pengajuanList.where((p) => p['status'] == 'Disetujui').length;

    return Stack(
      children: [
        _buildBackgroundBlob(
          300,
          const Color(0xFF337418),
          const Alignment(-1.1, -1.0),
        ),
        _buildBackgroundBlob(
          250,
          const Color(0xFF5DD62C),
          const Alignment(1.1, 0.4),
        ),
        _buildBackgroundBlob(
          200,
          const Color(0xFFFFD700),
          const Alignment(-1.0, 1.1),
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
                      'NIDN: $nidn',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
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
                        'Dosen',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFFD700),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Statistik
                    Row(
                      children: [
                        _buildStatCard('$totalPengajuan', 'Pengajuan\nMasuk'),
                        const SizedBox(width: 12),
                        _buildStatCard('$menunggu', 'Menunggu\nPersetujuan'),
                        const SizedBox(width: 12),
                        _buildStatCard('$disetujui', 'KP\nDisetujui'),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Menu ──
                    const Text(
                      'Menu',
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
                        _buildMenuCard(
                          icon: Icons.inbox_rounded,
                          label: 'Pengajuan KP',
                          subtitle: 'Lihat pengajuan masuk',
                          color: const Color(0xFF337418),
                          bgColor: const Color(0xFFF0FDF4),
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ListPengajuanPage(),
                                ),
                              ).then((_) => _loadPengajuan()),
                        ),
                        _buildMenuCard(
                          icon: Icons.supervisor_account_rounded,
                          label: 'Pembimbing',
                          subtitle: 'Tentukan dosen pembimbing',
                          color: const Color(0xFF5DD62C),
                          bgColor: const Color(0xFFF0FDF4),
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PembimbingPage(),
                                ),
                              ),
                        ),
                        _buildMenuCard(
                          icon: Icons.assignment_ind_rounded,
                          label: 'Daftar Bimbingan',
                          subtitle: 'List bimbingan aktif',
                          color: const Color(0xFFFFD700),
                          bgColor: const Color(0xFFFFF8E1),
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const DaftarBimbinganPage(),
                                ),
                              ),
                        ),
                        _buildMenuCard(
                          icon: Icons.event_available_rounded,
                          label: 'Jadwal Temu',
                          subtitle: 'Atur waktu konsultasi',
                          color: const Color(0xFF202020),
                          bgColor: const Color(0xFFF8F8F8),
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const JadwalTemuPage(),
                                ),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // ── Pengajuan Terbaru ──
                    const Text(
                      'Pengajuan Terbaru',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF337418),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF337418),
                          ),
                        )
                        : _pengajuanList.isEmpty
                        ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF337418).withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: const Color(0xFF337418).withOpacity(0.1),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Belum ada pengajuan masuk',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF337418),
                                ),
                              ),
                            ],
                          ),
                        )
                        : Column(
                          children:
                              _pengajuanList.take(5).map((pengajuan) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: GestureDetector(
                                    onTap:
                                        () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    DetailPengajuanPage(
                                                      pengajuan: pengajuan,
                                                    ),
                                          ),
                                        ).then((_) => _loadPengajuan()),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: const Color(
                                            0xFF337418,
                                          ).withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: _getStatusBgColor(
                                                pengajuan['status'] ?? '',
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _getStatusIcon(
                                                pengajuan['status'] ?? '',
                                              ),
                                              color: _getStatusColor(
                                                pengajuan['status'] ?? '',
                                              ),
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
                                                  pengajuan['nama'] ?? '-',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF337418),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  pengajuan['instansi'] ?? '-',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black45,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusBgColor(
                                                pengajuan['status'] ?? '',
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              pengajuan['status'] ?? 'Menunggu',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: _getStatusColor(
                                                  pengajuan['status'] ?? '',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                    const SizedBox(height: 28),

                    // ── Profil ──
                    const Text(
                      'Informasi Profil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF337418),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF337418).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildProfilRow(Icons.badge_outlined, 'NIDN', nidn),
                          const Divider(height: 24, color: Color(0xFFF0FDF4)),
                          _buildProfilRow(
                            Icons.person_outline_rounded,
                            'Nama',
                            nama,
                          ),
                          const Divider(height: 24, color: Color(0xFFF0FDF4)),
                          _buildProfilRow(Icons.email_outlined, 'Email', email),
                          const Divider(height: 24, color: Color(0xFFF0FDF4)),
                          _buildProfilRow(
                            Icons.school_outlined,
                            'Role',
                            'Dosen',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
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
              : const PengumumanPage(isDosen: true),
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

  // ── Widget Helpers ──
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return const Color(0xFF337418);
      case 'ditolak':
        return const Color(0xFFD32F2F);
      case 'menunggu':
        return const Color(0xFFFFD700);
      default:
        return const Color(0xFF202020);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return const Color(0xFFF0FDF4);
      case 'ditolak':
        return const Color(0xFFFFEBEB);
      case 'menunggu':
        return const Color(0xFFFFF8E1);
      default:
        return const Color(0xFFF8F8F8);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return Icons.check_circle_outline_rounded;
      case 'ditolak':
        return Icons.cancel_outlined;
      case 'menunggu':
        return Icons.hourglass_empty_rounded;
      default:
        return Icons.assignment_outlined;
    }
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
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
                fontWeight: FontWeight.w600,
                color: Color(0xFF337418),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF337418), size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black45,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF337418),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
