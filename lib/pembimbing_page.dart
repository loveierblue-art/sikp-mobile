import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PembimbingPage extends StatefulWidget {
  const PembimbingPage({super.key});

  @override
  State<PembimbingPage> createState() => _PembimbingPageState();
}

class _PembimbingPageState extends State<PembimbingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _namaController = TextEditingController();
  final _nidnController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isPressed = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nidnController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ================== BOTTOM SHEET DIALOG (Sudah Fixed) ==================
  void _showTambahDialog({Map<String, dynamic>? existing, String? docId}) {
    if (existing != null) {
      _namaController.text = existing['name'] ?? '';
      _nidnController.text = existing['id_user'] ?? '';
      _emailController.text = existing['email'] ?? '';
    } else {
      _namaController.clear();
      _nidnController.clear();
      _emailController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_add_rounded,
                          color: Color(0xFF337418),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          existing != null ? 'Edit Dosen Pembimbing' : 'Tambah Dosen Pembimbing',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF337418),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  _buildDialogField(
                    _namaController,
                    'Nama Lengkap',
                    'Masukkan nama lengkap',
                    Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 16),

                  _buildDialogField(
                    _nidnController,
                    'NIDN',
                    'Masukkan NIDN',
                    Icons.badge_outlined,
                    keyboard: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  _buildDialogField(
                    _emailController,
                    'Email',
                    'Masukkan email dosen',
                    Icons.email_outlined,
                    keyboard: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFA5D6A7), width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(color: Color(0xFF337418), fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
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
                                if (_namaController.text.isEmpty ||
                                    _nidnController.text.isEmpty ||
                                    _emailController.text.isEmpty) return;

                                Navigator.pop(context);
                                setState(() => _isLoading = true);

                                if (existing != null && docId != null) {
                                  await _firestore.collection('dosen_pembimbing').doc(docId).update({
                                    'name': _namaController.text,
                                    'id_user': _nidnController.text,
                                    'email': _emailController.text,
                                    'updatedAt': FieldValue.serverTimestamp(),
                                  });
                                } else {
                                  await _firestore.collection('dosen_pembimbing').add({
                                    'name': _namaController.text,
                                    'id_user': _nidnController.text,
                                    'email': _emailController.text,
                                    'role': 'dosen',
                                    'createdAt': FieldValue.serverTimestamp(),
                                  });
                                }
                                setState(() => _isLoading = false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                existing != null ? 'Simpan' : 'Tambah',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
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
      },
    );
  }

  // ================== HAPUS DIALOG (Sudah disesuaikan warna) ==================
  void _showHapusDialog(String docId, String nama) {
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
                child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD32F2F), size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hapus Dosen?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF337418)),
              ),
              const SizedBox(height: 10),
              Text(
                'Yakin ingin menghapus "$nama" dari daftar dosen pembimbing?',
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
                          gradient: const LinearGradient(colors: [Color(0xFFD32F2F), Color(0xFFE57373)]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            setState(() => _isLoading = true);
                            await _firestore.collection('dosen_pembimbing').doc(docId).delete();
                            setState(() => _isLoading = false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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

  // ================== FIELD DIALOG (Warna hijau tua) ==================
  Widget _buildDialogField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF337418),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          style: const TextStyle(color: Color(0xFF337418), fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF81C784), fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFF4CAF50), size: 20),
            filled: true,
            fillColor: const Color(0xFFF1F8F1),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFA5D6A7), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFA5D6A7), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF337418), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  // ================== BUILD UTAMA (Tema Hijau Tua + Blob) ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1),
      body: Stack(
        children: [
          // Blob Gradient Background
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
                      child: const Icon(Icons.supervisor_account_rounded, size: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Dosen Pembimbing',
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
                            'Dosen',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF337418)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Kelola daftar dosen pembimbing KP',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // List Dosen - Glassmorphism
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF337418)))
                    : StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('dosen_pembimbing')
                            .orderBy('createdAt', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(color: Color(0xFF337418)));
                          }

                          final docs = snapshot.data?.docs ?? [];

                          if (docs.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.people_outline_rounded, size: 64, color: Color(0xFFA5D6A7)),
                                  const SizedBox(height: 16),
                                  const Text('Belum ada dosen pembimbing', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF337418))),
                                  const SizedBox(height: 8),
                                  const Text('Tap tombol + untuk menambahkan', style: TextStyle(fontSize: 13, color: Colors.black45)),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.all(24),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final doc = docs[index];
                              final data = doc.data() as Map<String, dynamic>;
                              final String docId = doc.id;
                              final String nama = data['name'] ?? '-';
                              final String nidn = data['id_user'] ?? '-';
                              final String email = data['email'] ?? '-';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.85), // Glassmorphism
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF337418).withOpacity(0.15), width: 1),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                                      child: const Icon(Icons.person_rounded, color: Color(0xFF4CAF50), size: 26),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(nama, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF337418))),
                                          const SizedBox(height: 2),
                                          Text('NIDN: $nidn', style: const TextStyle(fontSize: 12, color: Colors.black45)),
                                          const SizedBox(height: 2),
                                          Text(email, style: const TextStyle(fontSize: 12, color: Color(0xFF337418))),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => _showTambahDialog(existing: data, docId: docId),
                                          child: Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                                            child: const Icon(Icons.edit_rounded, color: Color(0xFFFFD700), size: 18), // Kuning Gold
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        GestureDetector(
                                          onTap: () => _showHapusDialog(docId, nama),
                                          child: Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(8)),
                                            child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFD32F2F), size: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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

      // Floating Action Button
      floatingActionButton: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _showTambahDialog();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF337418)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: _isPressed
                ? []
                : [BoxShadow(color: const Color(0xFF337418).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          transform: _isPressed ? Matrix4.translationValues(0, 3, 0) : Matrix4.identity(),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}