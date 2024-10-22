import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class MateriEkosistem extends StatefulWidget {
  const MateriEkosistem({super.key});

  @override
  _MateriEkosistemState createState() => _MateriEkosistemState();
}

class _MateriEkosistemState extends State<MateriEkosistem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harmoni dalam Ekosistem'),
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
                    child: Image.asset(
                      'assets/ekosistem.jpg',
                      width: 370,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mengenal Harmoni dalam Ekosistem',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Divider(thickness: 2, color: Colors.grey),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16.0),
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
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ekosistem adalah suatu sistem di mana makhluk hidup berinteraksi dengan lingkungan dan makhluk hidup lainnya. '
                          'Dalam ekosistem, setiap komponen, baik itu hewan, tumbuhan, maupun mikroorganisme, saling berhubungan dan mempengaruhi satu sama lain.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Komponen dalam Ekosistem:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '1. Produsen\n'
                          'Tumbuhan berperan sebagai produsen dalam ekosistem karena dapat membuat makanan sendiri melalui proses fotosintesis.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '2. Konsumen\n'
                          'Hewan dan manusia merupakan konsumen karena mereka bergantung pada tumbuhan dan hewan lain untuk memperoleh makanan.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '3. Pengurai\n'
                          'Mikroorganisme, seperti bakteri dan jamur, berperan sebagai pengurai yang memecah sisa-sisa makhluk hidup menjadi unsur hara yang berguna bagi tanah.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Manfaat Ekosistem: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '- Menjaga keseimbangan alam.\n'
                          '- Menyediakan oksigen dan makanan bagi makhluk hidup.\n'
                          '- Menyediakan air bersih melalui daur air alami.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow[
                          100], // Warna background untuk box Tahukah Kamu
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Tahukah kamu?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.brown,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Elang adalah salah satu predator puncak dalam rantai makanan. Mereka memiliki penglihatan yang sangat tajam, '
                          'sehingga bisa melihat mangsa dari jarak yang jauh. Sayap elang kuat dan lebar, memungkinkannya terbang tinggi dan cepat '
                          'untuk memburu mangsa.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ayo, lihat Elang dalam 3D!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ARViewScreenElang(),
                        ),
                      );
                    },
                    child: const Text('Lihat'),
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
        backgroundColor: Colors.green[400],
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
      ['Produsen', 'Konsumen', 'Pengurai', 'Parasit'], // Untuk pertanyaan 1
      ['Rumput', 'Kambing', 'Elang', 'Bakteri'], // Untuk pertanyaan 2
      [
        'Hewan herbivora',
        'Hewan karnivora',
        'Hewan omnivora',
        'Pengurai'
      ], // Untuk pertanyaan 3
      ['Pengurai', 'Produsen', 'Konsumen', 'Parasit'], // Untuk pertanyaan 4
      ['Ekosistem', 'Populasi', 'Komunitas', 'Habitat'], // Untuk pertanyaan 5
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
      '1. Siapakah yang berperan sebagai pengurai dalam ekosistem?',
      '2. Contoh dari produsen dalam ekosistem adalah?',
      '3. Hewan yang memakan tumbuhan disebut?',
      '4. Organisme yang menguraikan bahan organik disebut?',
      '5. Kumpulan makhluk hidup yang hidup di suatu daerah disebut?',
    ];
    return questions[index];
  }

  String getCorrectAnswerIndex(int index) {
    const correctAnswers = [
      'Pengurai', // Jawaban benar untuk pertanyaan 1
      'Rumput', // Jawaban benar untuk pertanyaan 2
      'Hewan herbivora', // Jawaban benar untuk pertanyaan 3
      'Pengurai', // Jawaban benar untuk pertanyaan 4
      'Komunitas', // Jawaban benar untuk pertanyaan 5
    ];

    return correctAnswers[index];
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
                    context, '/materi2/'); // Tutup dialog
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
        int currentScore = userData?['skor_harmoni_ekosistem'] ?? 0;

        print("Skor 'Harmoni dalam Ekosistem' saat ini: $currentScore");
        print("Skor baru: $finalScore");

        // Perbarui skor jika skor baru lebih besar dari skor saat ini
        if (finalScore > currentScore) {
          await userDoc.update({'skor_harmoni_ekosistem': finalScore});
          print(
              "Skor 'Harmoni dalam Ekosistem' berhasil diperbarui menjadi $finalScore.");
        } else {
          print(
              "Skor baru lebih kecil atau sama dengan skor saat ini, tidak ada pembaruan.");
        }
      } else {
        // Jika dokumen belum ada, buat dokumen baru dengan data pengguna dan skor awal
        await userDoc.set({
          'email': user.email,
          'name': user.displayName ?? 'Pengguna Baru',
          'skor_harmoni_ekosistem': finalScore,
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
class ARViewScreenElang extends StatelessWidget {
  const ARViewScreenElang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elang 3D'),
      ),
      body: const ModelViewer(
        src: 'assets/models/elang.glb',
        alt: 'Elang 3D',
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
