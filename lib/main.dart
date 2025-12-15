import 'package:flutter/material.dart';
import 'screens/home_screen.dart';


void main() {
runApp(LearnNumbersApp());
}


class LearnNumbersApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Learn Numbers',
debugShowCheckedModeBanner: false,
theme: ThemeData(
primarySwatch: Colors.blue,
scaffoldBackgroundColor: Colors.white,
),
home: HomeScreen(),
);
}
}
