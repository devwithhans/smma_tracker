import 'package:flutter/material.dart';

BoxDecoration shadowRoundedWhiteBox = BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(8)),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ],
  color: Colors.white,
);
