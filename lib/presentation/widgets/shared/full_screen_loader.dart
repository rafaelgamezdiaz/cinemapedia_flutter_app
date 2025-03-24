import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final List<String> messages = [
      'Cargando Películas ...',
      'Comprando las Palomitas de Maiz ...',
      'Llamando a mi novia ...',
      'Esto está tardando más de lo que pensé :(',
    ];
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          const SizedBox(height: 10),
          Text('Cargando...', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.all(10), // Espaciado interno
            decoration: BoxDecoration(
              color: Colors.black12, // Fondo naranja
              borderRadius: BorderRadius.circular(
                10,
              ), // Bordes redondeados (opcional)
            ),
            child: StreamBuilder(
              stream: getLoadingMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Cargando ...');

                return Text(snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
