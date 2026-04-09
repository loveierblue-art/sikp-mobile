import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'services/api_service.dart';

class DownloadSuratPage extends StatefulWidget {
  const DownloadSuratPage({super.key});

  @override
  State<DownloadSuratPage> createState() => _DownloadSuratPageState();
}

class _DownloadSuratPageState extends State<DownloadSuratPage> {
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

  final List<Map<String, dynamic>> _daftarSurat = [
    {
      'judul': 'Formulir Permohonan\nKerja Praktek',
      'icon': Icons.assignment_outlined,
      'color': Color(0xFF337418),
      'bgColor': Color(0xFFF0FDF4),
      'keterangan': 'Formulir pengajuan KP ke instansi',
      'asset': 'assets/surat_permohonan_kp.pdf',
    },
    {
      'judul': 'Formulir Permohonan\nDosen Pembimbing KP',
      'icon': Icons.person_search_outlined,
      'color': Color(0xFF1B5E20),
      'bgColor': Color(0xFFE8F5E9),
      'keterangan': 'Formulir permintaan dosen pembimbing',
      'asset': 'assets/surat_permohonan_dosen.pdf',
    },
    {
      'judul': 'Surat Tugas\nKerja Praktek',
      'icon': Icons.task_outlined,
      'color': Color(0xFFFFD700),
      'bgColor': Color(0xFFFFF8E1),
      'keterangan': 'Surat tugas resmi dari koordinator KP',
      'asset': 'assets/surat_tugas_kp.pdf',
    },
  ];

  Future<void> _previewPDF(
    BuildContext context,
    String assetPath,
    String judul,
  ) async {
    // Salin dari assets ke temporary file agar bisa dibuka PDFView
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/$judul.pdf');
    await tempFile.writeAsBytes(byteData.buffer.asUint8List());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => _PreviewPDFPage(judul: judul, filePath: tempFile.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String status = _pengajuanKP?['status'] ?? 'Belum Diajukan';
    final bool sudahDikirim = _pengajuanKP?['statusBerkas'] == 'Terkirim';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: SingleChildScrollView(
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
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.download_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Download Surat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tap surat untuk preview sebelum download',
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
                      // Banner belum dikirim
                      if (!sudahDikirim)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFD32F2F).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.lock_outline_rounded,
                                color: Color(0xFFD32F2F),
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Surat belum tersedia. Menunggu konfirmasi dari Koordinator KP.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFD32F2F),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const Text(
                        'Surat Tersedia',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF337418),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // List Surat
                      ..._daftarSurat.map(
                        (surat) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap:
                                sudahDikirim
                                    ? () => _previewPDF(
                                      context,
                                      surat['asset'],
                                      surat['judul'].toString().replaceAll(
                                        '\n',
                                        ' ',
                                      ),
                                    )
                                    : null,
                            child: Opacity(
                              opacity: sudahDikirim ? 1.0 : 0.5,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF337418,
                                    ).withOpacity(0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: surat['bgColor'],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        surat['icon'],
                                        color: surat['color'],
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            surat['judul'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF337418),
                                              height: 1.3,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            surat['keterangan'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      sudahDikirim
                                          ? Icons.arrow_forward_ios_rounded
                                          : Icons.lock_outline_rounded,
                                      color: const Color(0xFF337418),
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Catatan
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFFD700).withOpacity(0.3),
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
                                'Surat hanya tersedia setelah pengajuan KP disetujui dan dikonfirmasi oleh Koordinator Kerja Praktek.',
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
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

// ── Halaman Preview PDF ──
class _PreviewPDFPage extends StatefulWidget {
  final String judul;
  final String filePath;

  const _PreviewPDFPage({required this.judul, required this.filePath});

  @override
  State<_PreviewPDFPage> createState() => _PreviewPDFPageState();
}

class _PreviewPDFPageState extends State<_PreviewPDFPage> {
  int _totalPages = 0;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF337418),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          widget.judul,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_totalPages > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_currentPage + 1} / $_totalPages',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
      body: PDFView(
        filePath: widget.filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onRender: (pages) {
          setState(() => _totalPages = pages ?? 0);
        },
        onPageChanged: (page, total) {
          setState(() => _currentPage = page ?? 0);
        },
      ),
    );
  }
}
