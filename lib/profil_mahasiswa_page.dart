import 'package:flutter/material.dart';
import 'services/api_service.dart';

class ProfilMahasiswaPage extends StatefulWidget {
  const ProfilMahasiswaPage({super.key});

  @override
  State<ProfilMahasiswaPage> createState() => _ProfilMahasiswaPageState();
}

class _ProfilMahasiswaPageState extends State<ProfilMahasiswaPage> {
  Map<String, dynamic>? _pengajuanKP;
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
        _pengajuanKP = result['data'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ApiService.currentUser;
    final String nama = user?['name'] ?? '-';
    final String npm = user?['id_user'] ?? '-';
    final String email = user?['email'] ?? '-';

    final String noTelp = _pengajuanKP?['noTelp'] ?? '-';
    final String namaPartner = _pengajuanKP?['namaPartner'] ?? '-';
    final String npmPartner = _pengajuanKP?['npmPartner'] ?? '-';
    final String noTelpPartner = _pengajuanKP?['noTelpPartner'] ?? '-';
    final String instansi = _pengajuanKP?['instansi'] ?? '-';
    final String status = _pengajuanKP?['status'] ?? 'Belum Diajukan';
    final String dosenPembimbing = _pengajuanKP?['dosenPembimbing'] ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFE6F1FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF185FA5), Color(0xFF378ADD)],
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
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 44,
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
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _isLoading
                ? const Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: Color(0xFF185FA5)),
                )
                : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(
                        'Status Kerja Praktek',
                        Icons.work_outline_rounded,
                        const Color(0xFF185FA5),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFB5D4F4),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              Icons.hourglass_empty_rounded,
                              'Status KP',
                              status,
                              valueColor: _getStatusColor(status),
                            ),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(
                              Icons.business_outlined,
                              'Instansi',
                              instansi,
                            ),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(
                              Icons.school_outlined,
                              'Dosen Pembimbing',
                              dosenPembimbing,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      _buildSectionTitle(
                        'Data Diri',
                        Icons.person_outline_rounded,
                        const Color(0xFF185FA5),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFB5D4F4),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.badge_outlined, 'NPM', npm),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(
                              Icons.person_outline_rounded,
                              'Nama',
                              nama,
                            ),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(Icons.email_outlined, 'Email', email),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(
                              Icons.phone_outlined,
                              'No. Telepon',
                              noTelp,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      _buildSectionTitle(
                        'Data Partner KP',
                        Icons.people_rounded,
                        const Color(0xFF0F6E56),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFB5D4F4),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              Icons.badge_outlined,
                              'NPM',
                              npmPartner,
                            ),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(
                              Icons.person_outline_rounded,
                              'Nama',
                              namaPartner,
                            ),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(
                              Icons.phone_outlined,
                              'No. Telepon',
                              noTelpPartner,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAEEDA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFF9A825).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xFF854F0B),
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Untuk mengubah data profil, silakan hubungi dosen pembimbing Anda. Perubahan data hanya dapat dilakukan oleh dosen.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF854F0B),
                                  height: 1.5,
                                ),
                              ),
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
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0C447C),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF378ADD), size: 20),
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
          style: TextStyle(
            fontSize: 13,
            color: valueColor ?? const Color(0xFF0C447C),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return const Color(0xFF2E7D32);
      case 'ditolak':
        return const Color(0xFFD32F2F);
      case 'menunggu':
        return const Color(0xFFF9A825);
      default:
        return const Color(0xFF378ADD);
    }
  }
}
