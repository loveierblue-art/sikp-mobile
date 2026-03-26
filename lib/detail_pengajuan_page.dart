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
                decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF2E7D32), size: 36),
              ),
              const SizedBox(height: 16),
              const Text('Setujui Pengajuan?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF337418))),
              const SizedBox(height: 10),
              Text(
                'Pengajuan KP akan disetujui dengan dosen pembimbing:\n\n$_selectedDosen',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
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
                        child: const Text('Batal', style: TextStyle(color: Color(0xFF337418), fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF337418), Color(0xFF4CAF50)]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            setState(() => _isLoading = true);
                            final result = await _apiService.setujuiPengajuan(widget.pengajuan['id'], _selectedDosen!);
                            setState(() => _isLoading = false);
                            if (result['success']) {
                              _showSuksesDialog('Pengajuan berhasil disetujui!');
                            } else {
                              _showErrorDialog(result['message']);
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                          child: const Text('Setujui', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
                decoration: const BoxDecoration(color: Color(0xFFFFEBEB), shape: BoxShape.circle),
                child: const Icon(Icons.cancel_outlined, color: Color(0xFFD32F2F), size: 36),
              ),
              const SizedBox(height: 16),
              const Text('Tolak Pengajuan?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF337418))),
              const SizedBox(height: 10),
              const Text('Pengajuan KP ini akan ditolak.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54)),
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
                        child: const Text('Batal', style: TextStyle(color: Color(0xFF337418), fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFD32F2F), Color(0xFFE57373)]),
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
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                          child: const Text('Tolak', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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

  // [Fungsi _showSuksesDialog, _showErrorDialog, _buildInfoRow, _buildSectionTitle tetap sama seperti sebelumnya...]
  // (Potong di sini untuk efisiensi pesan, pastikan widget build kamu menggunakan _handleSetujui & _handleTolak)

  void _showSuksesDialog(String pesan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF2E7D32), size: 64),
              const SizedBox(height: 16),
              const Text('Berhasil!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF337418))),
              const SizedBox(height: 10),
              Text(pesan, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () { Navigator.pop(context); Navigator.pop(context); },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF337418), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Kembali', style: TextStyle(color: Colors.white)),
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
      builder: (context) => AlertDialog(
        title: const Text('Perhatian'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
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
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black45)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF337418))),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF337418), size: 18),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF337418))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.pengajuan['status'] ?? 'Menunggu';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengajuan', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF337418),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Data Mahasiswa', Icons.person),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.badge, 'NPM', widget.pengajuan['npm'] ?? '-'),
                _buildInfoRow(Icons.person_outline, 'Nama', widget.pengajuan['nama'] ?? '-'),
                const SizedBox(height: 24),
                _buildSectionTitle('Instansi', Icons.business),
                _buildInfoRow(Icons.location_on, 'Alamat', widget.pengajuan['alamatInstansi'] ?? '-'),
                const SizedBox(height: 32),
                
                const Text('Pilih Dosen Pembimbing', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _selectedDosen,
                  isExpanded: true,
                  hint: const Text('Pilih Dosen'),
                  items: _daftarDosen.map((d) => DropdownMenuItem(value: d['name'].toString(), child: Text(d['name'].toString()))).toList(),
                  onChanged: (v) => setState(() => _selectedDosen = v),
                ),
                const SizedBox(height: 40),
                
                Row(
                  children: [
                    Expanded(child: ElevatedButton(onPressed: _handleTolak, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Tolak', style: TextStyle(color: Colors.white)))),
                    const SizedBox(width: 16),
                    Expanded(child: ElevatedButton(onPressed: _handleSetujui, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('Setujui', style: TextStyle(color: Colors.white)))),
                  ],
                )
              ],
            ),
          ),
    );
  }
}