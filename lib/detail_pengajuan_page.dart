import 'package:flutter/material.dart';
import 'services/api_service.dart';

class DetailPengajuanPage extends StatefulWidget {
  final Map<String, dynamic> pengajuan;

  const DetailPengajuanPage({super.key, required this.pengajuan});

  @override
  State<DetailPengajuanPage> createState() => _DetailPengajuanPageState();
}

class _DetailPengajuanPageState extends State<DetailPengajuanPage> {
  String? _selectedDosen;
  bool _isLoading = false;
  List<Map<String, dynamic>> _daftarDosen = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadDaftarDosen();
  }

  void _loadDaftarDosen() async {
    final result = await _apiService.getDaftarDosen();
    if (mounted) {
      setState(() {
        _daftarDosen = List<Map<String, dynamic>>.from(result['data'] ?? []);
      });
    }
  }

  void _handleSetujui() {
    if (_selectedDosen == null) {
      _showErrorDialog('Silakan pilih dosen pembimbing terlebih dahulu.');
      return;
    }
    _showKonfirmasiSetujui();
  }

  void _handleTolak() {
    _showKonfirmasiTolak();
  }

  void _showKonfirmasiSetujui() {
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
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Color(0xFF2E7D32),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Setujui & Kirim Berkas?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF337418),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Pengajuan KP akan disetujui dengan dosen pembimbing:\n\n$_selectedDosen\n\nBerkas akan langsung tersedia untuk mahasiswa.',
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
                        child: SizedBox(
                          height: 46,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFFA5D6A7),
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
                                colors: [Color(0xFF337418), Color(0xFF4CAF50)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                setState(() => _isLoading = true);
                                final result = await _apiService
                                    .setujuiPengajuan(
                                      widget.pengajuan['id'],
                                      _selectedDosen!,
                                    );
                                if (result['success']) {
                                  await _apiService.kirimBerkas(
                                    widget.pengajuan['id'],
                                  );
                                }
                                setState(() => _isLoading = false);
                                if (result['success']) {
                                  _showSuksesDialog(
                                    'Pengajuan berhasil disetujui dan berkas telah dikirim ke mahasiswa!',
                                  );
                                } else {
                                  _showErrorDialog(result['message']);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: const Text(
                                'Setujui',
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

  void _showKonfirmasiTolak() {
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
                      Icons.cancel_outlined,
                      color: Color(0xFFD32F2F),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tolak Pengajuan?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF337418),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Pengajuan KP ini akan ditolak.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
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
                                color: Color(0xFFA5D6A7),
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
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                setState(() => _isLoading = true);
                                final result = await _apiService.tolakPengajuan(
                                  widget.pengajuan['id'],
                                );
                                setState(() => _isLoading = false);
                                if (result['success']) {
                                  _showSuksesDialog(
                                    'Pengajuan berhasil ditolak.',
                                  );
                                } else {
                                  _showErrorDialog(result['message']);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: const Text(
                                'Tolak',
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

  void _showSuksesDialog(String pesan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF2E7D32),
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Berhasil!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF337418),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pesan,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF337418),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Kembali',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Perhatian'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFF337418)),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF337418), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black45),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF337418),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF337418), size: 18),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF337418),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.pengajuan['status'] ?? 'Menunggu';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Pengajuan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF337418),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF337418)),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusBgColor(status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Data Mahasiswa
                    _buildSectionTitle('Data Mahasiswa', Icons.person),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.badge,
                      'NPM',
                      widget.pengajuan['npm'] ?? '-',
                    ),
                    _buildInfoRow(
                      Icons.person_outline,
                      'Nama',
                      widget.pengajuan['nama'] ?? '-',
                    ),
                    _buildInfoRow(
                      Icons.phone_outlined,
                      'No. Telp',
                      widget.pengajuan['noTelp'] ?? '-',
                    ),
                    const SizedBox(height: 20),

                    // Data Partner
                    _buildSectionTitle('Data Partner', Icons.people),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.badge,
                      'NPM Partner',
                      widget.pengajuan['npmPartner'] ?? '-',
                    ),
                    _buildInfoRow(
                      Icons.person_outline,
                      'Nama Partner',
                      widget.pengajuan['namaPartner'] ?? '-',
                    ),
                    _buildInfoRow(
                      Icons.phone_outlined,
                      'No. Telp Partner',
                      widget.pengajuan['noTelpPartner'] ?? '-',
                    ),
                    const SizedBox(height: 20),

                    // Instansi
                    _buildSectionTitle('Instansi', Icons.business),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.business_outlined,
                      'Nama',
                      widget.pengajuan['instansi'] ?? '-',
                    ),
                    _buildInfoRow(
                      Icons.location_on,
                      'Alamat',
                      widget.pengajuan['alamatInstansi'] ?? '-',
                    ),
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      'Tgl Mulai',
                      widget.pengajuan['tanggalMulai'] ?? '-',
                    ),
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      'Tgl Selesai',
                      widget.pengajuan['tanggalSelesai'] ?? '-',
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Dosen
                    const Text(
                      'Pilih Dosen Pembimbing',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF337418),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F8F1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF337418).withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDosen,
                          isExpanded: true,
                          hint: const Text(
                            'Pilih Dosen',
                            style: TextStyle(color: Colors.black45),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF337418),
                          ),
                          items:
                              _daftarDosen
                                  .map(
                                    (d) => DropdownMenuItem(
                                      value: d['name'].toString(),
                                      child: Text(d['name'].toString()),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) => setState(() => _selectedDosen = v),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Tombol Tolak & Setujui
                    if (status == 'Menunggu')
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFD32F2F),
                                      Color(0xFFE57373),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: _handleTolak,
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Tolak',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF337418),
                                      Color(0xFF4CAF50),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: _handleSetujui,
                                  icon: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Setujui',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getStatusBgColor(status),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(status).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getStatusIcon(status),
                              color: _getStatusColor(status),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              status == 'Disetujui'
                                  ? 'Pengajuan sudah disetujui'
                                  : 'Pengajuan sudah ditolak',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(status),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return const Color(0xFF337418);
      case 'ditolak':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFFFFD700);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return const Color(0xFFF0FDF4);
      case 'ditolak':
        return const Color(0xFFFFEBEB);
      default:
        return const Color(0xFFFFF8E1);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return Icons.check_circle_outline_rounded;
      case 'ditolak':
        return Icons.cancel_outlined;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }
}
