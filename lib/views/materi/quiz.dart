import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class QuizPage extends StatefulWidget {
  final String materiDocumentId;
  final String subMateriDocumentId;
  final String isiMateriId;

  const QuizPage({
    Key? key,
    required this.materiDocumentId,
    required this.subMateriDocumentId,
    required this.isiMateriId,
  }) : super(key: key);

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
          score -= 2;
          lostScore += 2;
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
          score -= 200;
          correctAnswers[questionIndex] = false;
        } else if (!correctAnswers[questionIndex] && isCorrect) {
          score += 200;
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

  // Mengakhiri kuis dan menampilkan dialog hasil skor
  void _finishQuiz(BuildContext context) {
    countdownTimer?.cancel();

    _updateScoreInFirestore(score).then((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Quiz Selesai'),
            content: Text(
                'Skor kamu adalah: $score\nSkor yang terbuang: $lostScore'),
            actions: [
              TextButton(
                child: const Text('Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Restart'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _initializeQuiz();
                },
              ),
            ],
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
                                color: Colors.blue[100],
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
                                childAspectRatio: 3,
                              ),
                              itemCount: options.length,
                              itemBuilder: (context, optionIndex) {
                                String option = options[optionIndex];

                                return GestureDetector(
                                  onTap: () {
                                    _selectAnswer(index, optionIndex);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color:
                                          selectedAnswers[index] == optionIndex
                                              ? Colors.lightBlue[200]
                                              : const Color.fromARGB(
                                                  255, 184, 233, 7),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        option,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(thickness: 2, color: Colors.grey),
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
                    child: const Text('Finish'),
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
