import 'package:flutter/material.dart';
import 'services/api_service.dart';

class RiwayatPengajuanPage extends StatefulWidget {
  const RiwayatPengajuanPage({super.key});

  @override
  State<RiwayatPengajuanPage> createState() => _RiwayatPengajuanPageState();
}

class _RiwayatPengajuanPageState extends State<RiwayatPengajuanPage> {
  Map<String, dynamic>? _pengajuan;
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final result = await _apiService.getPengajuanKP();
    if (mounted) {
      setState(() {
        _pengajuan = result['data'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status = _pengajuan?['status'] ?? 'Belum Diajukan';
    final String instansi = _pengajuan?['instansi'] ?? '-';
    final String tanggalMulai = _pengajuan?['tanggalMulai'] ?? '-';
    final String tanggalSelesai = _pengajuan?['tanggalSelesai'] ?? '-';
    final String dosenPembimbing = _pengajuan?['dosenPembimbing'] ?? '-';
    final String nama = _pengajuan?['nama'] ?? '-';
    final String npm = _pengajuan?['npm'] ?? '-';
    final String namaPartner = _pengajuan?['namaPartner'] ?? '-';
    final String npmPartner = _pengajuan?['npmPartner'] ?? '-';

    final bool belumDiajukan = _pengajuan == null;
    final bool menunggu = status.toLowerCase() == 'menunggu';
    final bool disetujui = status.toLowerCase() == 'disetujui';
    final bool ditolak = status.toLowerCase() == 'ditolak';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8), 
      body: Stack(
        children: [
          //blob background
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF337418).withOpacity(0.15),
                    const Color(0xFF337418).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD700).withOpacity(0.12),
                    const Color(0xFFFFD700).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // ── Konten Utama ──
          SingleChildScrollView(
            child: Column(
              children: [
                // ── Header ──
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF337418), Color(0xFF458C26)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 64, bottom: 40, left: 24, right: 24),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.history_rounded, size: 32, color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Riwayat Pengajuan',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Pantau status pengajuan KP Anda',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: Color(0xFF337418)),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Belum Mengajukan ──
                            if (belumDiajukan)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8), // Glassmorphism
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF337418).withOpacity(0.1)),
                                ),
                                child: Column(
                                  children: const [
                                    Icon(Icons.assignment_outlined, size: 56, color: Color(0xFFB5D4B4)),
                                    SizedBox(height: 16),
                                    Text(
                                      'Belum Ada Pengajuan',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF337418)),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Anda belum mengajukan Kerja Praktek. Silakan ajukan melalui menu Ajukan KP.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 13, color: Colors.black45, height: 1.5),
                                    ),
                                  ],
                                ),
                              )
                            else ...[
                              // ── Timeline Status ──
                              const Text(
                                'Status Pengajuan',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF337418)),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8), 
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF337418).withOpacity(0.1)),
                                ),
                                child: Column(
                                  children: [
                                    _buildTimelineStep(
                                      icon: Icons.send_rounded,
                                      title: 'Pengajuan Dikirim',
                                      subtitle: 'Pengajuan KP berhasil dikirim',
                                      isActive: true,
                                      isDone: true,
                                    ),
                                    _buildTimelineLine(isActive: menunggu || disetujui || ditolak),
                                    _buildTimelineStep(
                                      icon: Icons.hourglass_empty_rounded,
                                      title: 'Menunggu Review',
                                      subtitle: 'Koordinator KP sedang mereview',
                                      isActive: menunggu || disetujui || ditolak,
                                      isDone: disetujui || ditolak,
                                    ),
                                    _buildTimelineLine(isActive: disetujui || ditolak, isRed: ditolak),
                                    if (ditolak)
                                      _buildTimelineStep(
                                        icon: Icons.cancel_rounded,
                                        title: 'Pengajuan Ditolak',
                                        subtitle: 'Silakan hubungi koordinator KP',
                                        isActive: true,
                                        isDone: true,
                                        isRed: true,
                                      )
                                    else
                                      _buildTimelineStep(
                                        icon: Icons.check_circle_rounded,
                                        title: 'Pengajuan Disetujui',
                                        subtitle: disetujui ? 'Selamat! Pengajuan KP disetujui' : 'Menunggu keputusan koordinator',
                                        isActive: disetujui,
                                        isDone: disetujui,
                                        isGreen: true,
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // ── Detail Pengajuan ──
                              const Text(
                                'Detail Pengajuan',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF337418)),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8), 
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF337418).withOpacity(0.1)),
                                ),
                                child: Column(
                                  children: [
                                    _buildInfoRow(Icons.person_outline_rounded, 'Nama', nama),
                                    const Divider(height: 24, color: Color(0xFFF1F5F1)),
                                    _buildInfoRow(Icons.badge_outlined, 'NPM', npm),
                                    const Divider(height: 24, color: Color(0xFFF1F5F1)),
                                    _buildInfoRow(Icons.person_outline_rounded, 'Nama Partner', namaPartner),
                                    const Divider(height: 24, color: Color(0xFFF1F5F1)),
                                    _buildInfoRow(Icons.badge_outlined, 'NPM Partner', npmPartner),
                                    const Divider(height: 24, color: Color(0xFFF1F5F1)),
                                    _buildInfoRow(Icons.business_outlined, 'Instansi', instansi),
                                    const Divider(height: 24, color: Color(0xFFF1F5F1)),
                                    _buildInfoRow(Icons.calendar_today_outlined, 'Tgl Mulai', tanggalMulai),
                                    const Divider(height: 24, color: Color(0xFFF1F5F1)),
                                    _buildInfoRow(Icons.calendar_today_outlined, 'Tgl Selesai', tanggalSelesai),
                                  ],
                                ),
                              ),

                              if (disetujui) ...[
                                const SizedBox(height: 24),
                                const Text(
                                  'Dosen Pembimbing',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF337418)),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9).withOpacity(0.8), 
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), shape: BoxShape.circle),
                                        child: const Icon(Icons.school_rounded, color: Color(0xFF2E7D32), size: 24),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Dosen Pembimbing KP', style: TextStyle(fontSize: 12, color: Colors.black45)),
                                            const SizedBox(height: 4),
                                            Text(dosenPembimbing, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                            const SizedBox(height: 24),
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

  Widget _buildTimelineStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isDone,
    bool isRed = false,
    bool isGreen = false,
  }) {
    Color activeColor = const Color(0xFF337418); 
    if (isRed) activeColor = const Color(0xFFD32F2F);
    if (isGreen) activeColor = const Color(0xFF2E7D32);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? activeColor.withOpacity(0.1) : const Color(0xFFF1F5F1),
            shape: BoxShape.circle,
            border: Border.all(color: isActive ? activeColor : const Color(0xFFB5D4B4), width: 2),
          ),
          child: Icon(icon, color: isActive ? activeColor : const Color(0xFFB5D4B4), size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isActive ? activeColor : const Color(0xFFB5D4B4))),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: isActive ? Colors.black45 : const Color(0xFFB5D4B4))),
              ],
            ),
          ),
        ),
        if (isDone)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Icon(Icons.check_circle_rounded, color: isRed ? const Color(0xFFD32F2F) : (isGreen ? const Color(0xFF2E7D32) : const Color(0xFF337418)), size: 20),
          ),
      ],
    );
  }

  Widget _buildTimelineLine({required bool isActive, bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 21, top: 2, bottom: 2),
      child: Container(
        width: 2,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? (isRed ? const Color(0xFFD32F2F) : const Color(0xFF337418)) : const Color(0xFFB5D4B4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFD700), size: 20), 
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black45, fontWeight: FontWeight.w500)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, color: Color(0xFF337418), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}