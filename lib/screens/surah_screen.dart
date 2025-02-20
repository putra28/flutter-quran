import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  Map<String, dynamic>? surahData;
  List<dynamic> ayatList = [];
  int? surahNumber; // Menyimpan nomor surah yang diterima

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ambil nomor surah dari arguments
    surahNumber = ModalRoute.of(context)?.settings.arguments as int?;
    if (surahNumber != null) {
      loadAyatData(surahNumber!);
    }
  }

  Future<void> loadAyatData(int nomor) async {
    String data = await rootBundle.loadString(
      'assets/json/surah.json',
    ); 
    List<dynamic> jsonResult = json.decode(data);

    // Cari surah dengan nomor yang sesuai
    var selectedSurah = jsonResult.firstWhere(
      (surah) => surah['nomor'] == nomor.toString(),
      orElse: () => null,
    );

    if (selectedSurah != null) {
      setState(() {
        surahData = selectedSurah;
        ayatList = surahData?['isi'] ?? [];
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
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            ),
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
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
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
              nomor: surahData?['nomor'] ?? '',
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: ayatList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Center(
                      child: Image.asset('assets/images/bismillah.png', width: 250),
                    );
                  } else {
                    var ayat = ayatList[index - 1];
                    return AyatItem(
                      number: int.tryParse(ayat['nomor']) ?? 0,
                      arabicText: ayat['ar'],
                      translation: ayat['id'],
                      latin: ayat['tr'],
                    );
                  }
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
  final String latin;

  String decodeHtml(String text) {
    final unescape = HtmlUnescape();
    return unescape.convert(text);
  }

  String convertToArabicNumeral(int number) {
    // Peta angka Latin (0-9) ke angka Arabic-Indic
    const arabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    // Ubah setiap digit angka menjadi angka Arab
    return number.toString().split('').map((digit) => arabicNumerals[int.parse(digit)]).join('');
  }

  const AyatItem({
    required this.number,
    required this.arabicText,
    required this.translation,
    required this.latin,
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
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/ayatNumber.png',
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    convertToArabicNumeral(number), //ayat Number
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  arabicText,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          // Html(
          //   data: latin,
          //   style: {
          //     "strong": Style(
          //       fontSize: FontSize(15),
          //       fontWeight: FontWeight.bold,
          //       color: Theme.of(context).colorScheme.secondary,
          //     ),
          //     "u": Style(
          //       fontSize: FontSize(15),
          //       fontWeight: FontWeight.bold,
          //       textDecoration: TextDecoration.underline,
          //       color: Theme.of(context).colorScheme.secondary,
          //     ),
          //     "body": Style(
          //       fontSize: FontSize(15),
          //       fontWeight: FontWeight.bold,
          //       padding: HtmlPaddings.zero,
          //     ),
          //   },
          // ),
          Text(
            translation,
            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary,),
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
  final String nomor;

  const SurahCard({
    required this.title,
    required this.verse,
    required this.type,
    required this.arabicTitle,
    required this.arti,
    required this.nomor,
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
              SizedBox(height: 4),
              Text(
                "Surah ke-"+nomor,
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
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
