import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Map<String, dynamic>? currentUser;

  // ==================================================
  // LOGIN
  // ==================================================
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final query =
          await _firestore
              .collection('users')
              .where('id_user', isEqualTo: identifier)
              .get();

      if (query.docs.isEmpty) {
        return {
          'success': false,
          'message': 'NPM/NIDN tidak terdaftar di sistem.',
        };
      }

      final userData = query.docs.first.data();
      final String email = userData['email'];

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      currentUser = userData;
      return {
        'success': true,
        'role': userData['role'].toString().toLowerCase(),
        'user': userData,
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return {
          'success': false,
          'message': 'Password yang Anda masukkan salah.',
        };
      } else if (e.code == 'user-not-found') {
        return {
          'success': false,
          'message': 'NPM/NIDN tidak terdaftar di sistem.',
        };
      } else {
        return {'success': false, 'message': 'Terjadi kesalahan: ${e.message}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi.'};
    }
  }

  // ==================================================
  // REGISTER
  // ==================================================
  Future<Map<String, dynamic>> register(
    String id,
    String name,
    String email,
    String password,
  ) async {
    try {
      final query =
          await _firestore
              .collection('users')
              .where('id_user', isEqualTo: id)
              .get();

      if (query.docs.isNotEmpty) {
        return {'success': false, 'message': 'NPM sudah terdaftar.'};
      }

      final emailQuery =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .get();

      if (emailQuery.docs.isNotEmpty) {
        return {'success': false, 'message': 'Email sudah digunakan.'};
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      const String role = 'mahasiswa';

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'id_user': id,
        'name': name,
        'email': email,
        'role': role,
        'uid': credential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {'success': true, 'message': 'Akun berhasil didaftarkan.'};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return {'success': false, 'message': 'Email sudah digunakan.'};
      } else if (e.code == 'weak-password') {
        return {
          'success': false,
          'message': 'Password terlalu lemah, minimal 6 karakter.',
        };
      } else {
        return {'success': false, 'message': 'Terjadi kesalahan: ${e.message}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi.'};
    }
  }

  // ==================================================
  // FORGOT PASSWORD (by NPM/NIDN)
  // ==================================================
  Future<Map<String, dynamic>> forgotPassword(
    String id,
    String newPassword,
  ) async {
    try {
      final query =
          await _firestore
              .collection('users')
              .where('id_user', isEqualTo: id)
              .get();

      if (query.docs.isEmpty) {
        return {
          'success': false,
          'message': 'NPM/NIDN tidak ditemukan di sistem.',
        };
      }

      final userData = query.docs.first.data();
      final String email = userData['email'];

      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message':
            'Link reset password telah dikirim ke email $email. Silakan cek inbox Anda.',
      };
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: ${e.message}'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi.'};
    }
  }

  // ==================================================
  // SEND RESET PASSWORD EMAIL (by email langsung)
  // ==================================================
  Future<Map<String, dynamic>> sendResetPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Link reset password telah dikirim ke email $email.',
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return {
          'success': false,
          'message': 'Email tidak terdaftar di sistem.',
        };
      } else {
        return {'success': false, 'message': 'Terjadi kesalahan: ${e.message}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi.'};
    }
  }

  // ==================================================
  // LOGOUT
  // ==================================================
  Future<void> logout() async {
    await _auth.signOut();
    currentUser = null;
  }

  // ==================================================
  // AJUKAN KP
  // ==================================================
  Future<Map<String, dynamic>> ajukanKP({
    required String nama,
    required String npm,
    required String noTelp,
    required String namaPartner,
    required String npmPartner,
    required String noTelpPartner,
    required String instansi,
    required String alamatInstansi,
    required String tanggalMulai,
    required String tanggalSelesai,
  }) async {
    try {
      // Cek apakah ada pengajuan yang masih menunggu
      final menunggu =
          await _firestore
              .collection('pengajuan_kp')
              .where('uid', isEqualTo: _auth.currentUser?.uid ?? '')
              .where('status', isEqualTo: 'Menunggu')
              .get();

      if (menunggu.docs.isNotEmpty) {
        return {
          'success': false,
          'message':
              'Anda masih memiliki pengajuan yang sedang menunggu verifikasi.',
        };
      }

      // Cek apakah sudah pernah disetujui
      final disetujui =
          await _firestore
              .collection('pengajuan_kp')
              .where('uid', isEqualTo: _auth.currentUser?.uid ?? '')
              .where('status', isEqualTo: 'Disetujui')
              .get();

      if (disetujui.docs.isNotEmpty) {
        return {
          'success': false,
          'message':
              'Pengajuan KP Anda sudah disetujui. Tidak bisa mengajukan lagi.',
        };
      }

      await _firestore.collection('pengajuan_kp').add({
        'nama': nama,
        'npm': npm,
        'noTelp': noTelp,
        'namaPartner': namaPartner,
        'npmPartner': npmPartner,
        'noTelpPartner': noTelpPartner,
        'instansi': instansi,
        'alamatInstansi': alamatInstansi,
        'tanggalMulai': tanggalMulai,
        'tanggalSelesai': tanggalSelesai,
        'status': 'Menunggu',
        'dosenPembimbing': '',
        'uid': _auth.currentUser?.uid ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {'success': true, 'message': 'Pengajuan KP berhasil dikirim.'};
    } catch (e) {
      return {'success': false, 'message': 'Gagal mengirim pengajuan: $e'};
    }
  }

  // ==================================================
  // GET PENGAJUAN KP MAHASISWA (terbaru)
  // ==================================================
  Future<Map<String, dynamic>> getPengajuanKP() async {
    try {
      final uid = _auth.currentUser?.uid ?? '';
      final query =
          await _firestore
              .collection('pengajuan_kp')
              .where('uid', isEqualTo: uid)
              .orderBy('createdAt', descending: true)
              .limit(1)
              .get();

      if (query.docs.isEmpty) {
        return {'success': true, 'data': null};
      }

      return {'success': true, 'data': query.docs.first.data()};
    } catch (e) {
      return {'success': false, 'message': 'Gagal mengambil data: $e'};
    }
  }

  // ==================================================
  // GET SEMUA PENGAJUAN KP (DOSEN)
  // ==================================================
  Future<Map<String, dynamic>> getAllPengajuanKP() async {
    try {
      final query =
          await _firestore
              .collection('pengajuan_kp')
              .orderBy('createdAt', descending: true)
              .get();

      final List<Map<String, dynamic>> data =
          query.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();

      return {'success': true, 'data': data};
    } catch (e) {
      return {'success': false, 'message': 'Gagal mengambil data: $e'};
    }
  }

  // ==================================================
  // SETUJUI PENGAJUAN KP (DOSEN)
  // ==================================================
  Future<Map<String, dynamic>> setujuiPengajuan(
    String docId,
    String dosenPembimbing,
  ) async {
    try {
      await _firestore.collection('pengajuan_kp').doc(docId).update({
        'status': 'Disetujui',
        'dosenPembimbing': dosenPembimbing,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {'success': true, 'message': 'Pengajuan berhasil disetujui.'};
    } catch (e) {
      return {'success': false, 'message': 'Gagal menyetujui pengajuan: $e'};
    }
  }

  // ==================================================
  // TOLAK PENGAJUAN KP (DOSEN)
  // ==================================================
  Future<Map<String, dynamic>> tolakPengajuan(String docId) async {
    try {
      await _firestore.collection('pengajuan_kp').doc(docId).update({
        'status': 'Ditolak',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {'success': true, 'message': 'Pengajuan berhasil ditolak.'};
    } catch (e) {
      return {'success': false, 'message': 'Gagal menolak pengajuan: $e'};
    }
  }

  // ==================================================
  // GET DAFTAR DOSEN
  // ==================================================
  Future<Map<String, dynamic>> getDaftarDosen() async {
    try {
      final query =
          await _firestore
              .collection('dosen_pembimbing')
              .orderBy('createdAt', descending: false)
              .get();

      final List<Map<String, dynamic>> data =
          query.docs.map((doc) => doc.data()).toList();

      return {'success': true, 'data': data};
    } catch (e) {
      return {'success': false, 'message': 'Gagal mengambil data dosen: $e'};
    }
  }

  // ==================================================
  // KIRIM BERKAS KE MAHASISWA
  // ==================================================
  Future<Map<String, dynamic>> kirimBerkas(String docId) async {
    try {
      await _firestore.collection('pengajuan_kp').doc(docId).update({
        'statusBerkas': 'Terkirim',
        'berkasKirimAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Berkas berhasil dikirim ke mahasiswa.',
      };
    } catch (e) {
      return {'success': false, 'message': 'Gagal mengirim berkas: $e'};
    }
  }

  // ==================================================
  // TAMBAH PENGUMUMAN (DOSEN)
  // ==================================================
  Future<Map<String, dynamic>> tambahPengumuman({
    required String judul,
    required String isi,
    required String namaDosen,
  }) async {
    try {
      await _firestore.collection('pengumuman').add({
        'judul': judul,
        'isi': isi,
        'namaDosen': namaDosen,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return {'success': true, 'message': 'Pengumuman berhasil dibuat.'};
    } catch (e) {
      return {'success': false, 'message': 'Gagal membuat pengumuman: $e'};
    }
  }

  // ==================================================
  // HAPUS PENGUMUMAN (DOSEN)
  // ==================================================
  Future<Map<String, dynamic>> hapusPengumuman(String docId) async {
    try {
      await _firestore.collection('pengumuman').doc(docId).delete();
      return {'success': true, 'message': 'Pengumuman berhasil dihapus.'};
    } catch (e) {
      return {'success': false, 'message': 'Gagal menghapus pengumuman: $e'};
    }
  }
}
