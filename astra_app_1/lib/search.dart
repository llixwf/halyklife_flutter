import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'token_manager.dart';
import 'package:intl/intl.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final dio = Dio();
  TextEditingController _input = TextEditingController();
  List<dynamic> searchProducts = [];
  var f = NumberFormat('#,###', 'ru_RU');
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    searchProducts =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    print(searchProducts);
  }

  void showOverlayToast(BuildContext context, Map<String, dynamic> product) {
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 80,
            right: 20,
            left: 20,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Divider(color: Colors.grey, thickness: 1.5),
                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.network(
                            product["imagePath"] ?? '',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product["name"] ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 6),
                            RichText(
                              text: TextSpan(
                                text: "Вес изделия: ",
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Color(0xFF909090),
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "${product["weight"]?.toString() ?? "0"} г",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: "Цена: ",
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Color(0xFF909090),
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "${f.format((product["basePrice"]?.toInt() ?? 0))} ₸",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
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
                  ],
                ),
              ),
            ),
          ),
    );
    overlay.insert(entry);

    Future.delayed(Duration(seconds: 2), () {
      entry.remove();
    });
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
    final input = _input.text.toLowerCase();
    final result =
        searchProducts.where((searched) {
          final name = (searched["name"] ?? "").toString().toLowerCase();
          return name.contains(input);
        }).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Результаты поиска",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(size: 30),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            children: [
              TextField(
                controller: _input,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 30),
                  hintText: "Я хочу найти ...",
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
              Expanded(
                child:
                    input.isEmpty
                        ? Column(
                          children: [
                            SizedBox(height: 250),
                            Image.asset("images/Frame 200-3.png"),
                            SizedBox(height: 12),
                            Text(
                              "Ищем по любому слову \nв названии товара",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                        : GridView.builder(
                          padding: EdgeInsets.only(top: 20),
                          itemCount: result.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.7,
                              ),
                          itemBuilder: (context, adi) {
                            final alreadySerached = result[adi];
                            final String name = alreadySerached["name"] ?? "";
                            final String img =
                                alreadySerached["imagePath"] ?? "";
                            final int price =
                                alreadySerached["priceWithDiscount"]?.toInt() ??
                                "0";
                            final money = f.format(price);
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Color(0xFFEBEBEB),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          "/Details",
                                          arguments: alreadySerached,
                                        );
                                      },
                                      child: Image.network(
                                        img,
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.178,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 13),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$money ₸',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF34398B),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                addToCart(alreadySerached);
                                              },
                                              child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                  Icons.shopping_cart,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  "/Details",
                                                  arguments: alreadySerached,
                                                );
                                              },
                                              child: Container(
                                                width: 37,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                  Icons.arrow_forward,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
