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
  int selectedIndex = 0;
  List surahList = [];
  List filteredSurahList = [];

  @override
  void initState() {
    super.initState();
    loadSurahData();
  }

  Future<void> loadSurahData() async {
    String data = await rootBundle.loadString('assets/json/surah.json');
    List<dynamic> jsonResult = json.decode(data);

    setState(() {
      surahList = jsonResult;
      filteredSurahList = List.from(surahList);
    });
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
        title: Text('Al Fatihah', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
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
            SurahCard(title: 'Al-Baqarah', verse: 'Ayat 123', type: 'Madinah', arabicTitle: 'البقرة', arti: 'Sapi Betina'),
            SizedBox(height: 16),
            Center(
              child: Image.asset('assets/images/bismillah.png', width: 250),
            ),
          ],
        ),
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