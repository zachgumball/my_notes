import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardViews extends StatelessWidget {
  const LeaderboardViews({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada data leaderboard.'));
          }

          // Filter data untuk mengambil pengguna dengan skor kuis
          final leaderboardData = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data.keys.any((key) => key.startsWith('skor_quiz'));
          }).toList();

          if (leaderboardData.isEmpty) {
            return const Center(
                child: Text('Tidak ada data leaderboard dengan skor lengkap.'));
          }

          // Menghitung total skor dan menyiapkan daftar nama dan skor
          List<Map<String, dynamic>> scoresList = leaderboardData.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final name = data['name'] ?? 'Unknown'; // Mengambil nama pengguna
            int totalScore = 0;

            data.forEach((key, value) {
              if (key.startsWith('skor_quiz') && value is int) {
                totalScore += value; // Menjumlahkan semua skor kuis
              }
            });

            return {'name': name, 'totalScore': totalScore, 'uid': doc.id};
          }).toList();

          // Mengurutkan scoresList berdasarkan totalScore secara menurun
          scoresList.sort((a, b) => b['totalScore'].compareTo(a['totalScore']));

          // Find the current user's position in the leaderboard
          final currentUserRank =
              scoresList.indexWhere((data) => data['uid'] == currentUser?.uid);

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: scoresList.length,
            itemBuilder: (context, index) {
              final scoreData = scoresList[index];
              final name = scoreData['name'];
              final totalScore = scoreData['totalScore'];

              // Warna khusus untuk ranking 1-3
              Color borderColor;
              if (index == 0) {
                borderColor = Colors.amber; // Peringkat 1
              } else if (index == 1) {
                borderColor = Colors.red; // Peringkat 2
              } else if (index == 2) {
                borderColor = Colors.blue; // Peringkat 3
              } else {
                borderColor = Colors.transparent;
              }

              // Highlight current user with an animation
              bool isCurrentUser = currentUserRank == index;

              return AnimatedContainer(
                duration:
                    const Duration(milliseconds: 500), // Duration for animation
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isCurrentUser ? Colors.green : borderColor,
                    width: isCurrentUser ? 3 : (index < 3 ? 3 : 0),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isCurrentUser ? Colors.green.shade50 : null,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isCurrentUser ? Colors.green : borderColor,
                    child: Text(
                      '${index + 1}', // Menampilkan ranking
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                      fontWeight:
                          index < 3 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: Text(
                    '$totalScore', // Menampilkan total skor
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
