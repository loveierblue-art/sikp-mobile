import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaftarBimbinganPage extends StatefulWidget {
  const DaftarBimbinganPage({super.key});

  @override
  State<DaftarBimbinganPage> createState() => _DaftarBimbinganPageState();
}

class _DaftarBimbinganPageState extends State<DaftarBimbinganPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; //jembatan ke db cloud firestore
  bool _isLoading = false;

  //fungsi untuk nampilin detail pengajuan lengkap
  void _showDetailPengajuan(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, //biar tingginya bisa kita atur sendiri
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Detail Pengajuan KP',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
            ),
            const Divider(height: 32),
            _buildDetailRow(Icons.business_rounded, 'Instansi', data['instansi'] ?? '-'),
            _buildDetailRow(Icons.location_on_rounded, 'Alamat Instansi', data['alamat_instansi'] ?? '-'),
            _buildDetailRow(Icons.calendar_today_rounded, 'Durasi', '${data['mulai_kp'] ?? '-'} s/d ${data['selesai_kp'] ?? '-'}'),
            _buildDetailRow(Icons.info_outline_rounded, 'Status', data['status'] ?? '-'),
            const SizedBox(height: 20),
            const Text('Anggota Kelompok:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            _buildMemberTile(data['nama'], data['npm'] ?? data['nim']),
            if (data['partner_nama'] != null && data['partner_nama'] != '')
              _buildMemberTile(data['partner_nama'], data['partner_npm'] ?? data['partner_nim']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF337418)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(String? name, String? id) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline_rounded, size: 18, color: Color(0xFF337418)),
          const SizedBox(width: 10),
          Text('$name ($id)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1),
      body: Stack( //pakai Stack biar hiasan lingkaran bisa numpuk di belakang
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0xFF337418).withOpacity(0.15), Colors.transparent],
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
                  colors: [const Color(0xFFFFD700).withOpacity(0.12), Colors.transparent],
                ),
              ),
            ),
          ),

          Column(
            children: [
              // ── Header ──
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
                            color: Colors.white.withOpacity(0.25),
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
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.assignment_ind_rounded, size: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Daftar Bimbingan',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'AKTIF',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF337418)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Mahasiswa yang sedang proses KP',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── List Mahasiswa Bimbingan ──
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF337418)))
                    : StreamBuilder<QuerySnapshot>(  //data berubah di Firestore, aplikasi otomatis update
                        stream: _firestore
                            .collection('pengajuan_kp')
                            .where('status', isEqualTo: 'Disetujui')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(color: Color(0xFF337418)));
                          }

                          final docs = snapshot.data?.docs ?? [];

                          if (docs.isEmpty) {
                            return const Center(
                              child: Text('Tidak ada bimbingan aktif'),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.all(24),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data = docs[index].data() as Map<String, dynamic>;
                              
                              final String nama1 = data['nama'] ?? '-';
                              final String npm1 = data['npm'] ?? data['nim'] ?? '-';
                              final String nama2 = data['partner_nama'] ?? '';
                              final String npm2 = data['partner_npm'] ?? data['partner_nim'] ?? '';
                              final String instansi = data['instansi'] ?? '-';

                              return InkWell(
                                onTap: () => _showDetailPengajuan(context, data),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFF337418).withOpacity(0.15), width: 1),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                                        child: const Icon(Icons.groups_rounded, color: Color(0xFF4CAF50), size: 24),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Daftar Anggota Kelompok
                                            Text(nama1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF337418))),
                                            Text('NPM: $npm1', style: const TextStyle(fontSize: 11, color: Colors.black45)),
                                            
                                            if (nama2.isNotEmpty) ...[
                                              const SizedBox(height: 6),
                                              Text(nama2, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF337418))),
                                              Text('NPM: $npm2', style: const TextStyle(fontSize: 11, color: Colors.black45)),
                                            ],

                                            const SizedBox(height: 10),
                                            // Icon Instansi Kantor Tetap Ada
                                            Row(
                                              children: [
                                                const Icon(Icons.business_rounded, size: 14, color: Color(0xFF337418)),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    instansi,
                                                    style: const TextStyle(fontSize: 12, color: Color(0xFF337418), fontStyle: FontStyle.italic),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right_rounded, color: Color(0xFFA5D6A7)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}