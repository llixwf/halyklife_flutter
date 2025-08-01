import 'package:flutter/material.dart';
import 'account.dart';

class Datas extends StatefulWidget {
  const Datas({super.key});

  @override
  _DatasState createState() => _DatasState();
}

class _DatasState extends State<Datas> {
  int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(size: 30),
        title: Text(
          "Мои данные",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
        ),
      ),
      body: DataUser(),
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
              Navigator.pushNamed(context, '/Profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store, size: 30),
            label: 'Магазин',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt, size: 30),
            label: 'Каталог',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 30),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: 30),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

class DataUser extends StatefulWidget {
  @override
  _DataUserState createState() => _DataUserState();
}

class _DataUserState extends State<DataUser> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
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
          SizedBox(height: 35),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person, size: 35, color: Colors.black),
                    title: Text(
                      "Аккаунт",
                      style: TextStyle(fontSize: 16, color: Color(0xFF909090)),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 22),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserInp()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEBEBEB), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.card_giftcard, size: 33),
                    title: Text(
                      "Мои бонусы",
                      style: TextStyle(fontSize: 16, color: Color(0xFF909090)),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 22),
                    onTap: () {
                      Navigator.pushNamed(context, "/Next");
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 490),
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
        ],
      ),
    );
  }
}
