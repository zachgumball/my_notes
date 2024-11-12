import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/views/materi/materi_pelajaran.dart';

class SubMateri extends StatelessWidget {
  final String subjectName;

  const SubMateri({super.key, required this.subjectName});

  Future<Map<String, dynamic>> _fetchDataFromFirestore() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Map<String, dynamic> result = {
      'title': subjectName,
      'imageUrl': '',
      'items': <Map<String, String>>[]
    };

    try {
      // Ambil sub-materi sesuai dengan subject name
      QuerySnapshot subMateriSnapshot = await _firestore
          .collection('mata_pelajaran')
          .doc(subjectName)
          .collection('sub_materi')
          .get();

      if (subMateriSnapshot.docs.isNotEmpty) {
        var document = subMateriSnapshot.docs.first;

        result['imageUrl'] = document['gambar'] ?? '';

        // Ambil data teks_kolom dan gambar_kolom secara berurutan
        int index = 1;
        while (true) {
          String teksKolom = 'teks_kolom$index';
          String gambarKolom = 'gambar_kolom$index';

          String? teks_kolom = document[teksKolom];
          String? gambar_kolom = document[gambarKolom];

          if (teks_kolom == null || gambar_kolom == null) {
            break;
          }

          result['items']
              .add({'teks_kolom': teks_kolom, 'gambar_kolom': gambar_kolom});

          index++;
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
        backgroundColor: const Color.fromARGB(0, 5, 233, 237),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchDataFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data;

          return Stack(
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
                          child: data!['imageUrl'].isNotEmpty
                              ? Image.network(
                                  data['imageUrl'],
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
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: data['items'].length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    String isiMateriId = data['items'][index]
                                            ['teks_kolom'] ??
                                        '';

                                    return MateriPelajaran(
                                      teksKolom: data['items'][index]
                                              ['teks_kolom'] ??
                                          '',
                                      gambarKolom: data['items'][index]
                                              ['gambar_kolom'] ??
                                          '',
                                      materiDocumentId: subjectName,
                                      subMateriDocumentId: subjectName,
                                      isiMateriId: isiMateriId,
                                    );
                                  },
                                ),
                              );
                            },
                            child: _buildItem(
                              image: data['items'][index]['gambar_kolom'] ?? '',
                              title: data['items'][index]['teks_kolom'] ?? '',
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
          );
        },
      ),
    );
  }

  Widget _buildItem({required String image, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  opacity: 0.8,
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
