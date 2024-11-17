import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/sub_materi.dart';
import 'package:mynotes/views/leaderboard/ranking_views.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mynotes/splash_screen_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mari Belajar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: splashScreenRoute, // Rute awal aplikasi
      routes: {
        splashScreenRoute: (context) => const SplashScreen(),
        homeRoute: (context) => const HomePage(),
        loginRoute: (context) => const LoginView(),
        notesRoute: (context) => const NotesView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        subMateriRoute: (context) {
          // Ambil argument yang diteruskan untuk halaman SubMateri
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return SubMateri(subjectName: args['subjectName']);
        },
        leaderboardRoute: (context) => const LeaderboardViews(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Inisialisasi Firebase
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              return user.emailVerified
                  ? const NotesView() // Navigasi ke NotesView jika email terverifikasi
                  : const VerifyEmailView(); // Navigasi ke halaman verifikasi jika belum
            } else {
              return const LoginView(); // Tampilkan halaman login jika belum ada user
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String _name = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Ambil data pengguna saat inisialisasi
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Ambil data pengguna dari Firestore berdasarkan UID
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          _name = snapshot['name'] ?? 'Tidak Diketahui';
        });
      }
    }
  }

  String _getGreeting() {
    // Berikan ucapan berdasarkan waktu saat ini
    final hour = DateTime.now().hour;
    if (hour < 10) {
      return 'Selamat Pagi, selamat beraktifitas!';
    } else if (hour < 15) {
      return 'Selamat Siang, selamat beraktifitas!';
    } else if (hour < 19) {
      return 'Selamat Sore, selamat beristirahat!';
    } else {
      return 'Selamat Malam, selamat beristirahat!';
    }
  }

  Future<void> addMataPelajaran(String nama, String ikon, String warna) async {
    // Tambah data mata pelajaran ke Firestore
    CollectionReference pelajaran =
        FirebaseFirestore.instance.collection('mata_pelajaran');

    try {
      await pelajaran.add({
        'nama': nama,
        'ikon': ikon, // URL ikon
        'warna': warna, // Kode warna
      });
      print('Mata Pelajaran berhasil ditambahkan!');
    } catch (e) {
      print('Gagal menambahkan mata pelajaran: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // Tampilkan modal saat tombol menu ditekan
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.help),
                                title: const Text('Tentang'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text('Keluar'),
                                onTap: () async {
                                  final shouldLogout =
                                      await showLogOutDialog(context);
                                  if (shouldLogout) {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      loginRoute,
                                      (_) => false,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hallo, $_name! 😊',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _getGreeting(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('mata_pelajaran')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final pelajaranDocs = snapshot.data!.docs;

                        if (pelajaranDocs.isEmpty) {
                          return Center(
                            child: Text(
                              'Belum ada item yang ditambahkan',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        }

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: pelajaranDocs.length,
                          itemBuilder: (context, index) {
                            final pelajaran = pelajaranDocs[index];
                            final nama = pelajaran['nama'];
                            final ikonUrl = pelajaran['ikon'];
                            final warna = pelajaran['warna'];

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  subMateriRoute,
                                  arguments: {
                                    'nama': nama,
                                    'ikon': ikonUrl,
                                    'warna': warna,
                                    'subjectName': nama
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(
                                      int.parse('0xFF${warna.substring(1)}')),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: ikonUrl,
                                        width: 100,
                                        height: 100,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.broken_image),
                                      ),
                                      const SizedBox(height: 10),
                                      AutoSizeText(
                                        nama,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Keluar'),
            content: const Text('Apakah Anda yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Keluar'),
              ),
            ],
          );
        },
      ) ??
      false;
}
