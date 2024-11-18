import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class QuizPage extends StatefulWidget {
  final String materiDocumentId;
  final String subMateriDocumentId;
  final String isiMateriId;

  const QuizPage({
    super.key,
    required this.materiDocumentId,
    required this.subMateriDocumentId,
    required this.isiMateriId,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<Map<String, dynamic>>> questionsFuture;
  String isiMateriTitle = '';
  List<int> selectedAnswers = [];
  List<bool> correctAnswers = [];
  int score = 0;
  int lostScore = 0;
  int countdownSeconds = 60;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  // Inisialisasi nilai skor dan pengaturan timer countdown
  void _initializeQuiz() {
    score = 0;
    lostScore = 0;
    correctQuestionsCount = 0;
    incorrectQuestionsCount = 0;

    // Mengambil soal-soal dari database dan mempersiapkan list jawaban
    questionsFuture = fetchQuestions().then((questions) {
      selectedAnswers = List<int>.filled(questions.length, -1);
      correctAnswers = List<bool>.filled(questions.length, false);
      return questions;
    });

    isiMateriTitle = widget.isiMateriId;

    // Set countdown waktu
    countdownSeconds = 60;
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds > 0) {
        setState(() {
          countdownSeconds--;
          if (countdownSeconds <= 50) {
            score -= 2; // Kurangi skor setiap detiknya setelah 10 detik
            lostScore += 2; // Akumulasi skor yang hilang
          }
        });
      } else {
        timer.cancel();
        _finishQuiz(context);
      }
    });
  }

  // Mengambil data soal dari Firestore berdasarkan ID yang diberikan
  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('mata_pelajaran')
          .doc(widget.materiDocumentId)
          .collection('sub_materi')
          .doc(widget.subMateriDocumentId)
          .collection('isi_materi')
          .doc(widget.isiMateriId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic> questions = snapshot['questions'];

        return questions.map<Map<String, dynamic>>((questionData) {
          List<String> options = List<String>.from(questionData['options']);
          options.shuffle(); // Mengacak urutan pilihan

          String correctAnswer = questionData['options'][0];
          int correctAnswerIndex = options.indexOf(correctAnswer);

          return {
            'question': questionData['question'],
            'options': options,
            'correctAnswerIndex': correctAnswerIndex,
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching quiz questions: $e');
      return [];
    }
  }

  // Fungsi untuk memilih jawaban dan mengecek apakah jawaban benar atau salah
  void _selectAnswer(int questionIndex, int selectedIndex) {
    setState(() {
      questionsFuture.then((questions) {
        int correctIndex = questions[questionIndex]['correctAnswerIndex'];
        bool isCorrect = selectedIndex == correctIndex;

        // Mengupdate skor berdasarkan jawaban
        if (correctAnswers[questionIndex] && !isCorrect) {
          score -= 100;
          correctAnswers[questionIndex] = false;
        } else if (!correctAnswers[questionIndex] && isCorrect) {
          score += 100;
          correctAnswers[questionIndex] = true;
        }

        selectedAnswers[questionIndex] = selectedIndex;
      });
    });
  }

  // Fungsi untuk mengupdate skor pengguna di Firestore jika skor baru lebih besar dari skor sebelumnya
  Future<void> _updateScoreInFirestore(int score) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      String scoreField = 'skor_quiz${widget.isiMateriId}';

      DocumentSnapshot snapshot = await userDoc.get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      int currentScore = (data != null && data.containsKey(scoreField))
          ? data[scoreField] ?? 0
          : 0;

      if (score > currentScore) {
        await userDoc.set({
          scoreField: score,
        }, SetOptions(merge: true));
      } else {
        print('Skor baru tidak lebih tinggi dari skor sebelumnya.');
      }
    }
  }

  // Variabel untuk menyimpan jumlah soal yang dijawab benar dan salah
  int correctQuestionsCount = 0;
  int incorrectQuestionsCount = 0;
  // Mengakhiri kuis dan menampilkan dialog hasil skor
  void _finishQuiz(BuildContext context) {
    countdownTimer?.cancel();

    // Hitung jumlah soal yang benar dan salah
    for (int i = 0; i < correctAnswers.length; i++) {
      if (correctAnswers[i]) {
        correctQuestionsCount++;
      } else {
        incorrectQuestionsCount++;
      }
    }

    _updateScoreInFirestore(score).then((_) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 8.0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Display the GIF with animation effect (GIF animation will be handled natively)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('assets/congrats.gif',
                        height: 150, width: 150),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Skor kamu adalah: $score',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display correct and incorrect questions count
                  Text(
                    'Benar: $correctQuestionsCount',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 5, 235, 55),
                    ),
                  ),
                  Text(
                    'Salah: $incorrectQuestionsCount',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Back button with modern style
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Back'),
                      ),
                      const SizedBox(width: 20),
                      // Restart button with a contrasting style
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _initializeQuiz();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Restart'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isiMateriTitle.isEmpty ? 'Quiz' : isiMateriTitle),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada soal.'));
          } else {
            List<Map<String, dynamic>> questions = snapshot.data!;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Waktu Tersisa: $countdownSeconds detik',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final options = question['options'];

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 135, 202, 229),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                question['question'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 8),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                                childAspectRatio: 2.7,
                              ),
                              itemCount: options.length,
                              itemBuilder: (context, optionIndex) {
                                String option = options[optionIndex];

                                // Define a list of colors for the answer options
                                List<Color> optionColors = [
                                  Colors.green[200]!,
                                  Colors.blue[200]!,
                                  Colors.orange[200]!,
                                  Colors.purple[200]!,
                                ];

                                bool isSelected =
                                    selectedAnswers[index] == optionIndex;

                                return GestureDetector(
                                  onTap: () {
                                    _selectAnswer(index, optionIndex);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                        milliseconds:
                                            300), // Animation duration
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color.fromARGB(255, 10, 112,
                                              237) // Selected color
                                          : optionColors[optionIndex %
                                              optionColors.length],
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: isSelected
                                          ? Border.all(
                                              color: Colors.blueAccent,
                                              width:
                                                  2.0, // Border thickness for selected answer
                                            )
                                          : Border.all(
                                              color: Colors.transparent,
                                              width:
                                                  2.0, // No border for non-selected answers
                                            ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        option,
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                        maxLines: 2, // Max number of lines
                                        overflow: TextOverflow
                                            .ellipsis, // Ellipsis if text is too long
                                        softWrap:
                                            true, // Wraps text if necessary
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => _finishQuiz(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 91, 142, 231), // Button background color
                      foregroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 40), // Padding inside the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                      elevation: 5, // Shadow effect
                      textStyle: const TextStyle(
                        fontSize: 18, // Larger text size
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                      side: const BorderSide(
                          color: Colors.blueAccent,
                          width: 2), // Border color and thickness
                    ),
                    child: const Text('Selesai'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
