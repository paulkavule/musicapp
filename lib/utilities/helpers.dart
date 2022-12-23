import 'dart:io';

import 'package:flutter/material.dart';

Image GetImage(String filePath) {
  if (File(filePath).existsSync() == false) {
    filePath = "assets/images/music_placeholder.png";
  }
  return filePath.contains('assets')
      ? Image.asset(
          filePath,
          height: 35,
          width: 35,
        )
      : Image.file(
          File(filePath),
          height: 35,
          width: 35,
        );
}

extension StringExtension on String {
  String capitalize() {
    final capitalizedWords = split(' ').map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    return capitalizedWords.join(' ');
  }
}
