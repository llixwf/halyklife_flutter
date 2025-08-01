import 'package:astra_app_1/filtered.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final dio = Dio();
  List<dynamic> filters = [];

  List<String> gender = [];
  int selectedGender = -1;
  List<String> goldColor = [];
  int selectedColor = -1;

  RangeValues price = RangeValues(41400, 351900);
  final List<String> sizes = [];
  String? selected;
  String? selected2;
  final List<String> inserts = [];
  final List<String> proba = ["750", "585"];
  int selectedProba = -1;

  @override
  void initState() {
    super.initState();
    fetchFilter();
  }

  Future<void> fetchFilter() async {
    final url =
        "https://api.store.astra-lombard.kz/api/v1/productfilters/search";
    try {
      final response = await dio.post(
        url,
        data: {"pageSize": 1000},
        options: Options(headers: {"Content-Type": 'application/json'}),
      );
      final data = response.data;
      print(data);
      List<String> extractedGender = [];
      List<String> extractedColor = [];
      List<String> extractedSizes = [];
      List<String> extractedInserts = [];
      for (var filter in data["data"]) {
        if (filter["name"] == "Для кого") {
          extractedGender = List<String>.from(
            filter["options"].map((adele) => adele["value"] ?? ""),
          );
        } else if (filter["name"] == "Цвет металла") {
          extractedColor = List<String>.from(
            filter["options"].map((adele) => adele["value"] ?? ""),
          );
        } else if (filter["name"] == "Размер") {
          extractedSizes = List<String>.from(
            filter["options"].map((adele) => adele["value"] ?? ""),
          );
        } else if (filter["name"] == "Вставка") {
          extractedInserts = List<String>.from(
            filter["options"].map((adele) => adele["value"] ?? ""),
          );
        }
      }

      setState(() {
        filters = data["data"] ?? [];
        gender = extractedGender;
        goldColor = extractedColor;
        sizes.addAll(extractedSizes);
        inserts.addAll(extractedInserts);
      });
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Фильтр",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(size: screenWidth * 0.075),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _titleText("Цена", screenWidth),
              SizedBox(height: screenHeight * 0.018),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TextField(context, price.start, "От"),
                  _TextField(context, price.end, "До"),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(
                  valueIndicatorColor: Colors.orange,
                  overlayColor: Colors.orange,
                  thumbColor: Colors.white,
                  trackHeight: screenHeight * 0.007,
                ),
                child: RangeSlider(
                  labels: RangeLabels(
                    price.start.toString(),
                    price.end.toString(),
                  ),
                  activeColor: Colors.orange,
                  inactiveColor: Color.fromARGB(255, 228, 228, 228),
                  min: 41400,
                  max: 351900,
                  values: price,
                  onChanged: (adi) {
                    setState(() {
                      price = adi;
                    });
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              _titleText("Проба", screenWidth),
              SizedBox(height: screenHeight * 0.018),
              Wrap(
                spacing: screenWidth * 0.045,
                children: List.generate(proba.length, (i) {
                  final bool selected = selectedProba == i;
                  return ChoiceChip(
                    label: Text(
                      proba[i],
                      style: TextStyle(
                        color: selected ? Colors.orange : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    labelPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.15,
                      vertical: screenHeight * 0.007,
                    ),
                    selected: selected,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => selectedProba = i),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.white,
                    side: BorderSide(
                      color: selected ? Colors.orange : Color(0xFFEBEBEB),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  );
                }),
              ),
              SizedBox(height: screenHeight * 0.025),
              _titleText("Для кого", screenWidth),
              SizedBox(height: screenHeight * 0.018),
              Wrap(
                spacing: screenWidth * 0.025,
                runSpacing: screenHeight * 0.01,
                children: List.generate(gender.length, (i) {
                  final bool selected = selectedGender == i;
                  return ChoiceChip(
                    label: Text(
                      gender[i],
                      style: TextStyle(
                        color: selected ? Colors.orange : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    labelPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.015,
                      vertical: screenHeight * 0.007,
                    ),
                    selected: selected,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => selectedGender = i),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.white,
                    side: BorderSide(
                      color: selected ? Colors.orange : Color(0xFFEBEBEB),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  );
                }),
              ),
              SizedBox(height: screenHeight * 0.025),
              _titleText("Размер", screenWidth),
              SizedBox(height: screenHeight * 0.018),
              DropdownMenu<String>(
                width: screenWidth * 0.9,
                hintText: "Выберите размер",
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
                  ),
                ),
                onSelected: (value) => setState(() => selected = value!),
                dropdownMenuEntries:
                    sizes
                        .map(
                          (lang) => DropdownMenuEntry(value: lang, label: lang),
                        )
                        .toList(),
              ),
              SizedBox(height: screenHeight * 0.025),
              _titleText("Вставка", screenWidth),
              SizedBox(height: screenHeight * 0.018),
              DropdownMenu<String>(
                width: screenWidth * 0.9,
                hintText: "Выберите вставку",
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
                  ),
                ),
                onSelected: (value) => setState(() => selected2 = value!),
                dropdownMenuEntries:
                    inserts
                        .map(
                          (lang) => DropdownMenuEntry(value: lang, label: lang),
                        )
                        .toList(),
              ),
              SizedBox(height: screenHeight * 0.025),
              _titleText("Цвет золота", screenWidth),
              SizedBox(height: screenHeight * 0.018),
              Wrap(
                spacing: screenWidth * 0.025,
                runSpacing: screenHeight * 0.015,
                children: List.generate(goldColor.length, (i) {
                  final bool selected = selectedColor == i;
                  return ChoiceChip(
                    label: Text(
                      goldColor[i],
                      style: TextStyle(
                        color: selected ? Colors.orange : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    labelPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.005,
                      vertical: screenHeight * 0.007,
                    ),
                    selected: selected,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => selectedColor = i),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.white,
                    side: BorderSide(
                      color: selected ? Colors.orange : Color(0xFFEBEBEB),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  );
                }),
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    final Map<String, dynamic> selectedFilters = {
                      "minPrice": price.start.toInt(),
                      "maxPrice": price.end.toInt(),
                      "gender":
                          selectedGender != -1
                              ? [gender[selectedGender]]
                              : null,
                      "goldColor":
                          selectedColor != -1
                              ? [goldColor[selectedColor]]
                              : null,
                      "proba":
                          selectedProba != -1 ? [proba[selectedProba]] : null,
                      "size": selected,
                      "insert": selected2,
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => Filtered(filters: selectedFilters),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 241, 129, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    ),
                  ),

                  child: Text(
                    "Показать - (3 340 украшений)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
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

Widget _titleText(String title, double screenWidth) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: TextStyle(
        fontSize: screenWidth * 0.045,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget _TextField(BuildContext context, double value, String label) {
  double screenWidth = MediaQuery.of(context).size.width;
  return Container(
    width: screenWidth * 0.42,
    child: TextField(
      readOnly: true,
      controller: TextEditingController(text: "${value.toStringAsFixed(0)} ₸"),
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
      ),
    ),
  );
}

// import 'package:astra_app_1/filtered.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// class FilterPage extends StatefulWidget {
//   @override
//   _FilterPageState createState() => _FilterPageState();
// }

// class _FilterPageState extends State<FilterPage> {
//   final dio = Dio();
//   List<dynamic> filters = [];

//   List<String> gender = [];
//   int selectedGender = -1;
//   List<String> goldColor = [];
//   int selectedColor = -1;

//   RangeValues price = RangeValues(41400, 351900);
//   final List<String> sizes = [];
//   String? selected;
//   final List<String> inserts = [];
//   final List<String> proba = ["785", "555"];
//   int selectedProba = -1;

//   @override
//   void initState() {
//     super.initState();
//     fetchFilter();
//   }

//   Future<void> fetchFilter() async {
//     final url =
//         "https://api.store.astra-lombard.kz/api/v1/productfilters/search";
//     try {
//       final response = await dio.post(
//         url,
//         data: {"pageSize": 1000},
//         options: Options(headers: {"Content-Type": 'application/json'}),
//       );
//       final data = response.data;
//       print(data);
//       List<String> extractedGender = [];
//       List<String> extractedColor = [];
//       List<String> extractedSizes = [];
//       List<String> extractedInserts = [];
//       for (var filter in data["data"]) {
//         if (filter["name"] == "Для кого") {
//           extractedGender = List<String>.from(
//             filter["options"].map((adele) => adele["value"] ?? ""),
//           );
//         } else if (filter["name"] == "Цвет металла") {
//           extractedColor = List<String>.from(
//             filter["options"].map((adele) => adele["value"] ?? ""),
//           );
//         } else if (filter["name"] == "Размер") {
//           extractedSizes = List<String>.from(
//             filter["options"].map((adele) => adele["value"] ?? ""),
//           );
//         } else if (filter["name"] == "Вставка") {
//           extractedInserts = List<String>.from(
//             filter["options"].map((adele) => adele["value"] ?? ""),
//           );
//         }
//       }

//       setState(() {
//         filters = data["data"] ?? [];
//         gender = extractedGender;
//         goldColor = extractedColor;
//         sizes.addAll(extractedSizes);
//         inserts.addAll(extractedInserts);
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
//         title: Text("Фильтр", style: TextStyle(fontWeight: FontWeight.w500)),
//         centerTitle: true,
//         iconTheme: IconThemeData(size: 30),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               _titleText("Цена"),
//               SizedBox(height: 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _TextField(price.start, "От"),
//                   _TextField(price.end, "До"),
//                 ],
//               ),
//               SliderTheme(
//                 data: SliderThemeData(
//                   valueIndicatorColor: Colors.orange,
//                   overlayColor: Colors.orange,
//                   thumbColor: Colors.white,
//                   // minThumbSeparation: 100,
//                   trackHeight: 5,
//                 ),
//                 child: RangeSlider(
//                   // divisions: 10,
//                   labels: RangeLabels(
//                     price.start.toString(),
//                     price.end.toString(),
//                   ),
//                   activeColor: Colors.orange,
//                   inactiveColor: Color.fromARGB(255, 228, 228, 228),
//                   min: 41400,
//                   max: 351900,
//                   values: price,
//                   onChanged: (adi) {
//                     setState(() {
//                       print(adi);
//                       price = adi;
//                     });
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//               _titleText("Проба"),
//               SizedBox(height: 15),
//               Wrap(
//                 spacing: 17,
//                 children: List.generate(proba.length, (i) {
//                   final bool tandaldy = selectedProba == i;
//                   return ChoiceChip(
//                     label: Text(
//                       proba[i],
//                       style: TextStyle(
//                         color: tandaldy ? Colors.orange : Colors.black,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                       ),
//                     ),
//                     labelPadding: EdgeInsets.symmetric(
//                       horizontal: 68,
//                       vertical: 5,
//                     ),
//                     selected: tandaldy,
//                     showCheckmark: false,
//                     onSelected: (bool value) {
//                       setState(() {
//                         selectedProba = i;
//                       });
//                     },
//                     backgroundColor: Colors.white,
//                     selectedColor: Colors.white,
//                     side: BorderSide(
//                       color: tandaldy ? Colors.orange : Color(0xFFEBEBEB),
//                       width: 2,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   );
//                 }),
//               ),
//               SizedBox(height: 20),
//               _titleText("Для кого"),
//               SizedBox(height: 15),
//               Wrap(
//                 spacing: 10,
//                 children: List.generate(gender.length, (i) {
//                   final bool tandaldy = selectedGender == i;
//                   return ChoiceChip(
//                     label: Text(
//                       gender[i],
//                       style: TextStyle(
//                         color: tandaldy ? Colors.orange : Colors.black,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                       ),
//                     ),
//                     labelPadding: EdgeInsets.symmetric(
//                       horizontal: 2,
//                       vertical: 5,
//                     ),
//                     selected: tandaldy,
//                     showCheckmark: false,
//                     onSelected: (bool value) {
//                       setState(() {
//                         selectedGender = i;
//                       });
//                     },
//                     backgroundColor: Colors.white,
//                     selectedColor: Colors.white,
//                     side: BorderSide(
//                       color: tandaldy ? Colors.orange : Color(0xFFEBEBEB),
//                       width: 2,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   );
//                 }),
//               ),
//               SizedBox(height: 20),
//               _titleText("Размер"),
//               SizedBox(height: 15),
//               DropdownMenuTheme(
//                 data: DropdownMenuThemeData(
//                   menuStyle: MenuStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.white),
//                     shape: MaterialStateProperty.all(
//                       RoundedRectangleBorder(
//                         side: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//                 child: DropdownMenu<String>(
//                   width: 400,
//                   hintText: "Выберите размер",
//                   inputDecorationTheme: InputDecorationTheme(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: Color(0xFFEBEBEB),
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                   onSelected: (value) {
//                     setState(() {
//                       selected = value!;
//                     });
//                   },
//                   dropdownMenuEntries:
//                       sizes.map((lang) {
//                         return DropdownMenuEntry(value: lang, label: lang);
//                       }).toList(),
//                 ),
//               ),
//               SizedBox(height: 20),
//               _titleText("Вставка"),
//               SizedBox(height: 15),
//               DropdownMenuTheme(
//                 data: DropdownMenuThemeData(
//                   menuStyle: MenuStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.white),
//                     shape: MaterialStateProperty.all(
//                       RoundedRectangleBorder(
//                         side: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//                 child: DropdownMenu<String>(
//                   width: 400,
//                   hintText: "Выберите вставку",
//                   inputDecorationTheme: InputDecorationTheme(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: Color(0xFFEBEBEB),
//                         width: 2,
//                       ),
//                     ),
//                   ),
//                   onSelected: (value) {
//                     setState(() {
//                       selected = value!;
//                     });
//                   },
//                   dropdownMenuEntries:
//                       inserts.map((lang) {
//                         return DropdownMenuEntry(value: lang, label: lang);
//                       }).toList(),
//                 ),
//               ),
//               SizedBox(height: 20),
//               _titleText("Цвет золота"),
//               SizedBox(height: 15),
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: List.generate(goldColor.length, (i) {
//                   final bool tandaldy = selectedColor == i;
//                   return ChoiceChip(
//                     label: Text(
//                       goldColor[i],
//                       style: TextStyle(
//                         color: tandaldy ? Colors.orange : Colors.black,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                       ),
//                     ),
//                     labelPadding: EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 5,
//                     ),
//                     selected: tandaldy,
//                     showCheckmark: false,
//                     onSelected: (bool value) {
//                       setState(() {
//                         selectedColor = i;
//                       });
//                     },
//                     backgroundColor: Colors.white,
//                     selectedColor: Colors.white,
//                     side: BorderSide(
//                       color: tandaldy ? Colors.orange : Color(0xFFEBEBEB),
//                       width: 2,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   );
//                 }),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 width: 400,
//                 height: 55,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => Filtered()),
//                     );
//                   },
//                   child: Text(
//                     "Показать - (3 340 украшений)",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color.fromARGB(255, 241, 129, 0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _titleText(String title) {
//   return Align(
//     alignment: Alignment.centerLeft,
//     child: Text(
//       title,
//       style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//     ),
//   );
// }

// Widget _TextField(double value, String label) {
//   return Container(
//     width: 180,
//     child: TextField(
//       readOnly: true,
//       controller: TextEditingController(text: "${value.toStringAsFixed(0)} ₸"),
//       decoration: InputDecoration(
//         labelText: label,
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//     ),
//   );
// }

//good example
// import 'package:flutter/material.dart';

// class FilterPage extends StatefulWidget {
//   const FilterPage({Key? key}) : super(key: key);

//   @override
//   _SkinScreenState createState() => _SkinScreenState();
// }

// class _SkinScreenState extends State<FilterPage> {
//   RangeValues price = RangeValues(1000, 10000);
//   String? selectedSize;
//   String? selectedInsert;

//   final List<String> sizes = ['S', 'M', 'L'];
//   final List<String> inserts = ['Gold', 'Silver', 'None'];

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Фильтр"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔹 Цены
//             Text(
//               "Цена",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _TextField(price.start, "От", context),
//                 _TextField(price.end, "До", context),
//               ],
//             ),
//             RangeSlider(
//               values: price,
//               min: 0,
//               max: 20000,
//               divisions: 100,
//               labels: RangeLabels(
//                 price.start.toStringAsFixed(0),
//                 price.end.toStringAsFixed(0),
//               ),
//               onChanged: (RangeValues values) {
//                 setState(() {
//                   price = values;
//                 });
//               },
//             ),
//             SizedBox(height: 20),

//             // 🔹 Размер
//             Text(
//               "Размер",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             DropdownMenu<String>(
//               width: screenWidth * 0.9,
//               hintText: 'Выберите размер',
//               onSelected: (value) {
//                 setState(() {
//                   selectedSize = value;
//                 });
//               },
//               dropdownMenuEntries:
//                   sizes
//                       .map((e) => DropdownMenuEntry(value: e, label: e))
//                       .toList(),
//             ),

//             SizedBox(height: 20),

//             // 🔹 Вставка
//             Text(
//               "Вставка",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             DropdownMenu<String>(
//               width: screenWidth * 0.9,
//               hintText: 'Выберите вставку',
//               onSelected: (value) {
//                 setState(() {
//                   selectedInsert = value;
//                 });
//               },
//               dropdownMenuEntries:
//                   inserts
//                       .map((e) => DropdownMenuEntry(value: e, label: e))
//                       .toList(),
//             ),

//             SizedBox(height: 40),

//             // 🔹 Кнопка применить
//             Container(
//               width: screenWidth * 0.9,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Действие при применении фильтра
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 child: Text(
//                   "Применить",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🔹 Поле для отображения цены
//   Widget _TextField(double value, String label, BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.42,
//       child: TextField(
//         readOnly: true,
//         controller: TextEditingController(
//           text: "${value.toStringAsFixed(0)} ₸",
//         ),
//         decoration: InputDecoration(
//           labelText: label,
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//             borderRadius: BorderRadius.circular(15),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Color(0xFFEBEBEB), width: 2),
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//       ),
//     );
//   }
// }
