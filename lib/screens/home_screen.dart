import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/SurahNumber.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final List<String> filters = ["Surah", "Juz", "Makkiyah", "Madaniyah", "Rukuk"];

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

            LastReadCard(title: 'Al-Baqarah', verse: 'Ayat 123', type: 'Medinan', arabicTitle: 'البقرة'),

            SizedBox(height: 16),

            FilterBar(
              filters: filters,
              selectedIndex: selectedIndex,
              onSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),

            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  SuraItem(number: 1, title: 'Al-Fatihah', details: '7 Verses | Meccan', arabicTitle: 'الفاتحة'),
                  SuraItem(number: 2, title: 'Al-Baqarah', details: '286 Verses | Medinan', arabicTitle: 'البقرة'),
                  SuraItem(number: 3, title: 'Aal-e-Imran', details: '200 Verses | Medinan', arabicTitle: 'آل عمران'),
                  SuraItem(number: 4, title: 'An-Nisa\'', details: '176 Verses | Medinan', arabicTitle: 'النساء'),
                  SuraItem(number: 5, title: 'Al-Ma\'idah', details: '120 Verses | Medinan', arabicTitle: 'المائدة'),
                ],
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
                      fontSize: 13,
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
