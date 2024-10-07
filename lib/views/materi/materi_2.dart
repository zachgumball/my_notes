import 'package:flutter/material.dart';

class Materi2 extends StatelessWidget {
  const Materi2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi IPA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar di bagian atas halaman
            Image.asset(
              'assets/matahari.jpg', // Sesuaikan dengan path gambar Anda
              width: 200,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16), // Spasi antara gambar dan judul

            // Judul materi
            const Text(
              'Mengenal Cahaya dan Bunyi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16), // Spasi antara judul dan garis pemisah

            // Garis pemisah
            const Divider(
              thickness: 2,
              color: Colors.grey,
            ),

            const SizedBox(
                height: 16), // Spasi antara garis pemisah dan konten materi

            // Materi berikutnya di dalam kotak dengan sudut membulat (rounded corner)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20), // Rounded corners
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
                    'Materi 1: Mengenal Cahaya dan Bunyi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Penjelasan tentang hubungan antara cahaya dan ekosistem...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
