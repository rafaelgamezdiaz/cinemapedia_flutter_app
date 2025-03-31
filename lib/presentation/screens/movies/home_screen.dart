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
      body: IndexedStack(index: pageIndex, children: viewRoutes),
      //  backgroundColor: const Color.fromARGB(255, 75, 83, 156),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex),
    );
  }
}
