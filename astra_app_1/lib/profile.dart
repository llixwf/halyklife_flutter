import 'package:astra_app_1/dostup.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'token_manager.dart';

class Widget1 extends StatefulWidget {
  @override
  State<Widget1> createState() => _Widget1state();
}

class _Widget1state extends State<Widget1> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            isSwitched = value;
          });
        },
        activeColor: Colors.white,
        activeTrackColor: Color(0xFFFF8A00),
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Color(0xFFE0E0E0),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "Профиль",
          style: TextStyle(
            fontSize: width * 0.068,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width * 0.04),
            child: IconButton(
              onPressed: () {
                TokenStorage.clearToken();
                Navigator.pushReplacementNamed(context, "/LogIn");
              },
              icon: Icon(Icons.logout, size: width * 0.068),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.02),
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
            SizedBox(height: height * 0.036),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.033),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        size: height * 0.036,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Мои данные",
                        style: TextStyle(
                          fontSize: height * 0.020,
                          color: Color(0xFF909090),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Бонусы – 120,000 ₸",
                            style: TextStyle(
                              fontSize: height * 0.019,
                              color: Color(0xFFFF8A00),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: width * 0.015),
                          Icon(Icons.arrow_forward_ios, size: height * 0.0298),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Datas()),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.018),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.local_shipping_outlined,
                        size: height * 0.043,
                      ),
                      title: Text(
                        "Доставка и оплата",
                        style: TextStyle(
                          fontSize: height * 0.020,
                          color: Color(0xFF909090),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: height * 0.0298,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.018),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.article_outlined,
                        size: height * 0.043,
                      ),
                      title: Text(
                        "Быстрый код доступа", // "Пользовательское соглашение",
                        style: TextStyle(
                          fontSize: height * 0.01948,
                          color: Color(0xFF909090),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: height * 0.0298,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dostup()),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.018),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.verified_outlined,
                        size: height * 0.043,
                      ),
                      title: Text(
                        "Гарантия качества",
                        style: TextStyle(
                          fontSize: height * 0.0198,
                          color: Color(0xFF909090),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: height * 0.0298,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.018),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.description_outlined,
                        size: height * 0.043,
                      ),
                      title: Text(
                        "Публичная оферта",
                        style: TextStyle(
                          fontSize: height * 0.0198,
                          color: Color(0xFF909090),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: height * 0.0298,
                      ),
                      onTap: () {
                        final controller =
                            WebViewController()
                              ..setJavaScriptMode(JavaScriptMode.unrestricted)
                              ..setNavigationDelegate(
                                NavigationDelegate(
                                  onPageFinished: (url) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                ),
                              )
                              ..addJavaScriptChannel(
                                'goToBack',
                                onMessageReceived: (JavaScriptMessage message) {
                                  print(message.message);
                                  Navigator.of(context).pop();
                                },
                              )
                              ..loadRequest(
                                Uri.parse(
                                  'https://astra-market-hzmg.vercel.app/oferta?mobile=true',
                                ),
                              );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder:
                        //         (context) => Scaffold(
                        //           body: SafeArea(
                        //             child: WebViewWidget(
                        //               controller: controller,
                        //             ),
                        //           ),
                        //         ),
                        //   ),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => Scaffold(
                                  body: SafeArea(
                                    child: Stack(
                                      children: [
                                        WebViewWidget(controller: controller),
                                        if (_isLoading)
                                          Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFFFF8A00),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: height * 0.018),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.language, size: height * 0.043),
                      title: Text(
                        "Язык",
                        style: TextStyle(
                          fontSize: height * 0.0198,
                          color: Color(0xFF909090),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: height * 0.0298,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.024),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Вход по Face ID",
                        style: TextStyle(
                          fontSize: height * 0.023,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Widget1(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Вход по отпечатку пальца",
                        style: TextStyle(
                          fontSize: height * 0.023,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Widget1(),
                    ],
                  ),
                  SizedBox(height: height * 0.024),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF264796), Color(0xFF34398B)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.035),
                        Text(
                          "Гарячая линия",
                          style: TextStyle(
                            fontSize: height * 0.035,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "8 800 070 05 40",
                          style: TextStyle(
                            fontSize: height * 0.035,
                            color: Color(0xFFFF8A00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * 0.014),
                        Text(
                          "Понедельник - Пятница с 09:00 - 20:00",
                          style: TextStyle(
                            fontSize: height * 0.020,
                            color: Color(0xFF9CA5F1),
                          ),
                        ),
                        Text(
                          "Суббота с 10:00 - 19:00",
                          style: TextStyle(
                            fontSize: height * 0.020,
                            color: Color(0xFF9CA5F1),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Мы в соцсетях",
                          style: TextStyle(
                            fontSize: height * 0.035,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * 0.018),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("images/image_copy3.png"),
                            SizedBox(width: width * 0.018),
                            Image.asset(
                              "images/image_copy.png",
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(width: width * 0.018),
                            Image.asset(
                              "images/image_copy_2.png",
                              width: 40,
                              height: 40,
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.035),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.045),
                ],
              ),
            ),

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
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// class MainPage extends StatelessWidget {
//   const MainPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AutoTabsScaffold(
//       routes: const [
//         ShopRoute(),
//         Profile(),
//         LikeRoute(),
//         CartRoute(),
//         CatalogRoute(),
//       ],
//       bottomNavigationBuilder: (context, tabsRouter) {
//         return BottomNavigationBar(
//           currentIndex: tabsRouter.activeIndex,
//           onTap: tabsRouter.setActiveIndex,
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
//             BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.favorite),
//               label: 'Избранное',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart),
//               label: 'Корзина',
//             ),
//             BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Каталог'),
//           ],
//         );
//       },
//     );
//   }
// }
