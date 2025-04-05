import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({super.key, required this.currentIndex});

  // void _onItemTapped(BuildContext context, int index) {
  //   switch (index) {
  //     case 0:
  //       context.go('/home/0');
  //       break;
  //     case 1:
  //       context.go('/home/1');
  //       break;
  //     case 2:
  //       context.go('/home/2');
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Obtiene el índice actual para resaltar el ítem correcto
    // final currentIndex = getCurrentIndex(context);
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap:
          (index) =>
              context.go('/home/$index'), // _onItemTapped(context, index),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outlined),
          label: 'Populares',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
      ],
    );
  }
}
