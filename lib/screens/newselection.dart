import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 30.0)),
            Text(
                style: GoogleFonts.nunito(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff6b7eb8),
                  decoration: TextDecoration.none,
                ),
                '...'),
          ],
        ),
        Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 25.0)),
            Text(
                style: GoogleFonts.nunito(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  decoration: TextDecoration.none,
                ),
                'Hello there!'),
            const SizedBox(
              width: 100,
            ),
            const ImageIcon(
              AssetImage("assets/images/onlylogo.png"),
              color: Color(0xFF5C5CFF),
              size: 70,
            ),
          ],
        ),
        const Divider(
          color: Color(0xff8886ba),
          height: 10,
          thickness: 4,
          indent: 60,
          endIndent: 220,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
            style: GoogleFonts.nunito(
              fontSize: 35,
              color: const Color(0xff868686),
              decoration: TextDecoration.none,
            ),
            'Who Are You?'),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 20, 20),
            child: Column(
              children: <Widget>[
                Container(
                  width: 300.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xFFfce7ee),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/students.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      width: 150.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xFFfce7ee),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/teacher-1.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 150.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xFFfce7ee),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/parent-1.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
