// import 'package:astra_app_1/catalog.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'token_manager.dart';

// class Like extends StatefulWidget {
//   @override
//   _LikeState createState() => _LikeState();
// }

// class _LikeState extends State<Like> {
//   List<dynamic> favourites = [];
//   final dio = Dio();
//   @override
//   void initState() {
//     super.initState();
//     fetchFavourites();
//   }

//   Future<void> fetchFavourites() async {
//     final url = "https://api.store.astra-lombard.kz/api/v1/favourites/search";
//     try {
//       final response = await dio.post(
//         url,
//         data: {"pageSize": 1000},
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer ${TokenStorage.token}',
//           },
//         ),
//       );
//       final data = response.data;
//       print('TOKEN: ${TokenStorage.token}');
//       setState(() {
//         favourites = data["data"] ?? [];
//       });
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   void removeFavourite(int index) async {
//     final productId = favourites[index]["product"]["id"];
//     final url =
//         "https://api.store.astra-lombard.kz/api/v1/favourites/$productId";

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
//           favourites.removeAt(index);
//         });
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Удалено из избранного')));
//       }
//     } catch (e) {
//       print("Ошибка при удалении из избранного: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Ошибка при удалении')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Избранное", style: TextStyle(fontWeight: FontWeight.w500)),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => Catalog()),
//             );
//           },
//           icon: Icon(Icons.arrow_back, size: 30),
//         ),
//       ),
//       body:
//           favourites.isEmpty
//               ? Center(
//                 child: Text(
//                   "Список избранного пуст",
//                   style: TextStyle(fontSize: 18),
//                 ),
//               )
//               : ListView.builder(
//                 padding: EdgeInsets.all(10),
//                 itemCount: favourites.length,
//                 itemBuilder: (context, index) {
//                   final productFav = favourites[index]["product"];
//                   print(productFav);
//                   final String img = productFav["imagePath"] ?? "";
//                   final String name = productFav["name"] ?? "";
//                   final String price =
//                       productFav["basePrice"]?.toString() ?? "0";
//                   final String weight = productFav["weight"]?.toString() ?? "0";

//                   return Container(
//                     margin: EdgeInsets.only(bottom: 12),
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       // border: Border.all(color: Color(0xFFEBEBEB), width: 2),
//                       color: Color(0xFFF8F8F8),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Row(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.network(
//                             img,
//                             width: 80,
//                             height: 80,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 name,
//                                 style: TextStyle(
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               SizedBox(height: 1),
//                               RichText(
//                                 text: TextSpan(
//                                   text: "Вес изделия: ",
//                                   style: const TextStyle(
//                                     fontSize: 17,
//                                     color: Color(0xFF909090),
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: "$weight г",
//                                       style: const TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.w400,
//                                         color: Color(0xFF34398B),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: 2),
//                               Text(
//                                 "$price ₸",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap:
//                               () => showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return AlertDialog(
//                                     backgroundColor: Colors.white,
//                                     title: Text(
//                                       "Вы уверены,что хотите \n удалить этот товар из \n избранного?",
//                                       style: TextStyle(
//                                         fontSize: 23,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     actions: [
//                                       Container(
//                                         width: 120,
//                                         child: TextButton(
//                                           onPressed: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Text(
//                                             "Отмена",
//                                             style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: Colors.orange,
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         width: 120,
//                                         child: TextButton(
//                                           onPressed: () {
//                                             removeFavourite(index);
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Text(
//                                             "Удалить",
//                                             style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.orange,
//                                             ),
//                                           ),
//                                         ),
//                                         decoration: BoxDecoration(
//                                           border: Border.all(
//                                             width: 2,
//                                             color: Colors.orange,
//                                           ),
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               ),
//                           child: Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Icon(
//                               Icons.delete_outlined,
//                               color: Colors.red,
//                               size: 25,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }

import 'package:astra_app_1/catalog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'token_manager.dart';
import 'package:intl/intl.dart';


class Like extends StatefulWidget {
  @override
  _LikeState createState() => _LikeState();
}

class _LikeState extends State<Like> {
  List<dynamic> favourites = [];
  final dio = Dio();
  var f = NumberFormat('#,###', 'ru_RU');

  @override
  void initState() {
    super.initState();
    fetchFavourites();
  }

  Future<void> fetchFavourites() async {
    final url = "https://api.store.astra-lombard.kz/api/v1/favourites/search";
    try {
      final response = await dio.post(
        url,
        data: {"pageSize": 1000},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${TokenStorage.token}',
          },
        ),
      );
      final data = response.data;
      print('TOKEN: ${TokenStorage.token}');
      setState(() {
        favourites = data["data"] ?? [];
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void removeFavourite(int index) async {
    final productId = favourites[index]["product"]["id"];
    final url =
        "https://api.store.astra-lombard.kz/api/v1/favourites/$productId";

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
          favourites.removeAt(index);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Удалено из избранного')));
      }
    } catch (e) {
      print("Ошибка при удалении из избранного: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка при удалении')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Избранное",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: screenWidth * 0.045,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Catalog()),
            );
          },
          icon: Icon(Icons.arrow_back, size: screenWidth * 0.07),
        ),
      ),
      body:
          favourites.isEmpty
              ? Center(
                child: Text(
                  "Список избранного пуст",
                  style: TextStyle(fontSize: screenWidth * 0.045),
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(screenWidth * 0.025),
                itemCount: favourites.length,
                itemBuilder: (context, index) {
                  final productFav = favourites[index]["product"];
                  final String img = productFav["imagePath"] ?? "";
                  final String name = productFav["name"] ?? "";
                  final int price = productFav["basePrice"]?.toInt() ?? "0";
                  final money = f.format(price);
                  final String weight = productFav["weight"]?.toString() ?? "0";

                  return Container(
                    margin: EdgeInsets.only(bottom: screenWidth * 0.03),
                    padding: EdgeInsets.all(screenWidth * 0.019),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.025,
                          ),
                          child: Image.network(
                            img,
                            width: screenWidth * 0.2,
                            height: screenWidth * 0.2,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.004),
                              RichText(
                                text: TextSpan(
                                  text: "Вес изделия: ",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.043,
                                    color: Color(0xFF909090),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "$weight г",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.043,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF34398B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.004),
                              Text(
                                "$money ₸",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
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
                                      "Вы уверены,что хотите \n удалить этот товар из \n избранного?",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      Container(
                                        width: screenWidth * 0.3,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.circular(
                                            screenWidth * 0.025,
                                          ),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Отмена",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.045,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: screenWidth * 0.3,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.orange,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            screenWidth * 0.025,
                                          ),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            removeFavourite(index);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Удалить",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.045,
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
                            height: screenWidth * 0.1,
                            width: screenWidth * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.025,
                              ),
                            ),
                            child: Icon(
                              Icons.delete_outlined,
                              color: Colors.red,
                              size: screenWidth * 0.065,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
