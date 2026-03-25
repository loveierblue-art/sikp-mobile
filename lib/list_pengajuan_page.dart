import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'detail_pengajuan_page.dart';

class ListPengajuanPage extends StatefulWidget {
  const ListPengajuanPage({super.key});

  @override
  State<ListPengajuanPage> createState() => _ListPengajuanPageState();
}

class _ListPengajuanPageState extends State<ListPengajuanPage> {
  List<Map<String, dynamic>> _pengajuanList = [];
  List<Map<String, dynamic>> _filteredList = [];
  bool _isLoading = true;
  String _filterStatus = 'Semua';
  final ApiService _apiService = ApiService();

  final List<String> _statusFilter = [
    'Semua',
    'Menunggu',
    'Disetujui',
    'Ditolak',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final result = await _apiService.getAllPengajuanKP();
    if (mounted) {
      setState(() {
        _pengajuanList = List<Map<String, dynamic>>.from(result['data'] ?? []);
        _applyFilter();
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    if (_filterStatus == 'Semua') {
      _filteredList = List.from(_pengajuanList);
    } else {
      _filteredList =
          _pengajuanList.where((p) => p['status'] == _filterStatus).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalSemua = _pengajuanList.length;
    final int totalMenunggu =
        _pengajuanList.where((p) => p['status'] == 'Menunggu').length;
    final int totalDisetujui =
        _pengajuanList.where((p) => p['status'] == 'Disetujui').length;
    final int totalDitolak =
        _pengajuanList.where((p) => p['status'] == 'Ditolak').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8), // Background cerah kehijauan
      body: Stack( // Menggunakan Stack untuk Efek Blob
        children: [
          // ── Efek Blob (Lingkaran Gradasi di Belakang) ──
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
                    const Color(0xFF337418).withOpacity(0.2),
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
                    const Color(0xFFFFD700).withOpacity(0.15), // Kuning Gold
                    const Color(0xFFFFD700).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // ── Konten Utama ──
          Column(
            children: [
              // ── Header (Sekarang Hijau Tua) ──
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF337418)], // Gradasi Hijau Tua
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
                        Icons.inbox_rounded,
                        size: 32,
                        color: Color(0xFFFFD700), // Kuning Gold
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Pengajuan KP',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$totalSemua pengajuan masuk',
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    const SizedBox(height: 20),

                    // Statistik
                    Row(
                      children: [
                        _buildStatCard(
                          '$totalMenunggu',
                          'Menunggu',
                          const Color(0xFFFFF8E1).withOpacity(0.9),
                          const Color(0xFFF9A825),
                        ),
                        const SizedBox(width: 10),
                        _buildStatCard(
                          '$totalDisetujui',
                          'Disetujui',
                          const Color(0xFFE8F5E9).withOpacity(0.9),
                          const Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 10),
                        _buildStatCard(
                          '$totalDitolak',
                          'Ditolak',
                          const Color(0xFFFFEBEB).withOpacity(0.9),
                          const Color(0xFFD32F2F),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Filter Tab ──
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        _statusFilter.map((status) {
                          final bool isSelected = _filterStatus == status;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _filterStatus = status;
                                  _applyFilter();
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient:
                                      isSelected
                                          ? const LinearGradient(
                                            colors: [
                                              Color(0xFF1B5E20),
                                              Color(0xFF337418),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          )
                                          : null,
                                  color: isSelected ? null : Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.transparent
                                            : const Color(0xFF337418).withOpacity(0.2),
                                    width: 1,
                                  ),
                                  boxShadow:
                                      isSelected
                                          ? [
                                            BoxShadow(
                                              color: const Color(0xFF337418).withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                          : [],
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : const Color(0xFF337418),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),

              // ── List Pengajuan (Glassmorphism) ──
              Expanded(
                child:
                    _isLoading
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF337418),
                          ),
                        )
                        : _filteredList.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: Color(0xFF337418),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _filterStatus == 'Semua'
                                    ? 'Belum ada pengajuan masuk'
                                    : 'Tidak ada pengajuan $_filterStatus',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1B5E20),
                                ),
                              ),
                            ],
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: () async => _loadData(),
                          color: const Color(0xFF337418),
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              final pengajuan = _filteredList[index];
                              final String status =
                                  pengajuan['status'] ?? 'Menunggu';
                              final String nama = pengajuan['nama'] ?? '-';
                              final String npm = pengajuan['npm'] ?? '-';
                              final String instansi = pengajuan['instansi'] ?? '-';
                              final String namaPartner =
                                  pengajuan['namaPartner'] ?? '-';
                              final String tanggalMulai =
                                  pengajuan['tanggalMulai'] ?? '-';
                              final String tanggalSelesai =
                                  pengajuan['tanggalSelesai'] ?? '-';

                              return GestureDetector(
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DetailPengajuanPage(
                                              pengajuan: pengajuan,
                                            ),
                                      ),
                                    ).then((_) => _loadData()),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    // Glassmorphism effect: Opacity 0.8
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
                                      // Baris atas: nama & badge status
                                      Row(
                                        children: [
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: _getStatusBgColor(status),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _getStatusIcon(status),
                                              color: _getStatusColor(status),
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
                                                  nama,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF1B5E20),
                                                  ),
                                                ),
                                                Text(
                                                  'NPM: $npm',
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
                                              color: _getStatusBgColor(status),
                                              borderRadius: BorderRadius.circular(
                                                20,
                                              ),
                                            ),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: _getStatusColor(status),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(
                                        height: 1,
                                        color: Color(0xFFE8F5E9),
                                      ),
                                      const SizedBox(height: 12),

                                      // Info tambahan
                                      _buildInfoChip(
                                        Icons.people_rounded,
                                        'Partner: $namaPartner',
                                      ),
                                      const SizedBox(height: 6),
                                      _buildInfoChip(
                                        Icons.business_outlined,
                                        instansi,
                                      ),
                                      const SizedBox(height: 6),
                                      _buildInfoChip(
                                        Icons.date_range_rounded,
                                        '$tanggalMulai  →  $tanggalSelesai',
                                      ),
                                      const SizedBox(height: 10),

                                      // Tombol lihat detail (Kuning Gold)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF337418).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Lihat Detail',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFFFFD700), // Kuning Gold
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 12,
                                                color: Color(0xFFFFD700), // Kuning Gold
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF337418)), // Hijau Tua
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
        return const Color(0xFF337418);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return const Color(0xFFE8F5E9);
      case 'ditolak':
        return const Color(0xFFFFEBEB);
      case 'menunggu':
        return const Color(0xFFFFF8E1);
      default:
        return const Color(0xFFF1F8E9);
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
}