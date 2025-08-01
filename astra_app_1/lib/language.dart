import 'package:flutter/material.dart';

class Language extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(
                width: 250,
                height: 220,
                child: Image.asset("images/Logo-3.png"),
              ),
              Text(
                "Выберите язык \n приложения",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Вы всегда сможете изменить язык \n в настройках приложения",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 22, bottom: 10),
                  child: Text("Язык", style: TextStyle(fontSize: 15)),
                ),
              ),
              Select(),
              SizedBox(height: 40),
              Container(
                width: 400,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/LogIn");
                  },
                  child: Text(
                    "Продолжить",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF34398B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

class Images extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetName = AssetImage("images/Logo-3.png");
    Image image = Image(image: assetName);
    return Container(child: image, width: 250, height: 220);
  }
}

class Select extends StatefulWidget {
  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  String? selectedLanguage;
  bool isDropdownOpened = true;
  final List<String> languages = [
    "Русский",
    "Kazakça",
    "Polski",
    "Türkçe",
    "English",
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownMenuTheme(
          data: DropdownMenuThemeData(
            menuStyle: MenuStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          child: DropdownMenu<String>(
            width: 400,
            hintText: "Выберите язык",
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.orange, width: 2),
              ),
            ),
            onSelected: (value) {
              setState(() {
                selectedLanguage = value!;
              });
            },
            dropdownMenuEntries:
                languages.map((lang) {
                  return DropdownMenuEntry(value: lang, label: lang);
                }).toList(),
          ),
        ),
        if (!isDropdownOpened) SizedBox(height: 230),
      ],
    );
  }
}
