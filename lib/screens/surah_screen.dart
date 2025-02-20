import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  Map<String, dynamic>? surahData;
  List<dynamic> ayatList = [];

  @override
  void initState() {
    super.initState();
    loadAyatData();
  }

  Future<void> loadAyatData() async {
    String data = await rootBundle.loadString('assets/json/contoh.json'); // Sesuaikan path JSON
    List<dynamic> jsonResult = json.decode(data);

    if (jsonResult.isNotEmpty) {
      setState(() {
        surahData = jsonResult[0]; // Mengambil data surah pertama
        ayatList = surahData?['isi'] ?? []; // Mengambil daftar ayat
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Text(
          surahData?['nama'] ?? 'Loading...',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SurahCard(
              title: surahData?['nama'] ?? 'Loading...',
              verse: surahData?['ayat'].toString() ?? '0',
              type: surahData?['type'] ?? '',
              arabicTitle: surahData?['asma'] ?? '',
              arti: surahData?['arti'] ?? '',
            ),
            SizedBox(height: 16),
            Center(
              child: Image.asset('assets/images/bismillah.png', width: 250),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: ayatList.length,
                itemBuilder: (context, index) {
                  var ayat = ayatList[index];
                  return AyatItem(
                    number: int.tryParse(ayat['nomor']) ?? 0,
                    arabicText: ayat['ar'],
                    translation: ayat['id'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AyatItem extends StatelessWidget {
  final int number;
  final String arabicText;
  final String translation;

  const AyatItem({
    required this.number,
    required this.arabicText,
    required this.translation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.brown[200],
                child: Text(number.toString(), style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  arabicText,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            translation,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }
}


class SurahCard extends StatelessWidget {
  final String title;
  final String verse;
  final String type;
  final String arabicTitle;
  final String arti;

  const SurahCard({
    required this.title,
    required this.verse,
    required this.type,
    required this.arabicTitle,
    required this.arti,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                arti,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 15),
              Text(
                verse + ' Ayat',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                type,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            arabicTitle,
            style: GoogleFonts.scheherazadeNew(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}