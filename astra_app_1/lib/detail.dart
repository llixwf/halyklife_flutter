import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'token_manager.dart';
import 'package:intl/intl.dart';

class Detail extends StatefulWidget {
  final Map<String, dynamic> product;
  const Detail(this.product, {super.key});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool isFavourite = false;
  late final Map<String, dynamic> product;
  final dio = Dio();
  var f = NumberFormat('#,###', 'ru_RU');

  @override
  void initState() {
    super.initState();
    product = widget.product;
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Товар успешно добавлен в корзину')),
        );
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
      } else {
        print('Something went wrong: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget buildImageSlider(List<dynamic> images) {
    if (images.length == 1) {
      return Image.network(
        images[0],
        height: 330,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      height: 330,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.network(images[index], fit: BoxFit.cover);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(size: 30),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),

            child: IconButton(
              onPressed: () {
                setState(() {
                  isFavourite = !isFavourite;
                  addToFavourite(product);
                });
              },
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
                size: 30,
                color: isFavourite ? Colors.orange : Colors.orange,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              product["images"] != null && product["images"]
                  ? buildImageSlider(product["images"])
                  : Image.network(
                    product["imagePath"] ?? "",
                    height: 330,
                    width: double.infinity,
                  ),

              SizedBox(height: 20),
              Text(
                product["name"] ?? "",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "Код товара: ",
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF909090),
                  ),
                  children: [
                    TextSpan(
                      text: "${product["article"] ?? ""}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "Вес изделия: ",
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF909090),
                  ),
                  children: [
                    TextSpan(
                      text: "${product["weight"] ?? ""} г",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text("Описание", style: TextStyle(fontSize: 16)),
                      trailing: Icon(Icons.keyboard_arrow_down),
                      tilePadding: EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            product["description"] ?? "-",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(
                        "Характеристики",
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_down),
                      tilePadding: EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            product[""] ?? "-",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    addToCart(product);
                  },
                  child: Text(
                    "В корзину - ${f.format((product["basePrice"] ?? 0).toInt())}₸",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
