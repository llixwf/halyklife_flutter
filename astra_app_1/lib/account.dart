import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'token_manager.dart';

class UserInp extends StatefulWidget {
  @override
  _UserInpState createState() => _UserInpState();
}

class _UserInpState extends State<UserInp> {
  final int _currentIndex = 4;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _fetchProfile() async {
    var dio = Dio();
    try {
      final response = await dio.get(
        'https://api.store.astra-lombard.kz/api/personal/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${TokenStorage.token}',
            'Accept': 'application/json',
          },
        ),
      );
      setState(() {
        _profileData = response.data;
      });
      print("Profile info show: ${response.data}");
    } catch (e) {
      print("Ошибка при получении профиля: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Аккаунт",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
        ),
        iconTheme: IconThemeData(size: 30),
      ),
      body: Account(profileData: _profileData),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/Shop');
              break;
            case 1:
              Navigator.pushNamed(context, '/Catalog');
              break;
            case 2:
              Navigator.pushNamed(context, "/Cart");
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Cart()),
              // );
              break;
            case 3:
              Navigator.pushNamed(context, '/Liked');
              break;
            case 4:
              Navigator.pushNamed(context, '/Profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store, size: 30),
            label: 'Магазин',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt, size: 30),
            label: 'Каталог',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 30),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: 30),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

class Account extends StatelessWidget {
  final Map<String, dynamic>? profileData;
  Account({required this.profileData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: Color.fromARGB(9, 0, 0, 0),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 35),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                // name
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Имя",
                          style: TextStyle(
                            color: Color(0xFF909090),
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          profileData?["firstName"] ?? "-",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // phone
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Номер телефона",
                          style: TextStyle(
                            color: Color(0xFF909090),
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          profileData?["phoneNumber"] ?? "-",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                //familia
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Фамилия",
                          style: TextStyle(
                            color: Color(0xFF909090),
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          profileData?["lastName"] ?? "-",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // password
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Пароль",
                          style: TextStyle(
                            color: Color(0xFF909090),
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "************",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    trailing: Image.asset("images/Edit.png"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 300),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: Color.fromARGB(9, 0, 0, 0),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class UserInp extends StatefulWidget {
//   @override
//   _UserInpState createState() => _UserInpState();
// }

// class _UserInpState extends State<UserInp> {
//   int _currentIndex = 4;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           "Аккаунт",
//           style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
//         ),
//         centerTitle: true,
//         iconTheme: IconThemeData(size: 30),
//       ),
//       body: Account(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         //index eto peremennaya u can write instead of index your name!
//         onTap: (index) {
//           switch (index) {
//             case 0:
//               Navigator.pushNamed(context, '/shop');
//               break;
//             case 1:
//               Navigator.pushNamed(context, '/catalog');
//               break;
//             case 2:
//               Navigator.pushNamed(context, '/cart');
//               break;
//             case 3:
//               Navigator.pushNamed(context, '/liked');
//               break;
//             case 4:
//               Navigator.pushNamed(context, '/profile');
//               break;
//           }
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.store, size: 30),
//             label: 'Магазин',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list_alt, size: 30),
//             label: 'Каталог',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart, size: 30),
//             label: 'Корзина',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite_border, size: 30),
//             label: 'Избранное',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person, size: 30),
//             label: 'Профиль',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Account extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           SizedBox(height: 20),
//           Container(
//             height: 2,
//             decoration: BoxDecoration(
//               color: Color.fromARGB(9, 0, 0, 0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x1A000000),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 35),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 14),
//             child: Column(
//               children: [
//                 Container(
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Имя",
//                           style: TextStyle(
//                             color: Color(0xFF909090),
//                             fontSize: 15,
//                           ),
//                         ),
//                         Text(
//                           "Виталий",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Container(
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Номер телефона",
//                           style: TextStyle(
//                             color: Color(0xFF909090),
//                             fontSize: 15,
//                           ),
//                         ),
//                         Text(
//                           "+7 (495) 123-12-12",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Container(
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Фамилия",
//                           style: TextStyle(
//                             color: Color(0xFF909090),
//                             fontSize: 15,
//                           ),
//                         ),
//                         Text(
//                           "Ким",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Container(
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Пароль",
//                           style: TextStyle(
//                             color: Color(0xFF909090),
//                             fontSize: 15,
//                           ),
//                         ),
//                         Text(
//                           "************",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     trailing: Image.asset("images/Edit.png"),
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 300),
//           Container(
//             height: 2,
//             decoration: BoxDecoration(
//               color: Color.fromARGB(9, 0, 0, 0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x1A000000),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// class UserInp extends StatefulWidget {
//   final String token;
//   UserInp({required this.token});

//   @override
//   _UserInpState createState() => _UserInpState();
// }

// class _UserInpState extends State<UserInp> {
//   int _currentIndex = 4;
//   String _profileInfo = 'Загрузка...';

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfile();
//   }

//   void _fetchProfile() async {
//     var dio = Dio();

//     try {
//       final response = await dio.get(
//         'https://api.store.astra-lombard.kz/api/personal/profile',
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer ${widget.token}',
//             'Accept': 'application/json',
//           },
//         ),
//       );

//       setState(() {
//         _profileInfo = response.data.toString();
//       });
//       print("✅ Profile info: ${response.data}");
//     } catch (e) {
//       setState(() {
//         _profileInfo = 'Ошибка при получении профиля: $e';
//       });
//       print(" Ошибка при получении профиля: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           "Аккаунт",
//           style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
//         ),
//         centerTitle: true,
//         iconTheme: IconThemeData(size: 30),
//       ),
//       body: Account(profileInfo: _profileInfo),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         onTap: (index) {
//           switch (index) {
//             case 0:
//               Navigator.pushNamed(context, '/shop');
//               break;
//             case 1:
//               Navigator.pushNamed(context, '/catalog');
//               break;
//             case 2:
//               Navigator.pushNamed(context, '/cart');
//               break;
//             case 3:
//               Navigator.pushNamed(context, '/liked');
//               break;
//             case 4:
//               Navigator.pushNamed(context, '/profile');
//               break;
//           }
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.store, size: 30),
//             label: 'Магазин',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list_alt, size: 30),
//             label: 'Каталог',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart, size: 30),
//             label: 'Корзина',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite_border, size: 30),
//             label: 'Избранное',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person, size: 30),
//             label: 'Профиль',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Account extends StatelessWidget {
//   final String profileInfo;
//   Account({required this.profileInfo});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           SizedBox(height: 20),
//           Container(
//             height: 2,
//             decoration: BoxDecoration(
//               color: Color.fromARGB(9, 0, 0, 0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x1A000000),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 35),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 14),
//             child: Column(
//               children: [
//                 Container(
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Имя",
//                           style: TextStyle(
//                             color: Color(0xFF909090),
//                             fontSize: 15,
//                           ),
//                         ),
//                         Text(
//                           "Виталий",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Container(
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Номер телефона",
//                           style: TextStyle(
//                             color: Color(0xFF909090),
//                             fontSize: 15,
//                           ),
//                         ),
//                         Text(
//                           "+7 (495) 123-12-12",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Container(
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Фамилия",
//                           style: TextStyle(
//                             color: Color(0xFF909090),
//                             fontSize: 15,
//                           ),
//                         ),
//                         Text(
//                           "Ким",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 Container(
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Пароль",
//                           style: TextStyle(
//                             color: Color(0xFF909090),
//                             fontSize: 15,
//                           ),
//                         ),
//                         Text(
//                           "************",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     trailing: Image.asset("images/Edit.png"),
//                   ),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFFEBEBEB), width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 300),
//           Container(
//             height: 2,
//             decoration: BoxDecoration(
//               color: Color.fromARGB(9, 0, 0, 0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x1A000000),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
