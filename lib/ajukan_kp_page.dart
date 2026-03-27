import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'dart:ui';

class AjukanKpPage extends StatefulWidget {
  const AjukanKpPage({super.key});

  @override
  State<AjukanKpPage> createState() => _AjukanKpPageState();
}

class _AjukanKpPageState extends State<AjukanKpPage> {
  final _namaController = TextEditingController();
  final _namaPasanganController = TextEditingController();
  final _npmSendiriController = TextEditingController();
  final _npmPasanganController = TextEditingController();
  final _instansiController = TextEditingController();
  final _alamatInstansiController = TextEditingController();
  final _noTelpSendiriController = TextEditingController();
  final _noTelpPasanganController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isPressed = false;
  bool _isLoading = false;

  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;

  final List<String> _bulan = [
    '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  String _formatTanggal(DateTime? date) {
    if (date == null) return '-';
    return '${date.day} ${_bulan[date.month]} ${date.year}';
  }

  Future<void> _pilihTanggalMulai() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF337418), // Hijau Tua
            onPrimary: Colors.white,
            onSurface: Color(0xFF1B3F0D),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _tanggalMulai = picked;
        if (_tanggalSelesai != null && _tanggalSelesai!.isBefore(picked)) {
          _tanggalSelesai = null;
        }
      });
    }
  }

  Future<void> _pilihTanggalSelesai() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalMulai ?? DateTime.now(),
      firstDate: _tanggalMulai ?? DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF337418), // Hijau Tua
            onPrimary: Colors.white,
            onSurface: Color(0xFF1B3F0D),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _tanggalSelesai = picked);
    }
  }

  void _handleSubmit() async {
    if (_namaController.text.isEmpty ||
        _namaPasanganController.text.isEmpty ||
        _npmSendiriController.text.isEmpty ||
        _npmPasanganController.text.isEmpty ||
        _instansiController.text.isEmpty ||
        _alamatInstansiController.text.isEmpty ||
        _noTelpSendiriController.text.isEmpty ||
        _noTelpPasanganController.text.isEmpty) {
      _showErrorDialog('Harap isi semua data terlebih dahulu.');
      return;
    }

    if (_tanggalMulai == null || _tanggalSelesai == null) {
      _showErrorDialog('Harap pilih tanggal mulai dan tanggal selesai KP.');
      return;
    }

    setState(() => _isLoading = true);

    final result = await _apiService.ajukanKP(
      nama: _namaController.text,
      npm: _npmSendiriController.text,
      noTelp: _noTelpSendiriController.text,
      namaPartner: _namaPasanganController.text,
      npmPartner: _npmPasanganController.text,
      noTelpPartner: _noTelpPasanganController.text,
      instansi: _instansiController.text,
      alamatInstansi: _alamatInstansiController.text,
      tanggalMulai: _formatTanggal(_tanggalMulai),
      tanggalSelesai: _formatTanggal(_tanggalSelesai),
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      _showSuccessDialog();
    } else {
      _showErrorDialog(result['message']);
    }
  }

  void _showSuccessDialog() {
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
                width: 64, height: 64,
                decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF2E7D32), size: 36),
              ),
              const SizedBox(height: 16),
              const Text('Pengajuan Terkirim!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3F0D))),
              const SizedBox(height: 10),
              const Text('Pengajuan KP Anda berhasil dikirim.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 46,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF337418), Color(0xFF4E942D)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () { Navigator.pop(context); Navigator.pop(context); },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    child: const Text('Kembali ke Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64, height: 64,
                decoration: const BoxDecoration(color: Color(0xFFFFEBEB), shape: BoxShape.circle),
                child: const Icon(Icons.error_outline_rounded, color: Color(0xFFD32F2F), size: 36),
              ),
              const SizedBox(height: 16),
              const Text('Perhatian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3F0D))),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 46,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF337418), Color(0xFF4E942D)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    child: const Text('Isi Ulang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, String hint, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF337418), letterSpacing: 0.4)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          style: const TextStyle(color: Color(0xFF1B3F0D)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF86A87A)),
            prefixIcon: Icon(icon, color: const Color(0xFF4E942D)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFB5CFAC), width: 1.5)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFB5CFAC), width: 1.5)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF337418), width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime? selectedDate, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF337418), letterSpacing: 0.4)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFB5CFAC), width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: Color(0xFF4E942D), size: 20),
                const SizedBox(width: 12),
                Text(
                  selectedDate == null ? 'Pilih tanggal' : _formatTanggal(selectedDate),
                  style: TextStyle(fontSize: 14, color: selectedDate == null ? const Color(0xFF86A87A) : const Color(0xFF1B3F0D)),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF4E942D), size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1B3F0D))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8EE),
      body: Stack(
        children: [
          // ── Efek Blob (latar belakang) ──
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

          SingleChildScrollView(
            child: Column(
              children: [
                // ── Header ──
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
                        child: const Icon(Icons.assignment_add, size: 32, color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      const Text('Ajukan KP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      const Text('Isi form berikut untuk mengajukan Kerja Praktek', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.white70)),
                    ],
                  ),
                ),

                // ── Form ──
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8), // Opacity 0.8
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('Data Anda', Icons.person_rounded, const Color(0xFF337418)),
                            const SizedBox(height: 16),
                            _buildField(_namaController, 'Nama Lengkap', 'Masukkan nama lengkap Anda', Icons.person_outline_rounded),
                            const SizedBox(height: 16),
                            _buildField(_npmSendiriController, 'NPM Anda', 'Masukkan NPM Anda', Icons.badge_outlined, keyboard: TextInputType.number),
                            const SizedBox(height: 16),
                            _buildField(_noTelpSendiriController, 'No. Telepon Anda', 'Masukkan nomor telepon Anda', Icons.phone_outlined, keyboard: TextInputType.phone),
                            
                            const SizedBox(height: 28),
                            _buildSectionLabel('Data Partner KP', Icons.people_rounded, const Color(0xFFFFD700)), // Kuning Gold
                            const SizedBox(height: 16),
                            _buildField(_namaPasanganController, 'Nama Lengkap Partner', 'Masukkan nama lengkap partner', Icons.person_outline_rounded),
                            const SizedBox(height: 16),
                            _buildField(_npmPasanganController, 'NPM Partner', 'Masukkan NPM partner', Icons.badge_outlined, keyboard: TextInputType.number),
                            
                            const SizedBox(height: 28),
                            _buildSectionLabel('Instansi Tujuan', Icons.business_rounded, const Color(0xFF337418)),
                            const SizedBox(height: 16),
                            _buildField(_instansiController, 'Nama Instansi', 'Masukkan nama instansi', Icons.business_outlined),
                            const SizedBox(height: 16),
                            _buildField(_alamatInstansiController, 'Alamat Instansi', 'Masukkan alamat instansi', Icons.location_on_outlined),
                            
                            const SizedBox(height: 28),
                            _buildSectionLabel('Tanggal Pelaksanaan', Icons.date_range_rounded, const Color(0xFFFFD700)), // Kuning Gold
                            const SizedBox(height: 16),
                            _buildDatePicker('Tanggal Mulai', _tanggalMulai, _pilihTanggalMulai),
                            const SizedBox(height: 16),
                            _buildDatePicker('Tanggal Selesai', _tanggalSelesai, _pilihTanggalSelesai),
                            
                            const SizedBox(height: 32),
                            // Tombol Kirim (Gradasi Hijau)
                            GestureDetector(
                              onTapDown: (_) => setState(() => _isPressed = true),
                              onTapUp: (_) { setState(() => _isPressed = false); if (!_isLoading) _handleSubmit(); },
                              onTapCancel: () => setState(() => _isPressed = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: double.infinity, height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Color(0xFF337418), Color(0xFF4E942D)]),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: _isPressed ? [] : [BoxShadow(color: const Color(0xFF337418).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                                ),
                                transform: _isPressed ? Matrix4.translationValues(0, 3, 0) : Matrix4.identity(),
                                child: Center(
                                  child: _isLoading 
                                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5) 
                                    : const Text('Kirim Pengajuan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}