// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'token_manager.dart';
// // import 'package:shimmer_animation/shimmer_animation.dart';

// class Product extends StatefulWidget {
//   @override
//   _ProductState createState() => _ProductState();
// }

// class _ProductState extends State<Product> {
//   bool isFavourite = false;
//   bool isLoading = true;
//   List<dynamic> products = [];
//   final dio = Dio();
//   String categoryName = "";
//   String categoryId = "";
//   int _currentIndex = 1;

//   //for argument
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     categoryName = args["categoryName"] ?? "-";
//     categoryId = args["categoryId"] ?? "";
//     fetchProducts();
//   }

//   //for fetching product
//   Future<void> fetchProducts() async {
//     final url = 'https://api.store.astra-lombard.kz/api/v1/products/search';
//     try {
//       final response = await dio.post(
//         url,
//         data: {"pageSize": 100, "categoryId": categoryId},
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );
//       final data = response.data;
//       print(data);
//       setState(() {
//         products = data["data"] ?? [];
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Ошибка: $e');
//     }
//   }

//   //toaster
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
//                                 fontSize: 18,
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

//   //for adding prouducts to cart
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

//   //for save it in favourites
//   Set<String> favouriteIds = {};
//   Future<void> addToFavourite(Map<String, dynamic> product) async {
//     final url = 'https://api.store.astra-lombard.kz/api/v1/favourites';

//     try {
//       final response = await dio.post(
//         url,
//         data: {"productId": product["id"]},
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer ${TokenStorage.token}',
//           },
//         ),
//       );
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print('Success');
//       } else {
//         print('Something went wrong: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   Widget build(BuildContext context) {
//     final filteredProducts =
//         products.where((product) {
//           final category = product["category"]?["name"] ?? "";
//           return category == categoryName;
//         }).toList();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           categoryName.isNotEmpty ? categoryName : "-",
//           style: TextStyle(fontWeight: FontWeight.w500),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search, size: 35),
//             onPressed: () {
//               Navigator.pushNamed(
//                 context,
//                 "/Search",
//                 arguments: filteredProducts,
//               );
//             },
//           ),
//         ],
//         centerTitle: true,
//         iconTheme: IconThemeData(size: 30),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.sort, size: 25),
//                       SizedBox(width: 4),
//                       Text(
//                         "По популярности",
//                         style: TextStyle(fontSize: 18, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.filter_alt_outlined, size: 25),
//                       SizedBox(width: 4),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, "/Filter");
//                         },
//                         child: Text(
//                           "Фильтр",
//                           style: TextStyle(fontSize: 18, color: Colors.black),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 15),
//               // isLoading
//               //     ? GridView.builder(
//               //       shrinkWrap: true,
//               //       physics: NeverScrollableScrollPhysics(),
//               //       itemCount: 6,
//               //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               //         crossAxisCount: 2,
//               //         mainAxisSpacing: 10,
//               //         crossAxisSpacing: 10,
//               //         childAspectRatio: 0.7,
//               //       ),
//               //       itemBuilder: (context, index) {
//               //         return Shimmer(
//               //           duration: Duration(seconds: 2),
//               //           interval: Duration(seconds: 5),
//               //           color: Colors.white,
//               //           colorOpacity: 0.3,
//               //           enabled: true,
//               //           child: Container(
//               //             decoration: BoxDecoration(
//               //               border: Border.all(
//               //                 width: 2,
//               //                 color: Color(0xFFEBEBEB),
//               //               ),
//               //               borderRadius: BorderRadius.circular(10),
//               //             ),
//               //             child: Padding(
//               //               padding: EdgeInsets.all(10),
//               //               child: Column(
//               //                 children: [
//               //                   Container(
//               //                     height: 120,
//               //                     decoration: BoxDecoration(
//               //                       color: Color(0xFFF5F5F5),
//               //                       borderRadius: BorderRadius.circular(10),
//               //                     ),
//               //                   ),
//               //                   SizedBox(height: 10),
//               //                   Spacer(),
//               //                   Row(
//               //                     mainAxisAlignment:
//               //                         MainAxisAlignment.spaceBetween,
//               //                     children: [
//               //                       Container(
//               //                         width: 50,
//               //                         height: 20,
//               //                         color: Color(0xFFF5F5F5),
//               //                       ),
//               //                       Row(
//               //                         children: [
//               //                           Container(
//               //                             width: 37,
//               //                             height: 37,
//               //                             decoration: BoxDecoration(
//               //                               color: Color(0xFFF5F5F5),
//               //                               borderRadius: BorderRadius.circular(
//               //                                 10,
//               //                               ),
//               //                             ),
//               //                           ),
//               //                           SizedBox(width: 10),
//               //                           Container(
//               //                             width: 37,
//               //                             height: 37,
//               //                             decoration: BoxDecoration(
//               //                               color: Color(0xFFF5F5F5),
//               //                               borderRadius: BorderRadius.circular(
//               //                                 10,
//               //                               ),
//               //                             ),
//               //                           ),
//               //                         ],
//               //                       ),
//               //                     ],
//               //                   ),
//               //                 ],
//               //               ),
//               //             ),
//               //           ),
//               //         );
//               //       },
//               //     )
//               //     :
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 10,
//                   crossAxisSpacing: 10,
//                   childAspectRatio: 0.7,
//                 ),
//                 itemCount: filteredProducts.length,
//                 itemBuilder: (context, index) {
//                   final product = filteredProducts[index];
//                   final isFavourite = favouriteIds.contains(product["id"]);
//                   final String img = product["imagePath"] ?? "";
//                   final String name = product["name"] ?? "";
//                   final String price =
//                       product['priceWithDiscount']?.toString() ?? '0';
//                   return Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(width: 2, color: Color(0xFFEBEBEB)),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pushNamed(
//                                 context,
//                                 "/Details",
//                                 arguments: product,
//                               );
//                             },
//                             child: Stack(
//                               children: [
//                                 Image.network(
//                                   img,
//                                   width: double.infinity,
//                                   height:
//                                       MediaQuery.of(context).size.height *
//                                       0.178,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 Positioned(
//                                   top: -13,
//                                   right: -10,
//                                   child: IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         if (isFavourite) {
//                                           favouriteIds.remove(product["id"]);
//                                         } else {
//                                           favouriteIds.add(product["id"]);
//                                           addToFavourite(product);
//                                         }
//                                       });
//                                     },
//                                     icon: Icon(
//                                       isFavourite
//                                           ? Icons.favorite
//                                           : Icons.favorite_border,
//                                       size: 26,
//                                       color:
//                                           isFavourite
//                                               ? Colors.orange
//                                               : Colors.orange,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 13),
//                           Text(
//                             name,
//                             style: TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Spacer(),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 '$price ₸',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF34398B),
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       addToCart(product);
//                                     },
//                                     child: Container(
//                                       width: 37,
//                                       height: 37,
//                                       decoration: BoxDecoration(
//                                         color: Colors.orange,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Icon(
//                                         Icons.shopping_cart,
//                                         size: 20,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.pushNamed(
//                                         context,
//                                         "/Details",
//                                         arguments: product,
//                                       );
//                                     },
//                                     child: Container(
//                                       width: 37,
//                                       height: 37,
//                                       decoration: BoxDecoration(
//                                         color: Colors.orange,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Icon(
//                                         Icons.arrow_forward,
//                                         size: 30,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         onTap: (index) {
//           switch (index) {
//             case 0:
//               Navigator.pushNamed(context, '/Shop');
//               break;
//             case 1:
//               Navigator.pushNamed(context, '/Catalog');
//               break;
//             case 2:
//               Navigator.pushNamed(context, '/Cart');
//               break;
//             case 3:
//               Navigator.pushNamed(context, '/Liked');
//               break;
//             case 4:
//               Navigator.pop(context);
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

import 'package:astra_app_1/detail.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'token_manager.dart';
import 'package:intl/intl.dart';

class Product extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const Product({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  bool isFavourite = false;
  bool isLoading = true;
  List<dynamic> products = [];
  final dio = Dio();
  // String categoryName = "";
  // String categoryId = "";
  final int _currentIndex = 1;
  Set<String> favouriteIds = {};
  var f = NumberFormat('#,###', 'ru_RU');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // categoryName = args["categoryName"] ?? "-";
    // categoryId = args["categoryId"] ?? "";
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = 'https://api.store.astra-lombard.kz/api/v1/products/search';
    try {
      final response = await dio.post(
        url,
        data: {"pageSize": 100, "categoryId": widget.categoryId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final data = response.data;
      setState(() {
        products = data["data"] ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  void showOverlayToast(BuildContext context, Map<String, dynamic> product) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final overlay = Overlay.of(context);

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
                  horizontal: 16,
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
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["name"] ?? '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Text(
                                "Вес изделия: ${product["weight"] ?? "0"} г",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Цена: ${f.format((product["basePrice"] ?? 0).toInt())} ₸",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
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

  Future<void> addToFavourite(Map<String, dynamic> product) async {
    final url = 'https://api.store.astra-lombard.kz/api/v1/favourites';
    try {
      final response = await dio.post(
        url,
        data: {"productId": product["id"]},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${TokenStorage.token}',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Success');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final filteredProducts =
        products
            .where(
              (product) => product["category"]?["name"] == widget.categoryName,
            )
            .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.categoryName.isNotEmpty ? widget.categoryName : "-",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: screenWidth * 0.05,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: screenWidth * 0.08),
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/Search",
                arguments: filteredProducts,
              );
            },
          ),
        ],
        centerTitle: true,
        iconTheme: IconThemeData(size: screenWidth * 0.075),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.sort, size: screenWidth * 0.06),
                    SizedBox(width: screenWidth * 0.01),
                    Text(
                      "По популярности",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.filter_alt_outlined, size: screenWidth * 0.06),

                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, "/Filter"),
                      child: Text(
                        "Фильтр",
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.015),
            Expanded(
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: screenHeight * 0.012,
                  crossAxisSpacing: screenWidth * 0.025,
                  childAspectRatio: 0.64,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final isFav = favouriteIds.contains(product["id"]);
                  final img = product["imagePath"] ?? "";
                  final name = product["name"] ?? "";
                  final price = product['priceWithDiscount']?.toInt() ?? '0';
                  final money = f.format(price);

                  return Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Color(0xFFEBEBEB),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Detail(product),
                                  ),
                                );
                              },
                              // onTap:
                              //     () => Navigator.pushNamed(
                              //       context,
                              //       "/Details",
                              //       arguments: product,
                              //     ),
                              child: Image.network(
                                img,
                                width: double.infinity,
                                height: screenHeight * 0.178,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '$money ₸',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF34398B),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => addToCart(product),
                                  child: Container(
                                    width: screenWidth * 0.08,
                                    height: screenWidth * 0.08,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.shopping_cart,
                                      size: screenWidth * 0.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Detail(product),
                                      ),
                                    );
                                  },
                                  // onTap:
                                  //     () => Navigator.pushNamed(
                                  //       context,
                                  //       "/Details",
                                  //       arguments: product,
                                  //     ),
                                  child: Container(
                                    width: screenWidth * 0.08,
                                    height: screenWidth * 0.08,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: screenWidth * 0.07,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (isFav) {
                                favouriteIds.remove(product["id"]);
                              } else {
                                favouriteIds.add(product["id"]);
                                addToFavourite(product);
                              }
                            });
                          },
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: screenWidth * 0.069,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
              Navigator.pushNamed(context, '/Cart');
              break;
            case 3:
              Navigator.pushNamed(context, '/Liked');
              break;
            case 4:
              Navigator.pop(context);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store, size: screenWidth * 0.069),
            label: 'Магазин',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt, size: screenWidth * 0.069),
            label: 'Каталог',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: screenWidth * 0.069),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: screenWidth * 0.069),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: screenWidth * 0.069),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
