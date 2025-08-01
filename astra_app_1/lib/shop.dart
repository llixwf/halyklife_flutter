import 'package:astra_app_1/detail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'token_manager.dart';
import 'package:intl/intl.dart';


class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  TextEditingController _input = TextEditingController();
  List<dynamic> novinka = [];
  final dio = Dio();
  var f = NumberFormat('#,###', 'ru_RU');

  @override
  void initState() {
    super.initState();
    fetchNew();
  }

  Future<void> fetchNew() async {
    final url = "https://api.store.astra-lombard.kz/api/v1/products/search";
    try {
      final responce = await dio.post(
        url,
        data: {"pageSize": 30},
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      final data = responce.data;
      setState(() {
        novinka = data["data"] ?? [];
      });
    } catch (e) {
      print("error:$e");
    }
  }

  void showOverlayToast(BuildContext context, Map<String, dynamic> product) {
    final overlay = Overlay.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final priceSnak = product["basePrice"]?.toInt() ?? 0;
    final money = f.format(priceSnak);

    final entry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: screenHeight * 0.1,
            right: screenWidth * 0.05,
            left: screenWidth * 0.05,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Товар успешно добавлен в корзину",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    Divider(color: Colors.grey, thickness: 1.5),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                          child: Image.network(
                            product["imagePath"] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product["name"] ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.0393,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Text(
                              "Вес изделия: ${product["weight"]?.toString() ?? "0"} г",
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Цена: $money ₸",
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
    overlay.insert(entry);
    Future.delayed(Duration(seconds: 2), () => entry.remove());
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    final url = 'https://api.store.astra-lombard.kz/api/v1/cart';
    try {
      final response = await dio.post(
        url,
        data: {"productId": product["id"], "quantity": 1},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${TokenStorage.token}',
          },
        ),
      );
      if (response.statusCode == 200) {
        showOverlayToast(context, product);
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500 || e.response?.statusCode == 405) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Этот товар уже есть в корзине')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при добавлении в корзину')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final input = _input.text.toLowerCase();
    final result =
        novinka
            .where((p) => (p["name"] ?? '').toLowerCase().contains(input))
            .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.025),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              TextField(
                controller: _input,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: screenWidth * 0.07),
                  hintText: "Поиск...",
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
              SizedBox(height: screenHeight * 0.025),
              input.isEmpty
                  ? Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Прейти в Астра-ломбард",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.045,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff34398B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Image.asset(
                        "images/Frame 120.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      _text("Новинки", screenWidth),
                      SizedBox(height: screenHeight * 0.015),
                      buildCarouselSlider(novinka, context),
                      SizedBox(height: screenHeight * 0.02),
                      _text("Популярные товары", screenWidth),
                      SizedBox(height: screenHeight * 0.015),
                      buildCarouselSlider(novinka, context),
                      SizedBox(height: screenHeight * 0.015),
                    ],
                  )
                  : Container(
                    height: screenHeight * 0.75,
                    child: GridView.builder(
                      padding: EdgeInsets.only(top: screenHeight * 0.02),
                      itemCount: result.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: screenHeight * 0.015,
                        crossAxisSpacing: screenWidth * 0.025,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final item = result[index];
                        final name = item["name"] ?? "";
                        final image = item["imagePath"] ?? "";
                        final price = item["priceWithDiscount"]?.toInt() ?? "0";
                        final money = f.format(price);
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFEBEBEB),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Detail(item),
                                      ),
                                    ),
                                child: Image.network(
                                  image,
                                  width: double.infinity,
                                  height: screenHeight * 0.18,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Text(
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$money ₸',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.043,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF34398B),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _iconButton(
                                        Icons.shopping_cart,
                                        () => addToCart(item),
                                        screenWidth * 0.9,
                                      ),
                                      SizedBox(width: screenWidth * 0.01),
                                      _iconButton(
                                        Icons.arrow_forward,
                                        () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Detail(item),
                                          ),
                                        ),
                                        screenWidth * 0.9,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildCarouselSlider(List<dynamic> items, BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  var f = NumberFormat('#,###', 'ru_RU');
  return CarouselSlider(
    options: CarouselOptions(
      autoPlay: true,
      viewportFraction: 0.52,
      height: screenHeight * 0.365,
    ),
    items:
        items.map((item) {
          final img = item["imagePath"] ?? "";
          final name = item["name"] ?? "";
          final price = item["priceWithDiscount"]?.toInt() ?? "0";
          final money = f.format(price);
          return Builder(
            builder:
                (context) => Container(
                  margin: EdgeInsets.only(left: screenWidth * 0.025),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Color(0xFFEBEBEB)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(screenWidth * 0.025),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detail(item),
                            ),
                          );
                        },
                        // onTap:
                        //     () => Navigator.pushNamed(
                        //       context,
                        //       "/Details",
                        //       arguments: item,
                        //     ),
                        child: Image.network(
                          img,
                          width: double.infinity,
                          height: screenHeight * 0.17,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$money ₸',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF34398B),
                            ),
                          ),
                          _iconButton(
                            Icons.arrow_forward,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(item),
                              ),
                            ),
                            screenWidth,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          );
        }).toList(),
  );
}

Widget _text(String title, double screenWidth) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.06,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "Все",
        style: TextStyle(color: Colors.orange, fontSize: screenWidth * 0.045),
      ),
    ],
  );
}

Widget _iconButton(IconData icon, VoidCallback onTap, double screenWidth) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: screenWidth * 0.09,
      height: screenWidth * 0.09,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: screenWidth * 0.06, color: Colors.white),
    ),
  );
}



// // import 'package:dio/dio.dart';
// // import 'package:flutter/material.dart';

// // class ShopPage extends StatefulWidget {
// //   @override
// //   _ShopPageState createState() => _ShopPageState();
// // }

// // class _ShopPageState extends State<ShopPage> {
// //   List<dynamic> news = [];
// //   final dio = Dio();
// //   @override
// // void initState() {
// //   super.initState();
// //   fetchNew();
// // }
// //   Future<void> fetchNew() async {
// //     final url = "https://api.store.astra-lombard.kz/api/v1/products/search";
// //     try {
// //       final responce = await dio.post(
// //         url,
// //         data: {"pageSize": 30},
// //         options: Options(headers: {"Content-Type": "application/json"}),
// //       );
// //       final data = responce.data;
// //       setState(() {
// //         news = data["data"] ?? [];
// //       });
// //     } catch (e) {
// //       print("error:$e");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Padding(
// //         padding: EdgeInsets.all(10),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             children: [
// //               SizedBox(height: 40),
// //               TextField(
// //                 decoration: InputDecoration(
// //                   prefixIcon: Icon(Icons.search, size: 30),
// //                   hintText: "Поиск...",
// //                   enabledBorder: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                   focusedBorder: OutlineInputBorder(
// //                     borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //               Container(
// //                 width: double.infinity,
// //                 height: 50,
// //                 child: ElevatedButton(
// //                   onPressed: () {},
// //                   child: Text(
// //                     "Прейти в Астра-ломбард",
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.w500,
// //                       fontSize: 18,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Color(0xff34398B),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Image.asset("images/Frame 120.png", width: double.infinity),
// //                final String img = news["imagePath"] ?? "";
// //                   final String name = news["name"] ?? "";
// //                   final String price =
// //                       news['priceWithDiscount']?.toString() ?? '0';
// //               SizedBox(height: 10),
// //               _text("Новинки"),
// //               Container(
// //                 decoration: BoxDecoration(
// //                   border: Border.all(width: 2, color: Color(0xFFEBEBEB)),
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //                 child: Padding(
// //                   padding: EdgeInsets.all(10),
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.start,
// //                     children: [
// //                       GestureDetector(
// //                         onTap: () {
// //                           Navigator.pushNamed(context, "/Details");
// //                         },
// //                         child: Stack(
// //                           children: [
// //                             Image.network(
// //                               img,
// //                               width: 200,
// //                               height: 150,
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       SizedBox(height: 13),
// //                       Text(
// //                         name,
// //                         style: TextStyle(
// //                           fontSize: 15,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                       Spacer(),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Text(
// //                             '$price ₸',
// //                             style: TextStyle(
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.bold,
// //                               color: Color(0xFF34398B),
// //                             ),
// //                           ),
// //                           Row(
// //                             children: [
// //                               GestureDetector(
// //                                 onTap: () {},
// //                                 child: Container(
// //                                   width: 37,
// //                                   height: 37,
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.orange,
// //                                     borderRadius: BorderRadius.circular(10),
// //                                   ),
// //                                   child: Icon(
// //                                     Icons.shopping_cart,
// //                                     size: 20,
// //                                     color: Colors.white,
// //                                   ),
// //                                 ),
// //                               ),
// //                               SizedBox(width: 10),
// //                               GestureDetector(
// //                                 onTap: () {
// //                                   Navigator.pushNamed(context, "/Details");
// //                                 },
// //                                 child: Container(
// //                                   width: 37,
// //                                   height: 37,
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.orange,
// //                                     borderRadius: BorderRadius.circular(10),
// //                                   ),
// //                                   child: Icon(
// //                                     Icons.arrow_forward,
// //                                     size: 30,
// //                                     color: Colors.white,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               _text("Популярные товары"),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // Widget _text(String title) {
// //   return Row(
// //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //     crossAxisAlignment: CrossAxisAlignment.center,
// //     children: [
// //       Text(title, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
// //       Text("Все", style: TextStyle(color: Colors.orange)),
// //     ],
// //   );
// // }
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'token_manager.dart';

// class ShopPage extends StatefulWidget {
//   @override
//   _ShopPageState createState() => _ShopPageState();
// }

// class _ShopPageState extends State<ShopPage> {
//   TextEditingController _input = TextEditingController();
//   List<dynamic> novinka = [];
//   final dio = Dio();

//   @override
//   void initState() {
//     super.initState();
//     fetchNew();
//   }

//   Future<void> fetchNew() async {
//     final url = "https://api.store.astra-lombard.kz/api/v1/products/search";
//     try {
//       final responce = await dio.post(
//         url,
//         data: {"pageSize": 30},
//         options: Options(headers: {"Content-Type": "application/json"}),
//       );
//       final data = responce.data;
//       setState(() {
//         novinka = data["data"] ?? [];
//       });
//     } catch (e) {
//       print("error:$e");
//     }
//   }

//   void showOverlayToast(BuildContext context, Map<String, dynamic> product) {
//     final overlay = Overlay.of(context);

//     final entry = OverlayEntry(
//       builder:
//           (context) => Positioned(
//             top: 80,
//             right: 20,
//             left: 20,
//             child: Material(
//               color: Colors.transparent,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Товар успешно добавлен в корзину",
//                       style: TextStyle(color: Colors.black, fontSize: 16),
//                     ),
//                     Divider(color: Colors.grey, thickness: 1.5),
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: 50,
//                           height: 50,
//                           child: Image.network(
//                             product["imagePath"] ?? '',
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         SizedBox(width: 15),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               product["name"] ?? '',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             SizedBox(height: 6),
//                             RichText(
//                               text: TextSpan(
//                                 text: "Вес изделия: ",
//                                 style: const TextStyle(
//                                   fontSize: 17,
//                                   color: Color(0xFF909090),
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text:
//                                         "${product["weight"]?.toString() ?? "0"} г",
//                                     style: const TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.w400,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             RichText(
//                               text: TextSpan(
//                                 text: "Цена: ",
//                                 style: const TextStyle(
//                                   fontSize: 17,
//                                   color: Color(0xFF909090),
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text:
//                                         "${product["basePrice"]?.toString() ?? "0"} ₸",
//                                     style: const TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.w400,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//     );
//     overlay.insert(entry);

//     Future.delayed(Duration(seconds: 2), () {
//       entry.remove();
//     });
//   }

//   Future<void> addToCart(Map<String, dynamic> product) async {
//     final url = 'https://api.store.astra-lombard.kz/api/v1/cart';

//     try {
//       final response = await dio.post(
//         url,
//         data: {"productId": product["id"], "quantity": 1},
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer ${TokenStorage.token}',
//           },
//         ),
//       );
//       if (response.statusCode == 200) {
//         showOverlayToast(context, product);
//       }
//     } catch (e) {
//       if (e is DioException) {
//         if (e.response?.statusCode == 500 || e.response?.statusCode == 405) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Этот товар уже есть в корзине')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Ошибка при добавлении в корзину')),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final input = _input.text.toLowerCase();
//     final result =
//         novinka.where((searched) {
//           final names = (searched["name"] ?? "").toString().toLowerCase();
//           return names.contains(input);
//         }).toList();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 40),
//               TextField(
//                 controller: _input,
//                 onChanged: (_) => setState(() {}),
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search, size: 30),
//                   hintText: "Поиск...",
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
//               SizedBox(height: 20),
//               input.isEmpty
//                   ? Column(
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           child: Text(
//                             "Прейти в Астра-ломбард",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 18,
//                               color: Colors.white,
//                             ),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xff34398B),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       SizedBox(
//                         child: Image.asset(
//                           "images/Frame 120.png",
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       _text("Новинки"),
//                       SizedBox(height: 12),
//                       buildCarouselSlider(novinka, context),

//                       SizedBox(height: 20),
//                       _text("Популярные товары"),
//                       SizedBox(height: 12),
//                       buildCarouselSlider(novinka, context),
//                       SizedBox(height: 15),
//                     ],
//                   )
//                   : Container(
//                     height: MediaQuery.of(context).size.height * 0.75,
//                     child: GridView.builder(
//                       padding: EdgeInsets.only(top: 20),
//                       itemCount: result.length,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 10,
//                         crossAxisSpacing: 10,
//                         childAspectRatio: 0.7,
//                       ),
//                       itemBuilder: (context, adi) {
//                         final searched = result[adi];
//                         final String aty = searched["name"] ?? "";
//                         final String suret = searched["imagePath"] ?? "";
//                         final String baga =
//                             searched["priceWithDiscount"]?.toString() ?? "0";

//                         return Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               width: 2,
//                               color: Color(0xFFEBEBEB),
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.all(10),
//                             child: Column(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     Navigator.pushNamed(
//                                       context,
//                                       "/Details",
//                                       arguments: searched,
//                                     );
//                                   },
//                                   child: Image.network(
//                                     suret,
//                                     width: double.infinity,
//                                     height:
//                                         MediaQuery.of(context).size.height *
//                                         0.178,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 SizedBox(height: 13),
//                                 Text(
//                                   aty,
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 Spacer(),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       '$baga ₸',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF34398B),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () {
//                                             addToCart(searched);
//                                           },
//                                           child: Container(
//                                             width: 37,
//                                             height: 37,
//                                             decoration: BoxDecoration(
//                                               color: Colors.orange,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             child: Icon(
//                                               Icons.shopping_cart,
//                                               size: 20,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         GestureDetector(
//                                           onTap: () {
//                                             Navigator.pushNamed(
//                                               context,
//                                               "/Details",
//                                               arguments: searched,
//                                             );
//                                           },
//                                           child: Container(
//                                             width: 37,
//                                             height: 37,
//                                             decoration: BoxDecoration(
//                                               color: Colors.orange,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             child: Icon(
//                                               Icons.arrow_forward,
//                                               size: 30,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(width: 10),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget buildCarouselSlider(List<dynamic> items, BuildContext context) {
//   return CarouselSlider(
//     options: CarouselOptions(
//       autoPlay: true,
//       viewportFraction: 0.52,
//       height: MediaQuery.of(context).size.height * 0.33,
//     ),
//     items:
//         items.map((item) {
//           final String img = item["imagePath"] ?? "";
//           final String name = item["name"] ?? "";
//           final String price = item["priceWithDiscount"]?.toString() ?? "0";

//           return Builder(
//             builder: (context) {
//               return Container(
//                 margin: EdgeInsets.only(left: 10),
//                 decoration: BoxDecoration(
//                   border: Border.all(width: 2, color: Color(0xFFEBEBEB)),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushNamed(
//                             context,
//                             "/Details",
//                             arguments: item,
//                           );
//                         },
//                         child: Stack(
//                           children: [
//                             Image.network(
//                               img,
//                               width: double.infinity,
//                               height: MediaQuery.of(context).size.height * 0.17,
//                               fit: BoxFit.cover,
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 13),
//                       Text(
//                         name,
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '$price ₸',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF34398B),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 "/Details",
//                                 arguments: item,
//                               );
//                             },
//                             child: Container(
//                               width: 37,
//                               height: 37,
//                               decoration: BoxDecoration(
//                                 color: Colors.orange,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Icon(
//                                 Icons.arrow_forward,
//                                 size: 30,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }).toList(),
//   );
// }

// Widget _text(String title) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Text(title, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
//       Text("Все", style: TextStyle(color: Colors.orange)),
//     ],
//   );
// }