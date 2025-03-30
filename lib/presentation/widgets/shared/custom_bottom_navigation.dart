import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  // Función para obtener el índice actual basado en la ruta
  // (Necesario si quieres que el ítem correcto esté resaltado)
  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    // Alternativamente, puedes usar .location si .matchedLocation no te da
    // el resultado esperado en tu estructura de rutas específica.

    switch (location) {
      case '/':
        return 0;
      case '/categories':
        return 2;
      case '/favorites':
        return 2;
      // Añade aquí el caso para '/categories' cuando lo implementes
      // case '/categories':
      //   return 1;
      default:
        // Si estás en una subruta como /movie/:id, podrías querer
        // que 'Inicio' siga seleccionado.
        if (location.startsWith('/movie/')) {
          return 0;
        }
        // Valor por defecto o manejo de error si es necesario
        return 0;
    }
  }

  void _onItemTap(context, int index) {
    // Aquí puedes manejar la navegación a las diferentes pantallas
    // dependiendo del índice seleccionado.
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        // Navegar a la pantalla de categorías
        break;
      case 2:
        // Navegar a la pantalla de favoritos
        GoRouter.of(context).go('/favorites');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene el índice actual para resaltar el ítem correcto
    final currentIndex = getCurrentIndex(context);
    return BottomNavigationBar(
      elevation: 10,
      currentIndex: currentIndex,
      onTap: (index) => _onItemTap(context, index),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outlined),
          label: 'Categorías',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
      ],
    );
  }
}
