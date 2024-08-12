import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Roboto'),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black, fontFamily: 'Roboto'), // bodyText1
    bodyMedium: TextStyle(color: Colors.black, fontFamily: 'Roboto'), // bodyText2
    titleMedium: TextStyle(color: Colors.black, fontFamily: 'Roboto'), // headline6
  ),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Roboto'),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'), // bodyText1
    bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Roboto'), // bodyText2
    titleMedium: TextStyle(color: Colors.white, fontFamily: 'Roboto'), // headline6
  ),
);

final ThemeData customTheme = ThemeData(
  primarySwatch: Colors.green,
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'OpenSans'),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.green,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black, fontFamily: 'OpenSans'), // bodyText1
    bodyMedium: TextStyle(color: Colors.black, fontFamily: 'OpenSans'), // bodyText2
    titleMedium: TextStyle(color: Colors.black, fontFamily: 'OpenSans'), // headline6
  ),
);

// Define font themes for Roboto, Lato, and OpenSans
final ThemeData robotoTheme = ThemeData(
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontFamily: 'Roboto'), // bodyText1
    bodyMedium: TextStyle(fontFamily: 'Roboto'), // bodyText2
    titleMedium: TextStyle(fontFamily: 'Roboto'), // headline6
  ),
);

final ThemeData latoTheme = ThemeData(
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontFamily: 'Lato'), // bodyText1
    bodyMedium: TextStyle(fontFamily: 'Lato'), // bodyText2
    titleMedium: TextStyle(fontFamily: 'Lato'), // headline6
  ),
);

final ThemeData openSansTheme = ThemeData(
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontFamily: 'OpenSans'), // bodyText1
    bodyMedium: TextStyle(fontFamily: 'OpenSans'), // bodyText2
    titleMedium: TextStyle(fontFamily: 'OpenSans'), // headline6
  ),
);
