import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/SurahNumber.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final List<String> filters = ["Surah", "Urutan", "Mekah", "Madinah", "Doa"];
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
      filteredSurahList = List.from(surahList); // Default tanpa filter
    });
  }

  void applyFilter() {
    setState(() {
      if (selectedIndex == 1) {
        // Urutan berdasarkan field "urut" (dikonversi ke integer)
        filteredSurahList.sort((a, b) => int.parse(a['urut']).compareTo(int.parse(b['urut'])));
      } else if (selectedIndex == 2) {
        // Filter hanya "Mekah"
        filteredSurahList = surahList.where((surah) => surah['type'] == 'Mekah').toList();
      } else if (selectedIndex == 3) {
        // Filter hanya "Madinah"
        filteredSurahList = surahList.where((surah) => surah['type'] == 'Madinah').toList();
      } else {
        // Default tanpa filter (Surah)
        filteredSurahList = List.from(surahList);
      }
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
            icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.primary),
            onPressed: () {},
          ),
        ),
        title: Text('Al Quran', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
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
            Text(
              'Last Read',
              style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15),

            LastReadCard(title: 'Al-Baqarah', verse: 'Ayat 123', type: 'Madaniyah', arabicTitle: 'البقرة'),

            SizedBox(height: 16),

            FilterBar(
              filters: filters,
              selectedIndex: selectedIndex,
              onSelected: (index) {
                setState(() {
                  selectedIndex = index;
                  applyFilter();
                });
              },
            ),

            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSurahList.length,
                itemBuilder: (context, index) {
                  var surah = filteredSurahList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/surah', arguments: surah);
                    },
                    child: SuraItem(
                      number: int.parse(surah['nomor']),
                      title: surah['nama'],
                      details: '${surah['ayat']} Ayat | ${surah['type']}',
                      arabicTitle: surah['asma'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Theme.of(context).colorScheme.primary), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark, color: Theme.of(context).colorScheme.secondary), label: 'Bookmarks'),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: Theme.of(context).colorScheme.secondary), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary), label: 'Settings'),
        ],
      ),
    );
  }
}

class LastReadCard extends StatelessWidget {
  final String title;
  final String verse;
  final String type;
  final String arabicTitle;

  const LastReadCard({
    required this.title,
    required this.verse,
    required this.type,
    required this.arabicTitle,
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
                verse + ' | ' + type,
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

class FilterBar extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final Function(int) onSelected;

  const FilterBar({
    Key? key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xFF795546),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(filters.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selectedIndex == index ? Color(0xFFcb9d78) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    filters[index],
                    style: TextStyle(
                      fontSize: width * 0.033,
                      color: Color(0xFFfffff4),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SuraItem extends StatelessWidget {
  final int number;
  final String title;
  final String details;
  final String arabicTitle;

  const SuraItem({
    required this.number,
    required this.title,
    required this.details,
    required this.arabicTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SurahNumberIcon(number: number),
              SizedBox(width: 13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                  SizedBox(height: 7),
                  Text(details, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
            ],
          ),
          Text(arabicTitle, style: GoogleFonts.scheherazadeNew(color: Theme.of(context).colorScheme.primary, fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
