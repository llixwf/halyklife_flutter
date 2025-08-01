import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Filtered extends StatefulWidget {
  final Map<String, dynamic> filters;

  Filtered({required this.filters});

  @override
  _FilteredState createState() => _FilteredState();
}

class _FilteredState extends State<Filtered> {
  List<dynamic> products = [];
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchFilteredProducts();
  }

  Future<void> fetchFilteredProducts() async {
    final url = "https://api.store.astra-lombard.kz/api/v1/products/search";

    try {
      final filters = widget.filters;
      List<Map<String, dynamic>> filterConditions = [];

      if (filters["gender"] != null) {
        filterConditions.add({
          "logic": "or",
          "filters": [
            {
              "field": "metadata.filters",
              "operator": "contains",
              "value": "{Для кого:${filters["gender"][0]}}",
            },
          ],
        });
      }

      if (filters["insert"] != null) {
        filterConditions.add({
          "logic": "or",
          "filters": [
            {
              "field": "metadata.filters",
              "operator": "contains",
              "value": "{Вставка:${filters["insert"]}}",
            },
          ],
        });
      }

      if (filters["goldColor"] != null) {
        filterConditions.add({
          "logic": "or",
          "filters": [
            {
              "field": "metadata.filters",
              "operator": "contains",
              "value": "{Цвет металла:${filters["goldColor"][0]}}",
            },
          ],
        });
      }

      if (filters["size"] != null) {
        filterConditions.add({
          "logic": "or",
          "filters": [
            {
              "field": "metadata.filters",
              "operator": "contains",
              "value": "{Размер браслета:${filters["size"]}}",
            },
          ],
        });
      }

      if (filters["proba"] != null) {
        filterConditions.add({
          "logic": "or",
          "filters": [
            {
              "field": "metadata.filters",
              "operator": "contains",
              "value": "{Проба:${filters["proba"][0]}}",
            },
          ],
        });
      }

      if (filters["minPrice"] != null) {
        filterConditions.add({
          "field": "priceWithDiscount",
          "operator": "gte",
          "value": filters["minPrice"],
        });
      }

      if (filters["maxPrice"] != null) {
        filterConditions.add({
          "field": "priceWithDiscount",
          "operator": "lte",
          "value": filters["maxPrice"],
        });
      }

      final requestData = {
        "pageSize": 1000,
        "pageNumber": 1,
        "advancedFilter": {"logic": "and", "filters": filterConditions},
      };

      final response = await dio.post(
        url,
        data: requestData,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      setState(() {
        products = response.data["data"] ?? [];
      });
    } catch (e) {
      print("Ошибка при получении товаров: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Результаты поиска")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          padding: EdgeInsets.only(top: 10),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            final String name = product["name"] ?? "";
            final String img = product["imagePath"] ?? "";
            final String price =
                product["priceWithDiscount"]?.toString() ?? "0";

            return Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Color(0xFFEBEBEB)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/Details",
                          arguments: product,
                        );
                      },
                      child: Image.network(
                        img,
                        width: double.infinity,
                        height: screenHeight * 0.18,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$price ₸',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF34398B),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/Details",
                              arguments: product,
                            );
                          },
                          child: Container(
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              size: screenWidth * 0.065,
                              color: Colors.white,
                            ),
                          ),
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
    );
  }
}
