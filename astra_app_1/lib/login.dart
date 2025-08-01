// import 'package:flutter/material.dart';

// class LogIn extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Image.asset("images/Logo-3.png", height: 35),
//         iconTheme: IconThemeData(size: 30),
//       ),
//       body: Rega(),
//     );
//   }
// }

// class Rega extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: EdgeInsets.only(left: 20),
//                 child: Text(
//                   "Вход",
//                   style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             SizedBox(height: 40),
//             Container(
//               width: 400,
//               child: TextField(
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(
//                     left: 20,
//                     top: 18,
//                     bottom: 18,
//                   ),
//                   hintText: "Телефон",
//                   hintStyle: TextStyle(color: Color(0xFF909090), fontSize: 17),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Container(
//               width: 400,
//               child: TextField(
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(
//                     left: 20,
//                     top: 18,
//                     bottom: 18,
//                   ),
//                   hintText: "Пароль",
//                   hintStyle: TextStyle(color: Color(0xFF909090), fontSize: 17),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                 padding: EdgeInsets.only(right: 20),
//                 child: TextButton(
//                   style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                   onPressed: () {
//                     Navigator.pushNamed(context, "/PasRec");
//                   },
//                   child: Text(
//                     "Забыли пароль?",
//                     style: TextStyle(fontSize: 19, color: Color(0xFF414141)),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: 50),
//             Container(
//               width: 400,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, "/phonever");
//                 },
//                 child: Text(
//                   "Войти",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 241, 129, 0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Нет учетной записи? ", style: TextStyle(fontSize: 18)),
//                 TextButton(
//                   style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                   onPressed: () {
//                     Navigator.pushNamed(context, "/SignUp");
//                   },
//                   child: Text(
//                     " Зарегистрироваться",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Color(0xFF34398B),
//                       fontWeight: FontWeight.w600,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class LogIn extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Image.asset("images/Logo-3.png", height: 35),
//         iconTheme: IconThemeData(size: 30),
//       ),
//       body: Rega(),
//     );
//   }
// }

// class Rega extends StatefulWidget {
//   @override
//   _RegaState createState() => _RegaState();
// }

// class _RegaState extends State<Rega> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isLoading = false;

//   void _login() async {
//     final phone = _phoneController.text.trim();
//     final password = _passwordController.text.trim();

//     if (phone.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Пожалуйста, заполните все поля")));
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final query =
//           await FirebaseFirestore.instance
//               .collection('users')
//               .where('phone', isEqualTo: phone)
//               .where('password', isEqualTo: password)
//               .get();

//       if (query.docs.isNotEmpty) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Вход выполнен успешно!")));
//         Navigator.pushNamed(context, "/phonever"); // твой следующий экран
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Неверный телефон или пароль")));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Ошибка при входе: $e")));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Center(
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: EdgeInsets.only(left: 20, top: 100),
//                 child: Text(
//                   "Вход",
//                   style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             SizedBox(height: 40),
//             Container(
//               width: 400,
//               child: TextField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(
//                     left: 20,
//                     top: 18,
//                     bottom: 18,
//                   ),
//                   hintText: "Телефон",
//                   hintStyle: TextStyle(color: Color(0xFF909090), fontSize: 17),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Container(
//               width: 400,
//               child: TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(
//                     left: 20,
//                     top: 18,
//                     bottom: 18,
//                   ),
//                   hintText: "Пароль",
//                   hintStyle: TextStyle(color: Color(0xFF909090), fontSize: 17),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                 padding: EdgeInsets.only(right: 20),
//                 child: TextButton(
//                   style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                   onPressed: () {
//                     Navigator.pushNamed(context, "/PasRec");
//                   },
//                   child: Text(
//                     "Забыли пароль?",
//                     style: TextStyle(fontSize: 19, color: Color(0xFF414141)),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 50),
//             Container(
//               width: 400,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _login,
//                 child:
//                     _isLoading
//                         ? CircularProgressIndicator(color: Colors.white)
//                         : Text(
//                           "Войти",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 241, 129, 0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Нет учетной записи? ", style: TextStyle(fontSize: 18)),
//                 TextButton(
//                   style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                   onPressed: () {
//                     Navigator.pushNamed(context, "/SignUp");
//                   },
//                   child: Text(
//                     " Зарегистрироваться",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Color(0xFF34398B),
//                       fontWeight: FontWeight.w600,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:astra_app_1/profile.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// class LogIn extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Image.asset("images/Logo-3.png", height: 35),
//         iconTheme: IconThemeData(size: 30),
//       ),
//       body: Rega(),
//     );
//   }
// }

// class Rega extends StatefulWidget {
//   @override
//   _RegaState createState() => _RegaState();
// }

// class _RegaState extends State<Rega> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String _responseText = '';

//   void _login() async {
//     var dio = Dio();

//     try {
//       final response = await dio.post(
//         'https://api.store.astra-lombard.kz/api/tokens',
//         data: {
//           "PhoneNumber": _phoneController.text.trim(),
//           "Password": _passwordController.text.trim(),
//         },
//         options: Options(headers: {'Accept': "application/json"}),
//       );
//       final token = response.data['token'];
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => Widget2(token: token)),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Неверный телефон или пароль"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Center(
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: EdgeInsets.only(left: 20, top: 100),
//                 child: Text(
//                   "Вход",
//                   style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             SizedBox(height: 40),
//             Container(
//               width: 400,
//               child: TextField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(
//                     left: 20,
//                     top: 18,
//                     bottom: 18,
//                   ),
//                   hintText: "Телефон",
//                   hintStyle: TextStyle(color: Color(0xFF909090), fontSize: 17),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Container(
//               width: 400,
//               child: TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(
//                     left: 20,
//                     top: 18,
//                     bottom: 18,
//                   ),
//                   hintText: "Пароль",
//                   hintStyle: TextStyle(color: Color(0xFF909090), fontSize: 17),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                 padding: EdgeInsets.only(right: 20),
//                 child: TextButton(
//                   style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                   onPressed: () {
//                     Navigator.pushNamed(context, "/PasRec");
//                   },
//                   child: Text(
//                     "Забыли пароль?",
//                     style: TextStyle(fontSize: 19, color: Color(0xFF414141)),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 50),
//             Container(
//               width: 400,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: _login,
//                 child: Text(
//                   "Войти",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 241, 129, 0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(_responseText),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Нет учетной записи? ", style: TextStyle(fontSize: 18)),
//                 TextButton(
//                   style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                   onPressed: () {
//                     Navigator.pushNamed(context, "/SignUp");
//                   },
//                   child: Text(
//                     " Зарегистрироваться",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Color(0xFF34398B),
//                       fontWeight: FontWeight.w600,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:astra_app_1/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'token_manager.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);

        return MediaQuery(
          data: mediaQueryData.copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      home: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Image.asset("images/Logo-3.png", height: 35),
          iconTheme: IconThemeData(size: 30),
        ),
        body: Rega(),
      ),
    );
  }
}

class Rega extends StatefulWidget {
  const Rega({super.key});

  @override
  _RegaState createState() => _RegaState();
}

class _RegaState extends State<Rega> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    var dio = Dio();

    try {
      final response = await dio.post(
        'https://api.store.astra-lombard.kz/api/tokens',
        data: {
          // "PhoneNumber": _phoneController.text.trim(),
          // "Password": _passwordController.text.trim(),
          "PhoneNumber": '+77759733956',
          "Password": '12345678',
        },
        options: Options(headers: {'Accept': "application/json"}),
      );
      final token = response.data['token'];
      // TokenStorage.token = token;
      await TokenStorage.saveToken(token);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomnNavigation()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Неверный телефон или пароль"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 100),
              child: Text(
                "Вход",
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: 400,
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                    top: 18,
                    bottom: 18,
                  ),
                  hintText: "Телефон",
                  hintStyle: TextStyle(color: Color(0xFF909090), fontSize: 17),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                    top: 18,
                    bottom: 18,
                  ),
                  hintText: "Пароль",
                  hintStyle: TextStyle(color: Color(0xFF909090), fontSize: 17),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    Navigator.pushNamed(context, "/PasRec");
                  },
                  child: Text(
                    "Забыли пароль?",
                    style: TextStyle(fontSize: 19, color: Color(0xFF414141)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              width: 400,
              height: 55,
              child: ElevatedButton(
                onPressed: _login,
                child: Text(
                  "Войти",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 241, 129, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Нет учетной записи? ", style: TextStyle(fontSize: 18)),
                  FittedBox(
                    child: TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () {
                        Navigator.pushNamed(context, "/SignUp");
                      },
                      child: Text(
                        " Зарегистрироваться",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF34398B),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
