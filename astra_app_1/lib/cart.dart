import 'package:astra_app_1/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  static var page;
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<dynamic> carts = [];
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchCarts();
  }

  Future<void> fetchCarts() async {
    final url = "https://api.store.astra-lombard.kz/api/v1/cart";

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${TokenStorage.token}',
          },
        ),
      );
      final data = response.data;
      setState(() {
        carts = data["items"] ?? [];
      });
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  void removeItem(int index) async {
    final productId = carts[index]["product"]["id"];
    final url = "https://api.store.astra-lombard.kz/api/v1/cart/$productId";

    try {
      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${TokenStorage.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          carts.removeAt(index);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Товар удалён из корзины')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка при удалении товара')));
    }
  }

  void removeAll() async {
    final url = "https://api.store.astra-lombard.kz/api/v1/cart/clear";
    try {
      await dio.delete(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${TokenStorage.token}',
          },
        ),
      );
      setState(() {
        carts.clear();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Корзина очищена')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка при очистке корзины')));
    }
  }

  int totalSum() {
    int total = 0;
    for (var adi in carts) {
      total += (adi["product"]["basePrice"] as num).toInt();
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CartPage(
        carts: carts,
        onDelete: removeItem,
        removeAll: removeAll,
        totalSum: totalSum,
      ),
    );
  }
}

var f = NumberFormat('#,###', 'ru_RU');

class CartPage extends StatelessWidget {
  final List<dynamic> carts;
  final Function(int) onDelete;
  final Function() removeAll;
  final int Function() totalSum;

  CartPage({
    required this.carts,
    required this.onDelete,
    required this.removeAll,
    required this.totalSum,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return carts.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/Frame 200.png"),
              SizedBox(height: size.height * 0.02),
              Text(
                "Ваша корзина пуста",
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "Желаете приобрести ювелирные изделия?\nПосмотрите наши хиты продаж, загляните\nв товары со скидкой",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  color: Color(0xFF909090),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                width: size.width * 0.9,
                height: size.height * 0.07,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.orange),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/Catalog");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Вернуться к покупкам",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        : SafeArea(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.03),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  itemCount: carts.length,
                  itemBuilder: (context, index) {
                    final item = carts[index];
                    final img = item["product"]["imagePath"] ?? "";
                    final name = item["product"]["name"] ?? "";
                    final weight = item["product"]["weight"]?.toString() ?? "0";
                    final price = item["product"]["basePrice"]?.toInt() ?? "0";
                    final money = f.format(price);
                    return Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.015),
                      child: Container(
                        height: size.height * 0.133,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFF8F8F8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.025,
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  img,
                                  width: size.width * 0.18,
                                  height: size.height * 0.10,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: size.width * 0.040,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    RichText(
                                      text: TextSpan(
                                        text: "Вес изделия: ",
                                        style: TextStyle(
                                          fontSize: size.width * 0.042,
                                          color: Color(0xFF909090),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "$weight г",
                                            style: TextStyle(
                                              fontSize: size.width * 0.042,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF34398B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Text(
                                      "$money ₸",
                                      style: TextStyle(
                                        fontSize: size.width * 0.042,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap:
                                    () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: Text(
                                            "Вы уверены,что хотите \n удалить этот товар из \n корзины?",
                                            style: TextStyle(
                                              fontSize: size.width * 0.05,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            Container(
                                              width: size.width * 0.28,
                                              height: size.height * 0.05,
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Отмена",
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.045,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: size.width * 0.28,
                                              height: size.height * 0.05,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 2,
                                                  color: Colors.orange,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  onDelete(index);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Удалить",
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.042,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                child: Container(
                                  height: size.width * 0.1,
                                  width: size.width * 0.1,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outlined,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.015,
                ),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(size.width * 0.035),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Товаров ${carts.length}",
                                style: TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: size.width * 0.045,
                                ),
                              ),
                              Text(
                                "${totalSum()} ₸",
                                style: TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: size.width * 0.045,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          const Divider(thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ИТОГО",
                                style: TextStyle(
                                  fontSize: size.width * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${totalSum()} ₸",
                                style: TextStyle(
                                  fontSize: size.width * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.07,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Оформить заказ",
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }
}


// import 'package:astra_app_1/token_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// class Cart extends StatefulWidget {
//   @override
//   _CartState createState() => _CartState();
// }

// class _CartState extends State<Cart> {
//   List<dynamic> carts = [];
//   final dio = Dio();

//   @override
//   void initState() {
//     super.initState();
//     fetchCarts();
//   }

//   // void removeItem(int index) {
//   //   setState(() {
//   //     carts.removeAt(index);
//   //   });
//   // }

//   // void removeAll() {
//   //   setState(() {
//   //     carts.clear();
//   //   });
//   // }

//   Future<void> fetchCarts() async {
//     final url = "https://api.store.astra-lombard.kz/api/v1/cart";

//     try {
//       final response = await dio.get(
//         url,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer ${TokenStorage.token}',
//           },
//         ),
//       );
//       final data = response.data;
//       print(data);
//       setState(() {
//         carts = data["items"] ?? [];
//         print('hello:  $carts');
//       });
//     } catch (e) {
//       print('Ошибка: $e');
//     }
//   }

//   void removeItem(int index) async {
//     final productId = carts[index]["product"]["id"];
//     final url = "https://api.store.astra-lombard.kz/api/v1/cart/$productId";

//     try {
//       final response = await dio.delete(
//         url,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer ${TokenStorage.token}',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           carts.removeAt(index);
//         });
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Товар удалён из корзины')));
//       }
//     } catch (e) {
//       print("Ошибка при удалении товара: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Ошибка при удалении товара')));
//     }
//   }

//   void removeAll() async {
//     final url = "https://api.store.astra-lombard.kz/api/v1/cart/clear";
//     try {
//       await dio.delete(
//         url,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer ${TokenStorage.token}',
//           },
//         ),
//       );
//       setState(() {
//         carts.clear();
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Корзина очищена')));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Ошибка при очистке корзины')));
//     }
//   }

//   //total
//   int totalSum() {
//     int total = 0;
//     for (var adi in carts) {
//       total += (adi["product"]["basePrice"] as num).toInt();
//     }
//     return total;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CartPage(
//         carts: carts,
//         onDelete: removeItem,
//         removeAll: removeAll,
//         totalSum: totalSum,
//       ),
//     );
//   }
// }

// class CartPage extends StatelessWidget {
//   final List<dynamic> carts;
//   final Function(int) onDelete;
//   final Function() removeAll;
//   final int Function() totalSum;
//   CartPage({
//     required this.carts,
//     required this.onDelete,
//     required this.removeAll,
//     required this.totalSum,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return carts.isEmpty
//         ? Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset("images/Frame 200.png"),
//               SizedBox(height: 15),
//               Text(
//                 "Ваша корзина пуста",
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 15),
//               Text(
//                 "Желаете приобрести ювелирные изделия?\nПосмотрите наши хиты продаж, загляните\nв товары со скидкой",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 18, color: Color(0xFF909090)),
//               ),
//               SizedBox(height: 25),
//               Container(
//                 width: 400,
//                 height: 55,
//                 decoration: BoxDecoration(
//                   border: Border.all(width: 2, color: Colors.orange),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, "/Catalog");
//                   },
//                   child: Text(
//                     "Вернуться к покупкам",
//                     style: TextStyle(
//                       color: Colors.orange,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )
//         : SafeArea(
//           child: Column(
//             children: [
//               // Padding(
//               //   padding: const EdgeInsets.symmetric(
//               //     horizontal: 15,
//               //     vertical: 10,
//               //   ),
//               //   child: Row(
//               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //     children: [
//               //       const Text(
//               //         "Товары в корзине",
//               //         style: TextStyle(
//               //           fontSize: 30,
//               //           fontWeight: FontWeight.bold,
//               //         ),
//               //       ),
//               //       TextButton(
//               //         onPressed: removeAll,
//               //         child: const Text(
//               //           "ОЧИСТИТЬ",
//               //           style: TextStyle(
//               //             fontSize: 16,
//               //             color: Color(0xFFFF473C),
//               //           ),
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               SizedBox(height: 30),
//               Expanded(
//                 child: ListView.builder(
//                   padding: EdgeInsets.symmetric(horizontal: 15),
//                   itemCount: carts.length,
//                   itemBuilder: (context, index) {
//                     final item = carts[index];
//                     final img = item["product"]["imagePath"] ?? "";
//                     final name = item["product"]["name"] ?? "";
//                     final weight = item["product"]["weight"]?.toString() ?? "0";
//                     final price =
//                         item["product"]["basePrice"]?.toString() ?? "0";

//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 15),
//                       child: Container(
//                         height: 110,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: const Color(0xFFF8F8F8),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.network(
//                                   img,
//                                   width: 80,
//                                   height: 80,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       name,
//                                       style: const TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 1),
//                                     RichText(
//                                       text: TextSpan(
//                                         text: "Вес изделия: ",
//                                         style: const TextStyle(
//                                           fontSize: 17,
//                                           color: Color(0xFF909090),
//                                         ),
//                                         children: [
//                                           TextSpan(
//                                             text: "$weight г",
//                                             style: const TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w400,
//                                               color: Color(0xFF34398B),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 1),
//                                     Text(
//                                       "$price ₸",
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap:
//                                     () => showDialog(
//                                       context: context,
//                                       builder: (context) {
//                                         return AlertDialog(
//                                           backgroundColor: Colors.white,
//                                           title: Text(
//                                             "Вы уверены,что хотите \n удалить этот товар из \n корзины?",
//                                             style: TextStyle(
//                                               fontSize: 23,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                           actions: [
//                                             Container(
//                                               width: 120,
//                                               child: TextButton(
//                                                 onPressed: () {
//                                                   Navigator.of(context).pop();
//                                                 },
//                                                 child: Text(
//                                                   "Отмена",
//                                                   style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.w500,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.orange,
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                               ),
//                                             ),
//                                             Container(
//                                               width: 120,
//                                               child: TextButton(
//                                                 onPressed: () {
//                                                   onDelete(index);
//                                                   Navigator.of(context).pop();
//                                                 },
//                                                 child: Text(
//                                                   "Удалить",
//                                                   style: TextStyle(
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.w500,
//                                                     color: Colors.orange,
//                                                   ),
//                                                 ),
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                   width: 2,
//                                                   color: Colors.orange,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     ),
//                                 child: Container(
//                                   height: 40,
//                                   width: 40,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: const Icon(
//                                     Icons.delete_outlined,
//                                     color: Colors.red,
//                                     size: 25,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 15,
//                   vertical: 10,
//                 ),
//                 color: Colors.white,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF8F8F8),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.all(12),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Товаров ${carts.length}",
//                                 style: const TextStyle(
//                                   color: Color(0xFF909090),
//                                   fontSize: 17,
//                                 ),
//                               ),
//                               Text(
//                                 "${totalSum()} ₸",
//                                 style: TextStyle(
//                                   color: Color(0xFF909090),
//                                   fontSize: 17,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           const Divider(thickness: 1),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "ИТОГО",
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 "${totalSum()} ₸",
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 55,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.orange,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         onPressed: () {},
//                         child: const Text(
//                           "Оформить заказ",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//   }
// }