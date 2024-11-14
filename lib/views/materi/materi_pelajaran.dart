import 'package:flutter/material.dart';
import 'package:mynotes/views/materi/quiz.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'; // Updated import

class MateriPelajaran extends StatefulWidget {
  final String teksKolom;
  final String gambarKolom;
  final String materiDocumentId;
  final String subMateriDocumentId;
  final String isiMateriId;

  const MateriPelajaran({
    super.key,
    required this.teksKolom,
    required this.gambarKolom,
    required this.materiDocumentId,
    required this.subMateriDocumentId,
    required this.isiMateriId,
  });

  @override
  _MateriPelajaranState createState() => _MateriPelajaranState();
}

class _MateriPelajaranState extends State<MateriPelajaran> {
  Future<String?>? isiMateriFuture;
  Future<String?>? teksHintFuture;
  String? url3DObject;

  @override
  void initState() {
    super.initState();
    // Mengambil isi materi dan teks hint dari Firestore
    isiMateriFuture = fetchIsiMateri(widget.materiDocumentId,
        widget.subMateriDocumentId, widget.isiMateriId);
    teksHintFuture = fetchTeksHint(widget.materiDocumentId,
        widget.subMateriDocumentId, widget.isiMateriId);
    fetchUrl3DObject(widget.materiDocumentId, widget.subMateriDocumentId,
        widget.isiMateriId);
  }

  // Mengambil isi materi dari Firestore
  Future<String?> fetchIsiMateri(
      String materiDocId, String subMateriDocId, String isiMateriId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('mata_pelajaran')
          .doc(materiDocId)
          .collection('sub_materi')
          .doc(subMateriDocId)
          .collection('isi_materi')
          .doc(isiMateriId)
          .get();

      if (snapshot.exists) {
        return snapshot['isiMateri']; // Mengembalikan isi materi
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching isiMateri: $e');
      return null;
    }
  }

  // Mengambil teks hint dari Firestore
  Future<String?> fetchTeksHint(
      String materiDocId, String subMateriDocId, String isiMateriId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('mata_pelajaran')
          .doc(materiDocId)
          .collection('sub_materi')
          .doc(subMateriDocId)
          .collection('isi_materi')
          .doc(isiMateriId)
          .get();

      if (snapshot.exists) {
        return snapshot['teksHint']; // Mengembalikan teks hint
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching teksHint: $e');
      return null;
    }
  }

  // Mengambil URL objek 3D dari Firestore
  Future<void> fetchUrl3DObject(
      String materiDocId, String subMateriDocId, String isiMateriId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('mata_pelajaran')
          .doc(materiDocId)
          .collection('sub_materi')
          .doc(subMateriDocId)
          .collection('isi_materi')
          .doc(isiMateriId)
          .get();

      if (snapshot.exists) {
        setState(() {
          url3DObject = snapshot['url3DObject'];
          print("Fetched 3D Model URL: $url3DObject"); // Debugging line
        });
      }
    } catch (e) {
      print('Error fetching url3DObject: $e');
    }
  }

  // Menampilkan model 3D di halaman baru
  void _show3DModelViewer(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModelViewerPage(modelUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teksKolom),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/background2.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.7),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.gambarKolom,
                      width: 370,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 100,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.teksKolom,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 2, color: Colors.grey),
                  const SizedBox(height: 16),
                  // Menampilkan isi materi dengan HTML menggunakan flutter_widget_from_html
                  FutureBuilder<String?>(
                    future: isiMateriFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('No data found');
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: HtmlWidget(
                            snapshot.data!, // Data HTML dari Firestore
                            textStyle: const TextStyle(fontSize: 16),
                            customWidgetBuilder: (element) {
                              // Handle img elements
                              if (element.localName == 'img') {
                                final src = element.attributes['src'] ?? '';
                                return Image.network(src);
                              }
                              return null;
                            },
                            customStylesBuilder: (element) {
                              if (element.localName == 'p') {
                                if (element.classes
                                    .contains('ql-align-center')) {
                                  return {'text-align': 'center'};
                                } else if (element.classes
                                    .contains('ql-align-right')) {
                                  return {'text-align': 'right'};
                                } else if (element.classes
                                    .contains('ql-align-justify')) {
                                  return {'text-align': 'justify'};
                                }
                                return {'text-align': 'left'};
                              }
                              return null;
                            },
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 16),
                  // Menampilkan teks hint
                  FutureBuilder<String?>(
                    future: teksHintFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('No teksHint found');
                      } else {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Text(
                                snapshot.data!,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: url3DObject != null
                                  ? () => _show3DModelViewer(url3DObject!)
                                  : null,
                              child: const Text("Lihat 3D Model"),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text('Apakah kamu ingin melakukan quiz?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Tidak'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPage(
                            materiDocumentId: widget.materiDocumentId,
                            subMateriDocumentId: widget.subMateriDocumentId,
                            isiMateriId: widget.isiMateriId,
                          ),
                        ),
                      );
                    },
                    child: const Text('Ya'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blue[400],
        tooltip: 'Mulai Quiz',
        child: Image.asset(
          'assets/quiz.png', // Ganti dengan path gambar kamu
          width: 50, // Sesuaikan ukuran gambar jika diperlukan
          height: 50,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class ModelViewerPage extends StatelessWidget {
  final String modelUrl;

  const ModelViewerPage({super.key, required this.modelUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("3D Model Viewer"),
      ),
      body: Center(
        child: ModelViewer(
          src: modelUrl,
          autoRotate: true,
          autoPlay: true,
          ar: true,
          cameraControls: true,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
