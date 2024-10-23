import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class SubMateri extends StatefulWidget {
  final String subjectName; // Add this line

  const SubMateri({super.key, required this.subjectName}); // Modify constructor

  @override
  State<SubMateri> createState() => _SubMateriState();
}

class _SubMateriState extends State<SubMateri> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _title = '';
  String _imageUrl = '';
  List<Map<String, String>> _items = []; // Menyimpan data gambar dan teks_kolom

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchDataFromFirestore(); // Move fetch data call here
  }

  Future<void> _fetchDataFromFirestore() async {
    try {
      // Use the subject name to get the corresponding document
      QuerySnapshot subMateriSnapshot = await _firestore
          .collection('mata_pelajaran')
          .doc(widget.subjectName) // Use subjectName from constructor
          .collection('sub_materi')
          .get();

      if (subMateriSnapshot.docs.isNotEmpty) {
        var document = subMateriSnapshot.docs.first;

        setState(() {
          _title = widget.subjectName; // Set the title to the subject name
          _imageUrl = document['gambar'] ?? ''; // Get the image from Firestore
        });

        // Continue fetching teks_kolom and gambar_kolom
        int index = 1;
        while (true) {
          String teksKolom = 'teks_kolom$index';
          String gambarKolom = 'gambar_kolom$index';

          String? teks_kolom = document[teksKolom];
          String? gambar_kolom = document[gambarKolom];

          if (teks_kolom == null || gambar_kolom == null) {
            break;
          }

          _items.add({
            'teks_kolom': teks_kolom,
            'gambar_kolom': gambar_kolom,
          });

          index++;
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title), // Title dinamis dari Firestore
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
                      width: 380,
                      height: 200,
                      child: _imageUrl.isNotEmpty
                          ? Image.network(
                              _imageUrl, // Gambar dinamis dari Firestore
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 100,
                                );
                              },
                            )
                          : const Center(
                              child:
                                  CircularProgressIndicator()), // Menampilkan loading jika gambar belum diambil
                    ),
                  ),
                ),
                // Menampilkan item dari _items
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: _buildItem(
                          image: _items[index]['gambar_kolom'] ?? '',
                          title: _items[index]['teks_kolom'] ??
                              '', // Perbaikan di sini
                        ),
                      );
                    },
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
    return Padding(
      // Menambahkan Padding di sini
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Sesuaikan nilai padding sesuai kebutuhan
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Container(
          width: 250,
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
                  opacity: 0.7,
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 100,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
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
