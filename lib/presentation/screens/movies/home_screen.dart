import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../views/views.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  final viewRoutes = const <Widget>[
    HomeView(),
    Center(child: Text('Inicio')),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 50), // Duración de la animación
        transitionBuilder: (child, animation) {
          // Aplicar un FadeTransition
          return FadeTransition(opacity: animation, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey(pageIndex), // Clave única basada en el índice
          child: viewRoutes[pageIndex],
        ),
      ),
      // backgroundColor: const Color.fromARGB(255, 75, 83, 156),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex),
    );
  }
}

/* 
AnimatedSwitcher(
        duration: const Duration(milliseconds: 200), // Duración de la animación
        transitionBuilder: (child, animation) {
          // Aplicar un FadeTransition
          return FadeTransition(opacity: animation, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey(pageIndex), // Clave única basada en el índice
          child: viewRoutes[pageIndex],
        ),
      )
 */
