import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _checkEmailVerification(); // Memeriksa status verifikasi email saat inisialisasi
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    // Jika pengguna sudah login tetapi belum memverifikasi email
    if (user != null && !(user.emailVerified)) {
      // Tampilkan pesan atau dialog kepada pengguna
      await showErrorDialog(
        context,
        'Anda harus memverifikasi email Anda sebelum melanjutkan.',
      );

      Navigator.of(context).pushNamedAndRemoveUntil(
        verifyEmailRoute,
        (route) => false,
      );
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
                const Text(
                  'Selamat Datang Kembali!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
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
                ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        if (user.emailVerified) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            notesRoute,
                            (route) => false,
                          );
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute,
                            (route) => false,
                          );
                        }
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        await showErrorDialog(
                          context,
                          'Pengguna tidak ditemukan',
                        );
                      } else if (e.code == 'wrong-password') {
                        await showErrorDialog(
                          context,
                          'Password salah',
                        );
                      } else {
                        await showErrorDialog(
                          context,
                          'Kesalahan: ${e.code}',
                        );
                      }
                    } catch (e) {
                      await showErrorDialog(
                        context,
                        e.toString(),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, (route) => false);
                  },
                  child: const Text(
                    'Belum terdaftar? Daftar di sini!',
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
