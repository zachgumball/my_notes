import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardViews extends StatelessWidget {
  const LeaderboardViews({super.key});

  @override
  Widget build(BuildContext context) {
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

          // Filter data to include only users with complete scores
          final leaderboardData = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data.containsKey('skor_cahaya_bunyi') &&
                data.containsKey('skor_harmoni_ekosistem');
          }).toList();

          if (leaderboardData.isEmpty) {
            return const Center(
                child: Text('Tidak ada data leaderboard dengan skor lengkap.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: leaderboardData.length,
            itemBuilder: (context, index) {
              final data =
                  leaderboardData[index].data() as Map<String, dynamic>;

              final name = data['name'] ?? 'Unknown';
              final skorCahayaBunyi = data['skor_cahaya_bunyi'] ?? 0;
              final skorEkosistem = data['skor_harmoni_ekosistem'] ?? 0;
              final totalScore = skorCahayaBunyi + skorEkosistem;

              // Warna khusus untuk ranking 1-3
              Color borderColor;
              if (index == 0) {
                borderColor = Colors.amber; // Peringkat 1
              } else if (index == 1) {
                borderColor = Colors.red; // Peringkat 2
              } else if (index == 2) {
                borderColor = Colors.blue; // Peringkat 3
              } else {
                borderColor = Colors
                    .transparent; // Tidak ada border untuk ranking lainnya
              }

              // Border mencakup nama dan skor, hanya untuk peringkat 1-3
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: borderColor,
                    width: index < 3 ? 3 : 0, // Lebar border hanya untuk top 3
                  ),
                  borderRadius: BorderRadius.circular(
                      12), // Border radius agar lebih halus
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: borderColor,
                    child: Text(
                      '${index + 1}',
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
                    '$totalScore',
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
