import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class MateriPelajaran extends StatefulWidget {
  final String teksKolom;
  final String gambarKolom;
  final String materiDocumentId; // Document ID for mata_pelajaran
  final String subMateriDocumentId; // Document ID for sub_materi
  final String isiMateriId; // Document ID for isi_materi

  const MateriPelajaran({
    Key? key,
    required this.teksKolom,
    required this.gambarKolom,
    required this.materiDocumentId, // Required parameter for materiDocumentId
    required this.subMateriDocumentId, // Required parameter for subMateriDocumentId
    required this.isiMateriId, // Required parameter for isiMateriId
  }) : super(key: key);

  @override
  _MateriPelajaranState createState() => _MateriPelajaranState();
}

class _MateriPelajaranState extends State<MateriPelajaran> {
  late Future<String?> isiMateriFuture;

  @override
  void initState() {
    super.initState();
    // Fetch isiMateri from Firestore
    isiMateriFuture = fetchIsiMateri(widget.materiDocumentId,
        widget.subMateriDocumentId, widget.isiMateriId);
  }

  Future<String?> fetchIsiMateri(
      String materiDocId, String subMateriDocId, String isiMateriId) async {
    try {
      // Use the parameters for Firestore query
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('mata_pelajaran')
          .doc(materiDocId)
          .collection('sub_materi')
          .doc(subMateriDocId)
          .collection('isi_materi')
          .doc(isiMateriId)
          .get();

      if (snapshot.exists) {
        return snapshot[
            'isiMateri']; // Ensure 'isiMateri' matches your Firestore field name
      } else {
        return null; // Document does not exist
      }
    } catch (e) {
      print('Error fetching isiMateri: $e');
      return null; // Handle the error appropriately
    }
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
                          padding: const EdgeInsets.all(16.0),
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
                          child: Text(
                            snapshot.data!,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
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
          // Tampilkan dialog konfirmasi
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text('Apakah kamu ingin melakukan quiz?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Tutup dialog
                      Navigator.of(context).pop();
                    },
                    child: const Text('Tidak'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Arahkan ke halaman QuizPage
                      Navigator.of(context).pop(); // Tutup dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizPage(),
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
        child: const Icon(Icons.question_mark),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<int?> selectedAnswers = List.filled(5, null);
  final int totalQuestions = 5;
  int initialScore = 1000; // Skor awal
  late int score; // Skor akhir
  late bool
      isCounting; // Untuk mengecek apakah proses penghitungan sedang berjalan
  int countdown = 60; // Waktu mundur 60 detik
  late Timer countdownTimer; // Timer untuk menghitung mundur
  late List<List<String>> shuffledOptions; // Menyimpan opsi yang sudah diacak

  @override
  void initState() {
    super.initState();
    score = initialScore; // Inisialisasi skor
    isCounting = false; // Tidak sedang menghitung pada awal
    shuffledOptions =
        generateShuffledOptions(); // Mengacak opsi saat inisialisasi
    startCountdownTimer(); // Mulai timer pada inisialisasi
  }

  List<List<String>> generateShuffledOptions() {
    const options = [
      ['Matahari', 'Bulan', 'Bintang', 'Lampu'],
      ['Getaran', 'Cahaya', 'Gerakan', 'Waktu'],
      ['Cermin', 'Kertas', 'Air', 'Batu'],
      ['Udara', 'Ruang hampa', 'Kegelapan', 'Cahaya'],
      ['Fotosintesis', 'Respirasi', 'Transpirasi', 'Evaporasi'],
    ];

    return options.map((optionList) {
      List<int> randomIndices = List.generate(optionList.length, (i) => i);
      randomIndices.shuffle();
      return randomIndices.map((i) => optionList[i]).toList();
    }).toList();
  }

  @override
  void dispose() {
    countdownTimer.cancel(); // Hentikan timer ketika widget dihancurkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiz: Cahaya dan Bunyi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Waktu Tersisa: $countdown detik',
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < totalQuestions; i++)
                    buildQuestion(
                      context,
                      getQuestion(i),
                      shuffledOptions[i], // Gunakan opsi yang sudah diacak
                      getCorrectAnswerIndex(i),
                      i,
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      stopCountdown(); // Hentikan countdown ketika menekan "Selesai"
                      calculateScore(); // Hitung nilai
                    },
                    child: const Text('Selesai'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getQuestion(int index) {
    const questions = [
      '1. Apa sumber cahaya terbesar yang kita kenal?',
      '2. Bunyi adalah hasil dari?',
      '3. Cahaya dapat dipantulkan dari?',
      '4. Bunyi merambat melalui?',
      '5. Proses di mana tumbuhan membuat makanan menggunakan cahaya disebut?',
    ];
    return questions[index];
  }

  String getCorrectAnswerIndex(int index) {
    const correctAnswers = [
      'Matahari', // Jawaban benar untuk pertanyaan 1
      'Getaran', // Jawaban benar untuk pertanyaan 2
      'Cermin', // Jawaban benar untuk pertanyaan 3
      'Udara', // Jawaban benar untuk pertanyaan 4
      'Fotosintesis', // Jawaban benar untuk pertanyaan 5
    ];

    return correctAnswers[
        index]; // Mengembalikan jawaban benar (sekarang String)
  }

  Widget buildQuestion(BuildContext context, String question,
      List<String> options, String correctAnswer, int questionIndex) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAnswers[questionIndex] = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedAnswers[questionIndex] == index
                          ? Colors.blue
                          : (index == 0
                              ? Colors.red[200]
                              : index == 1
                                  ? Colors.orange[200]
                                  : index == 2
                                      ? Colors.green[200]
                                      : Colors.yellow[200]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        options[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedAnswers[questionIndex] == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void stopCountdown() {
    isCounting = false; // Hentikan penghitungan
    countdownTimer.cancel(); // Hentikan timer
  }

  void calculateScore() {
    int correctAnswers = 0;

    // Hitung jawaban yang benar
    for (int i = 0; i < totalQuestions; i++) {
      String correctAnswer = getCorrectAnswerIndex(i);
      if (selectedAnswers[i] != null &&
          shuffledOptions[i][selectedAnswers[i]!].contains(correctAnswer)) {
        correctAnswers++;
      }
    }

    // Hitung skor sesuai jumlah jawaban yang benar
    score = correctAnswers * 200;

    // Hitung pengurangan skor berdasarkan waktu yang tersisa
    int timePenalty =
        (60 - countdown) * 2; // Kurangi 20 poin untuk setiap detik yang berlalu
    score = (score - timePenalty > 0)
        ? score - timePenalty
        : 0; // Pastikan skor tidak negatif

    // Tampilkan dialog loading
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          contentPadding: EdgeInsets.all(20), // Tambahkan padding
          content: SizedBox(
            height: 150, // Tinggi dialog
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Menghitung Nilai',
                    style: TextStyle(
                      fontSize: 24, // Ukuran font yang lebih besar
                      fontWeight: FontWeight.bold, // Gaya font tebal
                      color: Colors.blueAccent, // Warna teks
                    ),
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Sedang menghitung...',
                    style: TextStyle(
                      fontSize: 18, // Ukuran font
                      color: Colors.grey, // Warna teks
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Tunda untuk menampilkan skor akhir
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Tutup dialog loading
      showFinalScore(score, timePenalty); // Tampilkan skor akhir
    });
  }

  void showFinalScore(int score, int timePenalty) {
    // Simpan skor akhir ke Firestore
    saveFinalScore(score); // Pastikan untuk menyimpan skor

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('SKOR AKHIR')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Skor kamu adalah: $score dari $initialScore',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center, // Pusatkan teks
              ),
              const SizedBox(height: 10),
              Text(
                'Pengurangan Skor akibat Waktu: -$timePenalty',
                style: const TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center, // Pusatkan teks
              ),
              const SizedBox(height: 10),
              const Text(
                'Apakah kamu ingin mulai ulang?',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center, // Pusatkan teks
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                resetQuiz(); // Reset quiz
              },
              child: const Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(
                    context, '/materi1/'); // Tutup dialog
              },
              child: const Text('Tidak'),
            ),
          ],
        );
      },
    );
  }

  void resetQuiz() {
    setState(() {
      selectedAnswers = List.filled(5, null);
      score = initialScore;
      countdown = 60;
      shuffledOptions = generateShuffledOptions();
      startCountdownTimer();
    });
  }

  void startCountdownTimer() {
    isCounting = true; // Menandakan bahwa timer sedang berjalan
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        stopCountdown(); // Hentikan countdown jika sudah mencapai 0
        calculateScore(); // Hitung nilai jika waktu habis
      }
    });
  }
}

void saveFinalScore(int finalScore) async {
  // Dapatkan pengguna saat ini
  User? user = FirebaseAuth.instance.currentUser;

  // Pastikan user sudah login
  if (user != null) {
    String userId = user.uid; // Gunakan UID sebagai ID dokumen

    // Referensi ke dokumen pengguna di Firestore
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      // Ambil dokumen pengguna dari Firestore
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        // Ambil skor "cahaya dan bunyi" saat ini dari dokumen, jika ada, atau gunakan 0 jika tidak ada
        Map<String, dynamic>? userData =
            docSnapshot.data() as Map<String, dynamic>?;
        int currentScore = userData?['skor_cahaya_bunyi'] ?? 0;

        print("Skor 'Cahaya dan Bunyi' saat ini: $currentScore");
        print("Skor baru: $finalScore");

        // Perbarui skor jika skor baru lebih besar dari skor saat ini
        if (finalScore > currentScore) {
          await userDoc.update({'skor_cahaya_bunyi': finalScore});
          print(
              "Skor 'Cahaya dan Bunyi' berhasil diperbarui menjadi $finalScore.");
        } else {
          print(
              "Skor baru lebih kecil atau sama dengan skor saat ini, tidak ada pembaruan.");
        }
      } else {
        // Jika dokumen belum ada, buat dokumen baru dengan data pengguna dan skor awal
        await userDoc.set({
          'email': user.email,
          'name': user.displayName ?? 'Pengguna Baru',
          'skor_cahaya_bunyi': finalScore,
        });
        print(
            "Dokumen baru dibuat dengan skor $finalScore untuk 'Cahaya dan Bunyi'.");
      }
    } catch (e) {
      // Tangani error saat mengambil atau memperbarui data
      print("Terjadi error: $e");
    }
  } else {
    print("Tidak ada pengguna yang login.");
  }
}

// Kode ARViewScreenLamp
class ARViewScreenLamp extends StatelessWidget {
  const ARViewScreenLamp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lampu Belajar 3D'),
      ),
      body: const ModelViewer(
        src: 'assets/models/lampu.glb',
        alt: 'Lampu belajar',
        ar: true,
        autoRotate: true,
        cameraControls: true,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

// Kode ARViewScreenSpeaker
class ARViewScreenSpeaker extends StatelessWidget {
  const ARViewScreenSpeaker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speaker 3D'),
      ),
      body: const ModelViewer(
        src: 'assets/models/speaker.glb', // Ganti dengan path model 3D speaker
        alt: 'Speaker',
        ar: true,
        autoRotate: true,
        cameraControls: true,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
