import 'dart:io';

import 'package:flutter/material.dart';

Image getImage(String filePath, {double width = 35, double height = 35}) {
  if (File(filePath).existsSync() == false) {
    filePath = "assets/images/music_placeholder.png";
  }
  return filePath.contains('assets')
      ? Image.asset(
          filePath,
          height: height,
          width: width,
        )
      : Image.file(
          File(filePath),
          height: height,
          width: width,
        );
}

DecorationImage getDecorationImage(String filePath) {
  // var image = filePath.contains('assets')
  //         ? AssetImage(filePath)
  //         : FileImage(File(filePath));

  if (File(filePath).existsSync() == false &&
      filePath.startsWith('assets') == false) {
    filePath = "assets/images/music_placeholder.png";
  }
  // filePath = "assets/images/glass.png";
  if (filePath.contains('assets')) {
    return DecorationImage(image: AssetImage(filePath), fit: BoxFit.cover);
  }
  return DecorationImage(image: FileImage(File(filePath)), fit: BoxFit.cover);
}

Uri getUriResource(String uri) {
  // print('The URI: $uri');
  return uri.contains('assets')
      ? Uri.parse('asset:///$uri')
      : Uri.file(
          uri,
        );
}

extension StringExtension on String {
  String capitalized() {
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

  String truncate(int limit, {String placeholder = ''}) {
    return length > limit ? '${substring(0, limit)}$placeholder' : this;
  }
}

extension FileExtension on File {
  bool isValid() {
    if (path.startsWith('assets')) {
      return true;
    }
    return existsSync();
  }
}
