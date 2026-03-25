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
  bool _isPressed = false;
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

  void _handleSetujui() async {
    if (_selectedDosen == null) {
      _showErrorDialog('Silakan pilih dosen pembimbing terlebih dahulu.');
      return;
    }
    _showKonfirmasiSetujui();
  }

  void _handleTolak() {
    _showKonfirmasiTolak();
  }

  // ====================== DIALOG SETUJU ======================
  void _showKonfirmasiSetujui() {
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
                'Setujui Pengajuan?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF337418),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Pengajuan KP akan disetujui dengan dosen pembimbing:\n\n$_selectedDosen',
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
                          side: const BorderSide(color: Color(0xFFA5D6A7), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(color: Color(0xFF337418), fontWeight: FontWeight.w600),
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
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            setState(() => _isLoading = true);
                            final result = await _apiService.setujuiPengajuan(
                              widget.pengajuan['id'],
                              _selectedDosen!,
                            );
                            setState(() => _isLoading = false);
                            if (result['success']) {
                              _showSuksesDialog('Pengajuan berhasil disetujui!');
                            } else {
                              _showErrorDialog(result['message']);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Setujui',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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

  // ====================== DIALOG TOLAK ======================
  void _showKonfirmasiTolak() {
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
                          side: const BorderSide(color: Color(0xFFA5D6A7), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(color: Color(0xFF337418), fontWeight: FontWeight.w600),
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
                            Navigator.pop(context);
                            setState(() => _isLoading = true);
                            final result = await _apiService.tolakPengajuan(widget.pengajuan['id']);
                            setState(() => _isLoading = false);
                            if (result['success']) {
                              _showSuksesDialog('Pengajuan berhasil ditolak.');
                            } else {
                              _showErrorDialog(result['message']);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Tolak',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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

  // ====================== DIALOG SUKSES ======================
  void _showSuksesDialog(String pesan) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF337418), Color(0xFF4CAF50)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Kembali ke Dashboard',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====================== DIALOG ERROR ======================
  void _showErrorDialog(String message) {
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
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFD32F2F),
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Perhatian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF337418),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF337418), Color(0xFF4CAF50)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Mengerti',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
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
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF337418),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF337418).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF337418), size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF337418),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String namaMahasiswa = widget.pengajuan['nama'] ?? '-';
    final String npmMahasiswa = widget.pengajuan['npm'] ?? '-';
    final String noTelpMahasiswa = widget.pengajuan['noTelp'] ?? '-';
    final String namaPartner = widget.pengajuan['namaPartner'] ?? '-';
    final String npmPartner = widget.pengajuan['npmPartner'] ?? '-';
    final String noTelpPartner = widget.pengajuan['noTelpPartner'] ?? '-';
    final String instansi = widget.pengajuan['instansi'] ?? '-';
    final String alamat = widget.pengajuan['alamatInstansi'] ?? '-';
    final String status = widget.pengajuan['status'] ?? 'Menunggu';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1),
      body: Stack(
        children: [
          // ================== BLOB GRADIENT BACKGROUND ==================
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF337418).withOpacity(0.18),
                    const Color(0xFF337418).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD700).withOpacity(0.10),
                    const Color(0xFFFFD700).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // ================== KONTEN UTAMA ==================
          SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1B5E20), Color(0xFF337418)],
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
                              color: Colors.white.withOpacity(0.25),
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
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.assignment_outlined,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Detail Pengajuan KP',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
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

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Data Mahasiswa', Icons.person_rounded),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF337418).withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.person_outline_rounded, 'Nama', namaMahasiswa),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(Icons.badge_outlined, 'NPM', npmMahasiswa),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(Icons.phone_outlined, 'No. Telepon', noTelpMahasiswa),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildSectionTitle('Data Partner KP', Icons.people_rounded),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF337418).withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.person_outline_rounded, 'Nama', namaPartner),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(Icons.badge_outlined, 'NPM', npmPartner),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(Icons.phone_outlined, 'No. Telepon', noTelpPartner),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildSectionTitle('Instansi Tujuan', Icons.business_rounded),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF337418).withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.business_outlined, 'Instansi', instansi),
                            const Divider(height: 24, color: Color(0xFFE6F1FB)),
                            _buildInfoRow(Icons.location_on_outlined, 'Alamat', alamat),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildSectionTitle('Dosen Pembimbing', Icons.school_rounded),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF337418).withOpacity(0.15),
                            width: 1.5,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedDosen,
                            isExpanded: true,
                            hint: const Text(
                              'Pilih dosen pembimbing',
                              style: TextStyle(color: Color(0xFF81C784), fontSize: 14),
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF337418),
                            ),
                            items: _daftarDosen.map((dosen) {
                              return DropdownMenuItem<String>(
                                value: dosen['name'],
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline_rounded,
                                      color: Color(0xFF337418),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      dosen['name'] ?? '-',
                                      style: const TextStyle(
                                        color: Color(0xFF337418),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _selectedDosen = value);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF337418),
                              ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 52,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFD32F2F), Color(0xFFE57373)],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: ElevatedButton.icon(
                                        onPressed: _handleTolak,
                                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                                        label: const Text(
                                          'Tolak',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTapDown: (_) => setState(() => _isPressed = true),
                                    onTapUp: (_) {
                                      setState(() => _isPressed = false);
                                      _handleSetujui();
                                    },
                                    onTapCancel: () => setState(() => _isPressed = false),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 150),
                                      height: 52,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF337418), Color(0xFF4CAF50)],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: _isPressed
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: const Color(0xFF337418).withOpacity(0.4),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                      ),
                                      transform: _isPressed
                                          ? Matrix4.translationValues(0, 3, 0)
                                          : Matrix4.identity(),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check_rounded, color: Colors.white, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'Setujui',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
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
      ),
    );
  }
}