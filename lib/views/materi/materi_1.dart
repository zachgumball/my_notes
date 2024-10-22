import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Materi1 extends StatefulWidget {
  const Materi1({super.key});

  @override
  _Materi1State createState() => _Materi1State();
}

class _Materi1State extends State<Materi1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cahaya dan Bunyi'),
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
                      'assets/matahari.jpg',
                      width: 370,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mengenal Cahaya dan Bunyi',
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
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cahaya adalah gelombang elektromagnetik yang bisa kita lihat dengan mata. '
                          'Sumber cahaya terbesar yang kita kenal adalah Matahari. Tanpa cahaya, dunia akan gelap, '
                          'dan kita tidak bisa melihat benda-benda di sekitar kita.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sifat-sifat Cahaya:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '1. Cahaya Merambat Lurus\n'
                          'Cahaya selalu bergerak dalam garis lurus. Contohnya adalah sinar matahari yang masuk melalui jendela.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '2. Cahaya Dapat Dipantulkan\n'
                          'Cahaya bisa memantul jika mengenai permukaan yang halus dan mengkilap, seperti cermin.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '3. Cahaya Dapat Dibiaskan\n'
                          'Cahaya bisa dibelokkan saat melewati benda bening seperti air atau kaca. Contohnya adalah saat pensil terlihat bengkok di dalam air.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Manfaat Cahaya:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '- Cahaya membantu kita melihat benda-benda di sekitar.\n'
                          '- Cahaya matahari memberikan panas yang menjaga kita tetap hangat.\n'
                          '- Tumbuhan menggunakan cahaya untuk membuat makanan melalui proses fotosintesis.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Contoh Sumber Cahaya: Lampu Belajar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Salah satu contoh sumber cahaya buatan adalah lampu belajar. Lampu ini membantu kita belajar saat malam hari atau di ruangan gelap. '
                          'Lampu belajar bisa mengarahkan cahaya langsung ke buku atau benda lain yang kita perlukan.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ayo, lihat lampu belajar dalam bentuk 3D di bawah ini!',
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
                          builder: (context) => const ARViewScreenLamp(),
                        ),
                      );
                    },
                    child: const Text('Tampilkan Lampu Belajar 3D dalam AR'),
                  ),
                  const SizedBox(height: 20),
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
                          'Mengenal Bunyi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Bunyi adalah getaran yang merambat melalui udara, air, atau benda padat. Kita bisa mendengar bunyi ketika getaran ini mencapai telinga kita. '
                          'Sumber bunyi bisa berasal dari berbagai benda, seperti alat musik, suara manusia, atau suara kendaraan.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sifat-sifat Bunyi:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '1. Bunyi Merambat Melalui Media\n'
                          'Bunyi tidak bisa bergerak tanpa media perantara. Udara adalah media yang paling umum, tapi bunyi juga bisa merambat melalui air atau benda padat.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '2. Bunyi Dapat Dipantulkan\n'
                          'Bunyi dapat memantul seperti cahaya, contohnya adalah gema yang terjadi ketika kita berteriak di dalam gua atau ruangan besar.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '3. Bunyi Dapat Dibiaskan\n'
                          'Bunyi bisa berubah arah ketika melewati media yang berbeda, mirip seperti cahaya. Ini disebut pembiasan bunyi.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Manfaat Bunyi:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '- Kita menggunakan bunyi untuk berbicara dan berkomunikasi.\n'
                          '- Musik yang kita dengarkan adalah hasil dari getaran bunyi.\n'
                          '- Bunyi juga membantu kita mengetahui arah, seperti saat mendengar suara kendaraan yang mendekat.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Contoh Sumber Bunyi: Speaker Musik',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Speaker musik adalah perangkat yang mengubah sinyal listrik menjadi suara. Speaker ini digunakan untuk mendengarkan musik atau suara lainnya dengan lebih keras. '
                          'Kita bisa menghubungkan speaker ke berbagai perangkat seperti ponsel atau komputer untuk memperdengarkan musik di sekitar kita.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ayo, lihat speaker dalam bentuk 3D di bawah ini!',
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
                          builder: (context) => const ARViewScreenSpeaker(),
                        ),
                      );
                    },
                    child: const Text('Tampilkan Speaker 3D dalam AR'),
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
