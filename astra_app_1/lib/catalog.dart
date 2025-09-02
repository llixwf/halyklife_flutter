import 'package:astra_app_1/product.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Catalog extends StatefulWidget {
  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  List<dynamic> categories = [];
  final dio = Dio();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final url = 'https://api.store.astra-lombard.kz/api/v1/categories/search';

    try {
      final response = await dio.post(
        url,
        data: {"pageSize": 100, "categoryId": ""},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = response.data;
      setState(() {
        categories = data["data"] ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "Каталог",
          style: TextStyle(
            fontSize: media.width * 0.075,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: CatalogPage(categories: categories, isLoading: isLoading),
    );
  }
}

class CatalogPage extends StatelessWidget {
  final List<dynamic> categories;
  final bool isLoading;
  CatalogPage({required this.categories, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final w = media.width;
    final h = media.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: h * 0.02),
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
          SizedBox(height: h * 0.04),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.035),
            child: Column(
              children: [
                isLoading
                    ? Shimmer(
                      duration: Duration(seconds: 2),
                      interval: Duration(seconds: 5),
                      color: Colors.white,
                      colorOpacity: 0.3,
                      enabled: true,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 9,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: h * 0.015,
                          crossAxisSpacing: w * 0.025,
                          crossAxisCount: 2,
                          childAspectRatio: 2,
                        ),
                        itemBuilder: (context, index) {
                          return Card(
                            color: Color(0xFFE0E0E0),
                            child: Padding(
                              padding: EdgeInsets.all(w * 0.025),
                              child: Container(
                                width: double.infinity,
                                height: h * 0.03,
                                child: Row(
                                  children: [
                                    Container(
                                      width: w * 0.175,
                                      height: w * 0.175,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    SizedBox(width: w * 0.03),
                                    Container(
                                      width: w * 0.15,
                                      height: h * 0.018,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                    : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          categories.length > 1 ? categories.length - 1 : 0,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: h * 0.015,
                        crossAxisSpacing: w * 0.025,
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => Product(
                                      categoryName: category["name"],
                                      categoryId: category["id"],
                                    ),
                              ),
                            );
                            // Navigator.pushNamed(
                            //   context,
                            //   "/Product",
                            //   arguments: {
                            //     "categoryName": category["name"],
                            //     "categoryId": category["id"],
                            //   },
                            // );
                          },
                          child: Card(
                            color: Color(0xFFF8F8F8),
                            child: Padding(
                              padding: EdgeInsets.all(w * 0.025),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                        category["imagePath"] != null
                                            ? Image.network(
                                              category["imagePath"],
                                              width: w * 0.165,
                                              height: w * 0.185,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) => Icon(
                                                    Icons.broken_image,
                                                    size: w * 0.16,
                                                  ),
                                            )
                                            : Icon(Icons.image, size: w * 0.16),
                                  ),
                                  SizedBox(width: w * 0.03),
                                  Flexible(
                                    child: Text(
                                      category["name"] ?? "",
                                      style: TextStyle(fontSize: w * 0.038),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                SizedBox(height: h * 0.02),
                if (categories.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/Product",
                        arguments: {
                          "categoryName": categories.last["name"],
                          "categoryId": categories.last["id"],
                        },
                      );
                    },
                    child: Container(
                      height: h * 0.11,
                      padding: EdgeInsets.all(w * 0.025),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFFF8F8F8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              categories.last["imagePath"] ?? "",
                              width: w * 0.175,
                              height: w * 0.175,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Icon(Icons.broken_image),
                            ),
                          ),
                          SizedBox(width: w * 0.03),
                          Flexible(
                            child: Text(
                              categories.last["name"] ?? "",
                              style: TextStyle(fontSize: w * 0.038),
                            ),
                          ),
                        ],
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


// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';

// class Catalog extends StatefulWidget {
//   @override
//   _CatalogState createState() => _CatalogState();
// }

// class _CatalogState extends State<Catalog> {
//   List<dynamic> categories = [];
//   final dio = Dio();
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }

//   Future<void> fetchCategories() async {
//     final url = 'https://api.store.astra-lombard.kz/api/v1/categories/search';

//     try {
//       final response = await dio.post(
//         url,
//         data: {"pageSize": 100, "categoryId": ""},
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );

//       final data = response.data;
//       setState(() {
//         categories = data["data"] ?? [];
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Ошибка: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: Text(
//           "Каталог",
//           style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
//         ),
//       ),
//       body: CatalogPage(categories: categories, isLoading: isLoading),
//     );
//   }
// }

// class CatalogPage extends StatelessWidget {
//   final List<dynamic> categories;
//   final bool isLoading;
//   CatalogPage({required this.categories, required this.isLoading});

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
//           SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 14),
//             child: Column(
//               children: [
//                 isLoading
//                     ? Shimmer(
//                       duration: Duration(seconds: 2),
//                       interval: Duration(seconds: 5),
//                       color: Colors.white,
//                       colorOpacity: 0.3,
//                       enabled: true,
//                       child: GridView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: 9,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           mainAxisSpacing: 12,
//                           crossAxisSpacing: 10,
//                           crossAxisCount: 2,
//                           childAspectRatio: 2,
//                         ),
//                         itemBuilder: (context, index) {
//                           return Card(
//                             color: Color(0xFFE0E0E0),
//                             child: Padding(
//                               padding: EdgeInsets.all(10),
//                               child: Container(
//                                 width: double.infinity,
//                                 height: 20,
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 70,
//                                       height: 70,
//                                       decoration: BoxDecoration(
//                                         color: Color(0xFFF5F5F5),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                     SizedBox(width: 12),
//                                     Container(
//                                       width: 60,
//                                       height: 15,
//                                       decoration: BoxDecoration(
//                                         color: Color(0xFFF5F5F5),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     )
//                     // Shimmer(
//                     //   duration: Duration(seconds: 3), //Default value
//                     //   interval: Duration(
//                     //     seconds: 5,
//                     //   ), //Default value: Duration(seconds: 0)
//                     //   color: Colors.white, //Default value
//                     //   colorOpacity: 0, //Default value
//                     //   enabled: true, //Default value
//                     //   direction: ShimmerDirection.fromLTRB(), //Default Value
//                     //   child:
//                     : GridView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount:
//                           categories.length > 1 ? categories.length - 1 : 0,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         mainAxisSpacing: 12,
//                         crossAxisSpacing: 10,
//                         crossAxisCount: 2,
//                         childAspectRatio: 2,
//                       ),
//                       itemBuilder: (context, index) {
//                         final category = categories[index];

//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.pushNamed(
//                               context,
//                               "/Product",
//                               arguments: {
//                                 "categoryName": category["name"],
//                                 "categoryId": category["id"],
//                               },
//                             );
//                           },
//                           child: Card(
//                             color: Color(0xFFF8F8F8),
//                             child: Padding(
//                               padding: EdgeInsets.all(10),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(10),
//                                     child:
//                                         category["imagePath"] != null
//                                             ? Image.network(
//                                               category["imagePath"],
//                                               width: 70,
//                                               height: 70,
//                                               fit: BoxFit.cover,
//                                               errorBuilder:
//                                                   (_, __, ___) => Icon(
//                                                     Icons.broken_image,
//                                                     size: 65,
//                                                   ),
//                                             )
//                                             : Icon(Icons.image, size: 65),
//                                   ),
//                                   SizedBox(width: 12),
//                                   Flexible(
//                                     child: Text(
//                                       category["name"] ?? "",
//                                       style: TextStyle(fontSize: 16),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                 SizedBox(height: 20),
//                 if (categories.isNotEmpty)
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(
//                         context,
//                         "/Product",
//                         arguments: {
//                           "categoryName": categories.last["name"],
//                           "categoryId": categories.last["id"],
//                         },
//                       );
//                     },
//                     child: Container(
//                       height: 90,
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Color(0xFFF8F8F8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 4,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.network(
//                               categories.last["imagePath"] ?? "",
//                               width: 70,
//                               height: 70,
//                               fit: BoxFit.cover,
//                               errorBuilder:
//                                   (_, __, ___) => Icon(Icons.broken_image),
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           Flexible(
//                             child: Text(
//                               categories.last["name"] ?? "",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }