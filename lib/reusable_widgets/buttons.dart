import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buttons(txt) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff5c5cff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(120),
      ),
      padding: const EdgeInsets.all(20),
    ),
    child: Text(
      txt,
      style: GoogleFonts.nunito(fontSize: 25, fontWeight: FontWeight.bold),
    ),
  );
}
