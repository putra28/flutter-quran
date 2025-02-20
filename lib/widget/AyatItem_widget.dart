import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quran/widget/BookmarkModal_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class AyatItem extends StatelessWidget {
  final String title;
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
  void showDoaBottomSheet(BuildContext context, int number) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BookmarkModalWidget(
          title: title,
          ayat: number.toString(),
        );
      },
    );
  }

  const AyatItem({
    required this.title,
    required this.number,
    required this.arabicText,
    required this.translation,
    required this.latin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDoaBottomSheet(context, number), // Tampilkan modal saat diklik
      child: Padding(
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
                      convertToArabicNumeral(number),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
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
            const SizedBox(height: 5),
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
              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary),
            ),
            Divider(color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}

