import "package:cbt_software_win/core/helper/colors.dart";
import "package:flutter/material.dart";

final ButtonStyle buttonDanger = ElevatedButton.styleFrom(
  // minimumSize: Size(150, 50),
  backgroundColor: Colors.red,
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);

final ButtonStyle buttonSuccess = ElevatedButton.styleFrom(
  // minimumSize: Size(150, 50),
  backgroundColor: Colors.green,
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);

final ButtonStyle buttonDefault = ElevatedButton.styleFrom(
  // minimumSize: Size(150, 50),
  backgroundColor: appBackgroundColorVeryOpaque,
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);

final ButtonStyle buttonAppTheme = ElevatedButton.styleFrom(
  // minimumSize: Size(150, 50),
  backgroundColor: const Color(0xFFF0FFFF),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);

final ButtonStyle buttonAppOpaque = ElevatedButton.styleFrom(
  backgroundColor: null,
  foregroundColor: null,
  textStyle: const TextStyle(color: Colors.black),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);

final ButtonStyle buttonNoColor = ElevatedButton.styleFrom(
  // minimumSize: Size(150, 50),
  backgroundColor: null,
  foregroundColor: null,
  textStyle: const TextStyle(color: Colors.black),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);