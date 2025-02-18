import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ),
        title: Text('Al Quran', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Read',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  LastReadCard(title: 'Al-Baqarah', verse: 'Verse 285'),
                  LastReadCard(title: 'Al-Mumtahanah', verse: 'Verse 9'),
                  LastReadCard(title: 'Al-Ma\'idah', verse: 'Verse 3'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterButton(title: 'Sura', isSelected: true),
                FilterButton(title: 'Page'),
                FilterButton(title: 'Juz'),
                FilterButton(title: 'Hizb'),
                FilterButton(title: 'Ruku'),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  SuraItem(
                    number: 1,
                    title: 'Al-Fatihah',
                    details: '7 Verses | Meccan',
                    arabicTitle: 'الفاتحة',
                  ),
                  SuraItem(
                    number: 2,
                    title: 'Al-Baqarah',
                    details: '286 Verses | Medinan',
                    arabicTitle: 'البقرة',
                  ),
                  SuraItem(
                    number: 3,
                    title: 'Aal-e-Imran',
                    details: '200 Verses | Medinan',
                    arabicTitle: 'آل عمران',
                  ),
                  SuraItem(
                    number: 4,
                    title: 'An-Nisa\'',
                    details: '176 Verses | Medinan',
                    arabicTitle: 'النساء',
                  ),
                  SuraItem(
                    number: 5,
                    title: 'Al-Ma\'idah',
                    details: '120 Verses | Medinan',
                    arabicTitle: 'المائدة',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFFD69E2E)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, color: Color(0xFFA0AEC0)),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color(0xFFA0AEC0)),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Color(0xFFA0AEC0)),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class LastReadCard extends StatelessWidget {
  final String title;
  final String verse;

  const LastReadCard({required this.title, required this.verse});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFFEEBC8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Color(0xFF3D3D3D))),
          Text(verse, style: TextStyle(color: Color(0xFF3D3D3D), fontSize: 12)),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String title;
  final bool isSelected;

  const FilterButton({required this.title, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFD69E2E) : Color(0xFFFEEBC8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.white : Color(0xFF3D3D3D)),
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFFEEBC8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  number.toString(),
                  style: TextStyle(color: Color(0xFF3D3D3D)),
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(details, style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          Text(arabicTitle, style: TextStyle(color: Color(0xFF3D3D3D))),
        ],
      ),
    );
  }
}
