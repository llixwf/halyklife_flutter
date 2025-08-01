import 'package:astra_app_1/code.dart';
import 'package:astra_app_1/language.dart';
import 'package:astra_app_1/token_manager.dart';
import "package:flutter/material.dart";
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigator();
  }

  void _navigator() async {
    await Future.delayed(Duration(seconds: 2));
    if (TokenStorage.token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Code()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Language()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('images/Logo-3.png', width: 300)),
    );
  }
}
