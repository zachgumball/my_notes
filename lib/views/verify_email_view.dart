import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart'; // Pastikan ini ada

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  Timer? _timer; // Timer untuk mengecek verifikasi email

  @override
  void initState() {
    super.initState();
    _startEmailVerificationCheck(); // Mulai cek status verifikasi saat view dimulai
  }

  void _startEmailVerificationCheck() {
    // Timer untuk mengecek status verifikasi setiap 5 detik
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload(); // Reload user info
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        timer.cancel(); // Hentikan timer jika email terverifikasi
        Navigator.of(context).pushNamedAndRemoveUntil(
          notesRoute, // Arahkan ke NotesView
          (route) => false, // Hapus semua rute sebelumnya
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Pastikan timer dihentikan ketika widget dihapus
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Ganti warna background
      appBar: AppBar(
        title: const Text('Verifikasi Email Anda'),
        backgroundColor: Colors.blue, // Warna AppBar
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(24.0), // Memberikan padding yang lebih luas
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Pusatkan isi secara horizontal
            children: [
              const Icon(
                Icons.email_outlined, // Ikon email
                size: 100,
                color: Colors.blue, // Warna ikon
              ),
              const SizedBox(height: 20),
              const Text(
                'Verifikasi Alamat Email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Warna teks judul
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Kami telah mengirim email verifikasi ke alamat email Anda. Silakan cek kotak masuk dan tekan tombol verifikasi di email.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center, // Teks center
              ),
              const SizedBox(height: 24),
              // Tombol untuk mengirim ulang email verifikasi
              ElevatedButton.icon(
                onPressed: () {
                  final user = FirebaseAuth.instance.currentUser;
                  user?.sendEmailVerification().then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Email verifikasi dikirim ulang!')),
                    );
                  });
                },
                icon: const Icon(Icons.send), // Ikon pada tombol
                label: const Text('Kirim ulang email verifikasi'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: Colors.blue, // Warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Teks dengan link kembali ke login
              TextButton(
                onPressed: () {
                  // Hentikan timer untuk mencegah navigasi otomatis
                  _timer?.cancel();

                  // Menambahkan delay singkat sebelum navigasi
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    }
                  });
                },
                child: const Text(
                  'Sudah verifikasi email? Yuk kembali ke halaman Login!',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
