import 'package:agendacontatos/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  return runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: Colors.red,
        backgroundColor: Colors.white,
  )));
}
