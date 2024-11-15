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
      initialRoute: splashScreenRoute,
      routes: {
        splashScreenRoute: (context) => const SplashScreen(),
        homeRoute: (context) => const HomePage(),
        loginRoute: (context) => const LoginView(),
        notesRoute: (context) => const NotesView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        subMateriRoute: (context) {
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
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              return user.emailVerified
                  ? const NotesView()
                  : const VerifyEmailView();
            } else {
              return const LoginView();
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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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
    CollectionReference pelajaran =
        FirebaseFirestore.instance.collection('mata_pelajaran');

    try {
      await pelajaran.add({
        'nama': nama,
        'ikon': ikon, // This should be the image URL
        'warna': warna,
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
                            final ikonUrl =
                                pelajaran['ikon']; // URL of the icon
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
                                      Image.network(
                                        ikonUrl,
                                        width: 50,
                                        height: 50,
                                      ),
                                      const SizedBox(height: 10),
                                      AutoSizeText(
                                        nama,
                                        style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 253, 252, 252),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        minFontSize: 14,
                                        maxFontSize: 18,
                                        overflow: TextOverflow.ellipsis,
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Ranking',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) async {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 1) {
            // Navigasi ke halaman leaderboard dan kembali ke ikon Home setelahnya
            await Navigator.of(context).pushNamed(leaderboardRoute);
            setState(() {
              _selectedIndex = 0;
            });
          }
        },
      ),
    );
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
