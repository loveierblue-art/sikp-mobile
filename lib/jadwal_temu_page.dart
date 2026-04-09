import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class JadwalTemuPage extends StatefulWidget {
  const JadwalTemuPage({super.key});

  @override
  State<JadwalTemuPage> createState() => _JadwalTemuPageState();
}

class _JadwalTemuPageState extends State<JadwalTemuPage> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; //koneksi ke database Firestore
  final _formKey =
      GlobalKey<FormState>(); //kunci buat validasi input (biar gak kosong)

  //controller buat ambil teks yang diketik user
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _perihalController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _jamController = TextEditingController();

  //munculin kalender bawaan HP
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1B5E20),
              onPrimary: Colors.white,
              onSurface: Color(0xFF337418),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text = DateFormat('dd MMMM yyyy').format(picked);
      });
    }
  }

  //fungsi pilih jam
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _jamController.text = picked.format(context);
      });
    }
  }

  //fungsi kirim data ke Firestore
  Future<void> _simpanJadwal() async {
    if (_formKey.currentState!.validate()) {
      //cek dulu, ada yang kosong gak?
      await _firestore.collection('jadwal_temu').add({
        //nama tabel/koleksi di Firebase
        'nama': _namaController.text,
        'npm': _npmController.text,
        'perihal': _perihalController.text,
        'tanggal': _tanggalController.text,
        'jam': _jamController.text,
        'status': 'Disetujui',
        'dibaca': false,
        'created_at': FieldValue.serverTimestamp(), //catat waktu input otomatis
      });

      //kosongkan form setelah berhasil simpan
      _namaController.clear();
      _npmController.clear();
      _perihalController.clear();
      _tanggalController.clear();
      _jamController.clear();

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jadwal bimbingan berhasil dibuat!'),
        ), //notif sukses
      );
    }
  }

  //fungsi tampilkan form input yang slide up
  void _showTambahJadwalForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, //biar form-nya gak kepotong keyboard
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            //biar inputan di dalam BottomSheet bisa lsg berubah (setState khusus)
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ), //biar form naik pas keyboard muncul
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Tentukan Jadwal Baru',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            _namaController,
                            'Nama Mahasiswa/Kelompok',
                            Icons.person_outline,
                          ),
                          _buildTextField(
                            _npmController,
                            'NPM Mahasiswa',
                            Icons.badge_outlined,
                          ),
                          _buildTextField(
                            _perihalController,
                            'Perihal Bimbingan',
                            Icons.business_rounded,
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //textfield tanggal
                              Expanded(
                                flex: 3,
                                child: _buildTextField(
                                  _tanggalController,
                                  'Tanggal',
                                  Icons.calendar_today,
                                  readOnly: true,
                                  onTap: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2027),
                                        );
                                    if (picked != null) {
                                      setModalState(() {
                                        _tanggalController.text = DateFormat(
                                          'dd MMMM yyyy',
                                        ).format(picked);
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              //textfield jam
                              Expanded(
                                flex: 2,
                                child: _buildTextField(
                                  _jamController,
                                  'Jam',
                                  Icons.access_time,
                                  readOnly: true,
                                  onTap: () async {
                                    final TimeOfDay? picked =
                                        await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                    if (picked != null) {
                                      setModalState(() {
                                        _jamController.text = picked.format(
                                          context,
                                        );
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _simpanJadwal,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B5E20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Simpan Jadwal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

  //widget build textfield
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF337418), size: 20),
              filled: true,
              fillColor: const Color(0xFFF1F8F1),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF337418).withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF337418)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTambahJadwalForm,
        backgroundColor: const Color(0xFF1B5E20),
        child: const Icon(Icons.add_task_rounded, color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Decor
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
                    Colors.transparent,
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
                    Colors.transparent,
                  ],
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
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.edit_calendar_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Kelola Jadwal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Atur agenda bimbingan dengan mahasiswa',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              //bagian nampilin data dari database secara Realtime
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      _firestore
                          .collection('jadwal_temu')
                          .orderBy('created_at', descending: true)
                          .snapshots(), //pantau data terbaru
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF337418),
                        ),
                      );
                    final docs = snapshot.data?.docs ?? [];

                    return ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF337418).withOpacity(0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0xFFE8F5E9),
                                child: Icon(
                                  Icons.groups_rounded,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['nama'] ?? '-',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF337418),
                                      ),
                                    ),
                                    Text(
                                      'NPM: ${data['npm'] ?? '-'}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.business_rounded,
                                          size: 14,
                                          color: Color(0xFFFFD700),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          data['perihal'] ?? '-',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time_filled,
                                          size: 14,
                                          color: Color(0xFF4CAF50),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "${data['tanggal']} • ${data['jam']}",
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => doc.reference.delete(),
                              ), //fungsi hapus data lsg ke Firebase
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
    );
  }
}
