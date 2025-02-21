import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_quran/widget/LastReadCard_widget.dart';
import 'package:flutter_quran/widget/FilterBar_widget.dart';
import 'package:flutter_quran/widget/SuraItem_widget.dart';
import 'package:flutter_quran/widget/DoaItem_widget.dart';
import 'package:flutter_quran/widget/DoaModal_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List searchResults = [];
  String selectedFilter = "Surah"; // Untuk menentukan apakah Surah atau Doa yang aktif
  int selectedIndex = 0;
  final List<String> filters = ["Surah", "Urutan", "Mekah", "Madinah", "Doa"];
  List surahList = [];
  List doaList = [];
  List filteredSurahList = [];
  // List<String?> lastRead = [null, null, null, null];

  @override
  void initState() {
    super.initState();
    loadSurahData();
    loadDoaData();
    // getLastRead().then((value) {
    //   setState(() {
    //     lastRead = value;
    //   });
    // });
  }

  Future<List<String?>> getLastRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    String? surah = prefs.getString('lastReadSurah');
    String? surahArabic = prefs.getString('lastReadSurahArabic');
    String? surahType = prefs.getString('lastReadSurahType');
    int? ayat = prefs.getInt('lastReadAyat');
    return [surah, surahArabic, surahType, ayat != null ? ayat.toString() : null];
  }

  void searchData(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults.clear();
      } else {
        searchResults = surahList
            .where((surah) => surah['nama'].toLowerCase().contains(query.toLowerCase()) ||
                              surah['arti'].toLowerCase().contains(query.toLowerCase()))
            .toList();

        searchResults.addAll(doaList
            .where((doa) => doa['doa'].toLowerCase().contains(query.toLowerCase()))
            .toList());
      }
    });
  }

  Future<void> loadSurahData() async {
    String data = await rootBundle.loadString('assets/json/surah.json');
    List<dynamic> jsonResult = json.decode(data);

    setState(() {
      surahList = jsonResult;
      filteredSurahList = List.from(surahList); // Default tanpa filter
    });
  }

  Future<void> loadDoaData() async {
    String data = await rootBundle.loadString('assets/json/doa.json');
    List<dynamic> doajsonResult = json.decode(data);

    setState(() {
      doaList = doajsonResult;
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
      } else if (selectedIndex == 4) {
      // Default tanpa filter (doa)
        filteredSurahList = List.from(doaList);
      } else {
        // Default tanpa filter (Surah)
        filteredSurahList = List.from(surahList);
      }
    });
  }

  void showDoaBottomSheet(BuildContext context, Map<String, dynamic> doa) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DoaBottomSheet(
          title: doa['doa'],
          arabicText: doa['ayat'],
          latinText: doa['latin'],
          translation: doa['artinya'],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: isSearching
            ? Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Cari Surah atau Doa...",
                    border: InputBorder.none,
                  ),
                  onChanged: searchData,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text("Al-Qur'an & Doa", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),),
              ),
        actions: [
          isSearching
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchController.clear();
                      searchResults.clear();
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
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
            
            FutureBuilder<List<String?>>(
            future: getLastRead(), // Setiap rebuild, ambil data terbaru dari SharedPreferences
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Loading indikator
              }
              if (!snapshot.hasData || snapshot.data![0] == null) {
                return Text("Belum ada bacaan terakhir");
              }

              List<String?> lastRead = snapshot.data!;
              return LastReadCard(
                title: lastRead[0] ?? "",
                arabicTitle: lastRead[1] ?? "",
                type: lastRead[2] ?? "",
                verse: lastRead[3] != null ? "Ayat ${lastRead[3]}" : "",
              );
            },
          ),

            // LastReadCard(
            //   title: lastRead[0] ?? "Belum ada bacaan terakhir",
            //   arabicTitle: lastRead[1] ?? "",
            //   type: lastRead[2] ?? "",
            //   verse: lastRead[3] != null ? "Ayat ${lastRead[3]}" : "",
            // ),

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
                itemCount: searchResults.isNotEmpty ? searchResults.length : filteredSurahList.length,
                itemBuilder: (context, index) {
                  var item = searchResults.isNotEmpty ? searchResults[index] : filteredSurahList[index];

                  return GestureDetector(
                    onTap: () {
                      if (item.containsKey('doa')) {
                        // Navigator.pushNamed(context, '/doa', arguments: item['id']);
                        showDoaBottomSheet(context, item);
                      } else {
                        Navigator.pushNamed(context, '/surah', arguments: int.parse(item['nomor']))
                      .then((_) => setState(() {})); // Refresh FutureBuilder setelah kembali;
                      }
                    },
                    child: item.containsKey('doa')
                        ? DoaItem(
                            number: index + 1,
                            title: item['doa'],
                          )
                        : SuraItem(
                            number: index + 1,
                            title: item['nama'],
                            details: '${item['ayat']} Ayat | ${item['type']} | Surah ke-${int.parse(item['nomor'])}',
                            arabicTitle: item['asma'],
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Theme.of(context).colorScheme.primary), 
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule, color: Theme.of(context).colorScheme.secondary), 
            label: 'Jadwal Adzan'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary), 
            label: 'Settings'
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/jadwal');
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      )
    );
  }
}
