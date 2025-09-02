// import 'package:astra_app_1/routes/app_router.gr.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';

// @RoutePage()
// class MainScreen extends StatelessWidget {
//   const MainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AutoTabsRouter(
//       routes: [Profile(), Like(), Cart(), Catalog(), ShopRoute()],
//       builder: (context, child) {
//         final tabsRouter = AutoTabsRouter.of(context);
//         return Scaffold(
//           body: child,
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: tabsRouter.activeIndex,
//             onTap: (value) {
//               tabsRouter.setActiveIndex(value);
//             },
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.store, size: 30),
//                 label: 'Магазин',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.list_alt, size: 30),
//                 label: 'Каталог',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.shopping_cart, size: 30),
//                 label: 'Корзина',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.favorite_border, size: 30),
//                 label: 'Избранное',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person, size: 30),
//                 label: 'Профиль',
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
