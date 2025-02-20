import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_quran/widget/JadwalCard_widget.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  Map<String, String>? jadwalHariIni;
  bool isLoading = true;
  String? keteranganWaktu;
  String? estimasi;

  @override
  void initState() {
    super.initState();
    fetchJadwalSholat();
  }

  Future<void> fetchJadwalSholat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tahun = DateFormat('yyyy').format(DateTime.now());
    String bulan = DateFormat('MM').format(DateTime.now());
    String tanggalHariIni = DateFormat('yyyy-MM-dd').format(DateTime.now());

    String? cachedData = prefs.getString('jadwal_sholat');
    String? cachedDate = prefs.getString('tanggal_sholat');

    if (cachedData != null && cachedDate == tanggalHariIni) {
      setState(() {
        jadwalHariIni = Map<String, String>.from(json.decode(cachedData));
        isLoading = false;
        updateKeteranganWaktu();
      });
      return;
    }

    String url = 'https://raw.githubusercontent.com/lakuapik/jadwalsholatorg/master/adzan/bandung/$tahun/$bulan.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        var jadwal = data.firstWhere(
          (item) => item['tanggal'] == tanggalHariIni,
          orElse: () => null,
        );

        if (jadwal != null) {
          jadwalHariIni = {
            'Imsak': jadwal['imsyak'],
            'Subuh': jadwal['shubuh'],
            'Terbit': jadwal['terbit'],
            'Dhuha': jadwal['dhuha'],
            'Dzuhur': jadwal['dzuhur'],
            'Ashar': jadwal['ashr'],
            'Maghrib': jadwal['magrib'],
            'Isya': jadwal['isya'],
          };
          print("Data JSON: ${response.body}");
          prefs.setString('jadwal_sholat', json.encode(jadwalHariIni));
          prefs.setString('tanggal_sholat', tanggalHariIni);
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      isLoading = false;
      updateKeteranganWaktu();
    });
  }

  // void updateKeteranganWaktu() {
  //   if (jadwalHariIni == null) return;
  //   DateTime now = DateTime.now();
  //   List<String> waktuSholat = jadwalHariIni!.values.toList();
  //   List<String> namaSholat = jadwalHariIni!.keys.toList();

  //   for (int i = 0; i < waktuSholat.length; i++) {
  //     DateTime waktu = DateFormat("HH:mm").parse(waktuSholat[i]);
  //     DateTime waktuSholatDateTime = DateTime(now.year, now.month, now.day, waktu.hour, waktu.minute);

  //     if (now.isBefore(waktuSholatDateTime)) {
  //       if (waktuSholatDateTime.difference(now).inMinutes <= 30) {
  //         keteranganWaktu = "Menjelang Waktu ${namaSholat[i]}";
  //         estimasi = "${waktuSholatDateTime.difference(now).inMinutes} Menit Lagi";
  //       } else {
  //         keteranganWaktu = "Waktu ${namaSholat[i - 1]}";
  //         estimasi = "";
  //       }
  //       break;
  //     }
  //   }
  // }

  void updateKeteranganWaktu() {
  if (jadwalHariIni == null || jadwalHariIni!.isEmpty) return;

  DateTime now = DateTime.now();
  List<String> waktuSholat = jadwalHariIni!.values.toList();
  List<String> namaSholat = jadwalHariIni!.keys.toList();

  for (int i = 0; i < waktuSholat.length; i++) {
    DateTime waktu = DateFormat("HH:mm").parse(waktuSholat[i]);
    DateTime waktuSholatDateTime = DateTime(now.year, now.month, now.day, waktu.hour, waktu.minute);

    if (now.isBefore(waktuSholatDateTime)) {
      if (waktuSholatDateTime.difference(now).inMinutes <= 30) {
        keteranganWaktu = "Menjelang Waktu ${namaSholat[i]}";
        estimasi = "${waktuSholatDateTime.difference(now).inMinutes} Menit Lagi";
      } else {
        keteranganWaktu = i > 0 ? "Waktu ${namaSholat[i - 1]}" : "Menunggu Waktu ${namaSholat[i]}";
        estimasi = i > 0 ? "" : "Menunggu waktu sholat berikutnya";
      }
      break;
    }
  }

  // Jika sekarang sudah melewati semua jadwal sholat
  if (keteranganWaktu == null) {
    keteranganWaktu = "Waktu ${namaSholat.last}";
    estimasi = "";
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Jadwal Sholat Hari Ini',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '21 Sya`ban 1446H',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary),
                ),
                Text(
                  '20 Februari 2025',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            SizedBox(height: 15),
            JadwalCard(keterangan: keteranganWaktu ?? "cb", estimasi: estimasi ?? "cb", lokasi: 'Bandung'),
            SizedBox(height: 15),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: jadwalHariIni?.length ?? 0,
                      itemBuilder: (context, index) {
                        String key = jadwalHariIni!.keys.elementAt(index);
                        return JadwalItem(
                          title: key,
                          time: jadwalHariIni![key]!,
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
            icon: Icon(Icons.home, color: Theme.of(context).colorScheme.secondary), 
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, color: Theme.of(context).colorScheme.secondary), 
            label: 'Bookmarks'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule, color: Theme.of(context).colorScheme.primary), 
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
              Navigator.pushNamed(context, '/bookmarks');
              break;
            case 2:
              Navigator.pushNamed(context, '/jadwal');
              break;
            case 3:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      )
    );
  }
}

class JadwalItem extends StatelessWidget {
  final String title;
  final String time;

  JadwalItem({required this.title, required this.time});

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
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}
