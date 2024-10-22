import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubMateriView extends StatefulWidget {
  const SubMateriView({super.key});

  @override
  State<SubMateriView> createState() => _SubMateriState();
}

class _SubMateriState extends State<SubMateriView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method untuk mengambil data judul dari koleksi sub_materi di dalam IPA
  Future<String> getJudulSubMateri() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('IPA')
          .doc(
              'yourDocumentId') // ganti dengan ID dokumen yang benar di koleksi IPA
          .collection('sub_materi')
          .limit(1) // mengambil dokumen pertama
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data();
        return data['judul'] ??
            'IPA Sub Materi'; // Mengembalikan judul atau default value
      } else {
        return 'IPA Sub Materi'; // Jika tidak ada data
      }
    } catch (e) {
      print('Error: $e');
      return 'IPA Sub Materi'; // Jika terjadi error
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
      const AssetImage('assets/background/background1.jpg'),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan FutureBuilder untuk mengambil data judul dari Firestore
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: getJudulSubMateri(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return Text(snapshot.data!); // Tampilkan judul dari Firestore
            }
            return const Text('IPA Sub Materi');
          },
        ),
        backgroundColor: const Color.fromARGB(0, 5, 233, 237),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/background1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 30.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 370,
                      height: 200,
                      child: Image.asset(
                        'assets/ipa.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Item pertama
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const Materi1(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: _buildItem(
                    image: 'assets/matahari.jpg',
                    title: 'Mengenal Cahaya dan Bunyi',
                  ),
                ),
                const SizedBox(height: 16),
                // Item kedua
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const MateriEkosistem(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: _buildItem(
                    image: 'assets/ekosistem.jpg',
                    title: 'Harmoni dalam Ekosistem',
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({required String image, required String title}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Container(
        width: 350,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
