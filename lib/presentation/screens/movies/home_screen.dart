import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final Widget childView;

  const HomeScreen({super.key, required this.childView});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childView,
      //  backgroundColor: const Color.fromARGB(255, 75, 83, 156),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
