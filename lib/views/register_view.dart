import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan import ini
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name; // Tambahkan controller untuk nama
  late final TextEditingController _class; // Tambahkan controller untuk kelas

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController(); // Inisialisasi controller nama
    _class = TextEditingController(); // Inisialisasi controller kelas
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose(); // Dispose controller nama
    _class.dispose(); // Dispose controller kelas
    super.dispose();
  }

  Future<void> _register() async {
    final email = _email.text;
    final password = _password.text;
    final name = _name.text; // Ambil nama

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      await showErrorDialog(
        context,
        'Nama, kelas, email, dan password tidak boleh kosong',
      );
      return;
    }

    try {
      // Menampilkan dialog loading
      showDialog(
        context: context,
        barrierDismissible: false, // Tidak bisa ditutup dengan klik di luar
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(), // Animasi loading
          );
        },
      );

      // Mendaftar pengguna baru
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      // Menyimpan informasi tambahan ke Firestore
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
        });
      }

      // Mengirim email verifikasi
      await user?.sendEmailVerification();

      // Menutup pop-up loading
      if (mounted) {
        Navigator.of(context).pop(); // Ini untuk menutup dialog loading
      }

      // Menampilkan pop-up untuk verifikasi email
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Verifikasi Email'),
          content: const Text(
            'Email verifikasi telah dikirim ke alamat email Anda. Silakan cek kotak masuk Anda.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Menutup pop-up loading jika ada kesalahan
      Navigator.of(context).pop();
      if (e.code == 'weak-password') {
        await showErrorDialog(context, 'Password terlalu lemah');
      } else if (e.code == 'email-already-in-use') {
        await showErrorDialog(context, 'Email sudah digunakan');
      } else if (e.code == 'invalid-email') {
        await showErrorDialog(context, 'Alamat email tidak valid');
      } else {
        await showErrorDialog(context, 'Kesalahan: ${e.code}');
      }
    } catch (e) {
      // Menangani error tak terduga
      Navigator.of(context).pop();
      await showErrorDialog(context, 'Kesalahan tak terduga: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Menambahkan gambar dan memastikan gambar berada di tengah
                Center(
                  child: Image.asset(
                    'assets/register.png',
                    width: 300,
                    height: 300,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Buat Akun',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                // Kolom untuk nama
                TextField(
                  controller: _name,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama kamu',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),
                // Kolom untuk email
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Masukkan email di sini',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),
                // Kolom untuk password
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Masukkan password di sini',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol Register
                ElevatedButton(
                  onPressed: _register, // Panggil fungsi _register saat ditekan
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 5,
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Sudah terdaftar? Masuk di sini!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
