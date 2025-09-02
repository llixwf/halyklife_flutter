import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset("images/Logo-3.png", height: 35),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(size: 30),
      ),
      body: Sign(),
    );
  }
}

class Sign extends StatefulWidget {
  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _register() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Пожалуйста, заполните номер телефона и пароль"),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Пароли не совпадают")));
      return;
    }

    try {
      // Сохраняем только номер телефона и пароль в Firestore
      await FirebaseFirestore.instance.collection('users').add({
        'phone': phone,
        'password': password,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Успешно зарегистрированы!")));

      Navigator.pushNamed(context, "/Code");
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ошибка при регистрации: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 45),
              Text(
                "Регистрация",
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),

              // Фамилия
              Container(
                width: 400,
                child: TextField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: 20,
                      top: 18,
                      bottom: 18,
                    ),
                    hintText: "Фамилия",
                    hintStyle: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 17,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Имя
              Container(
                width: 400,
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: 20,
                      top: 18,
                      bottom: 18,
                    ),
                    hintText: "Имя",
                    hintStyle: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 17,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Номер телефона
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
                    hintText: "Номер телефона",
                    hintStyle: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 17,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Пароль
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
                    hintStyle: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 17,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Подтвердить пароль
              Container(
                width: 400,
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: 20,
                      top: 18,
                      bottom: 18,
                    ),
                    hintText: "Подтвердить пароль",
                    hintStyle: TextStyle(
                      color: Color(0xFF909090),
                      fontSize: 17,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Кнопка регистрации
              Container(
                width: 400,
                height: 55,
                child: ElevatedButton(
                  onPressed: _register,
                  child: Text(
                    "Зарегистрироваться",
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

              // Вход
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Уже зарегистрированные?",
                    style: TextStyle(fontSize: 18),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Войти",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF34398B),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              // Политика конфиденциальности
              Center(
                child: Text.rich(
                  TextSpan(
                    text:
                        'Регистрируя аккаунт, вы подтверждаете, что прочитали \n и приняли ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Политику конфиденциальности',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class SignUp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Image.asset("images/Logo-3.png", height: 35),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         iconTheme: IconThemeData(size: 30),
//       ),
//       body: Sign(),
//     );
//   }
// }

// class Sign extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.only(left: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 45),
//             Text(
//               "Регистрация",
//               style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 40),
//             Container(
//               width: 400,
//               child: TextField(
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(
//                     left: 20,
//                     top: 18,
//                     bottom: 18,
//                   ),
//                   hintText: "Фамилия",
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
//                 keyboardType: TextInputType.name,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(
//                     left: 20,
//                     top: 18,
//                     bottom: 18,
//                   ),
//                   hintText: "Имя",
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
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(
//                     left: 20,
//                     top: 18,
//                     bottom: 18,
//                   ),
//                   hintText: "Номер телефона",
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
//                   hintText: "Подтвердить пароль",
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
//             SizedBox(height: 40),
//             Container(
//               width: 400,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, "/next");
//                 },
//                 child: Text(
//                   "Зарегистрироваться",
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
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Уже зарегистрированные?", style: TextStyle(fontSize: 18)),
//                 TextButton(
//                   style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     "Войти",
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
//             Center(
//               child: Text.rich(
//                 TextSpan(
//                   text:
//                       'Регистрируя аккаунт, вы подтверждаете, что прочитали \n и приняли ',
//                   style: TextStyle(
//                     color: Colors.black,
//                   ), // стиль для всего текста
//                   children: [
//                     TextSpan(
//                       text: 'Политику конфиденциальности',
//                       style: TextStyle(
//                         decoration: TextDecoration.underline,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }