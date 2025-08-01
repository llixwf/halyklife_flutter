import 'package:astra_app_1/app_nav_bar.dart';
import 'package:astra_app_1/cart.dart';
import 'package:astra_app_1/catalog.dart';
import 'package:astra_app_1/like.dart';
import 'package:astra_app_1/profile.dart';
import 'package:astra_app_1/shop.dart';
import 'package:flutter/material.dart';

// class BottomnNavigation extends StatefulWidget {
//   @override
//   _BottomnNavigationState createState() => _BottomnNavigationState();
// }

// class _BottomnNavigationState extends State<BottomnNavigation> {
//   int _selectedIndex = 4;

//   final List<Widget> widgetOptions = [
//     ShopPage(),
//     Catalog(),
//     Cart(),
//     Like(),
//     Profile(),
//   ];

//   void _onItemTapped(int san) {
//     setState(() {
//       _selectedIndex = san;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widgetOptions.elementAt(_selectedIndex),
//       bottomNavigationBar: AppBottomNavBar(
//         selectedIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
class BottomnNavigation extends StatefulWidget {
  final int initialIndex;

  const BottomnNavigation({super.key, this.initialIndex = 4});

  @override
  _BottomnNavigationState createState() => _BottomnNavigationState();
}

class _BottomnNavigationState extends State<BottomnNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> widgetOptions = [
    ShopPage(),
    Catalog(),
    Cart(),
    Like(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions[_selectedIndex],
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
