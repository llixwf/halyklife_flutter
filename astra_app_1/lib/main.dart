// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:astra_app_1/search.dart';
import 'package:astra_app_1/splash.dart';
import 'package:flutter/material.dart';
import 'language.dart';
import 'login.dart';
import 'sign.dart';
import 'phone.dart';
import 'password.dart';
import 'code.dart';
import 'catalog.dart';
import 'product.dart';
import 'cart.dart';
import 'token_manager.dart';
import 'like.dart';
import 'filter.dart';

// import 'data.dart';
// import 'account.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenStorage.loadToken();

  // WidgetsFlutterBinding.ensureInitialized();
  // try {
  //   await Firebase.initializeApp();
  //   print('Firebase подключён успешно!');
  // } catch (e) {
  //   print('Ошибка подключения Firebase: $e');
  // }
  runApp(
    MaterialApp(
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFFF8A00),
          unselectedItemColor: Colors.grey,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        "/language": (context) => Language(),
        "/LogIn": (context) => LogIn(),
        "/SignUp": (context) => SignUp(),
        "/phonever": (context) => PhoneVer(),
        "/PasRec": (context) => PasRec(),
        "/PasRec2": (context) => PasRec2(),
        "/Code": (context) => Code(),
        "/Catalog": (context) => Catalog(),
        "/Product": (context) => Product(categoryName: '', categoryId: ''),
        "/Cart": (conext) => Cart(),
        "/Liked": (context) => Like(),
        '/Filter': (context) => FilterPage(),
        "/Search": (context) => Search(),
        // "/Profile": (context) => Widget2(),
        // "/Data": (context) => Datas(),
        // "/UserInp": (context) => UserInp(),
      },
    ),
  );
}
