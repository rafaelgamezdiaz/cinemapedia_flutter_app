# Crear el proyecto flutter

    flutter create app_name 

# Configuración del proyecto

- Dentro de lib/ Crear la carpeta /config
- Dentro de /config crear las carpetas /router y /theme
- Dentro de /router crear el archivo /router/app_router.dart
- Dentro de /theme crear el archivo /theme/app_theme.dart
- En main.dart deshabilitar la marca debug de la esquina superior derecha
- Dentro de app_theme.dart crear la clase AppTheme y llamarla desde el main.dart
- Instalar go_router en el proyecto (si tenemos instalado el plugin PubSpec Assist entonces Ctrl + Shift + p, seguidamente escribimos Pupspec Assist y damos enter, y en la ventana que se abre escribimos go_router y damos enter, eso nos debe instalar go_router). Verificamos el pubspec.yaml de la raiz del proyecto para ver si se instaló go_router correctamente.
- Creamos la carpeta /presentation
- Creamos dentro de /presentation la carpeta /presentation/screens/
- Creamos la carpeta /presentation/screens/movies/
- Creamos el archivo /presentation/screens/movies/home_screen.dart

### Configuracion inicial del widget tipo screen

El widget debe tener un nombre similar a HomeScreen, es decir iría seguidi de la palabra Screen siempre

Ademas debemos crear una propiedad estática del nombre que va a tener la ruta para acceder a esa vista. Se crea como estática para que cuando se vaya a llamar a la ruta no sea necesario crear una instancia de la clase.

    static const name = 'home-screen'

### Creamos un archivo de 'orden' ya que como vamos a tener mas pantallas este archivo permitira colocar en el las importaciones necesarias

Creamos /presentation/screens/screens.dart

En ese archivos vamos a tener muchas lineas como esta:

    export 'package:cinemapedia/presentation/screens/movies/home_screen.dart';

### Configuramos la primera ruta en el archivo app_router.dart

    import 'package:cinemapedia/presentation/screens/screens.dart';
       import 'package:go_router/go_router.dart';

        final appRouter = GoRouter(
        initialLocation: '/',
        routes: [
            GoRoute(
            path: '/', 
            name: HomeScreen.name,
            builder: (context, state) => const HomeScreen()
            ),
        ]
        )
    

### Comenzando a urilizar el router

En este punto ya en el main.dart vamos a hacer uso de router, por lo que la clase Material no va a utilizar un body pues ya router sabe cual es la primera ruta que se va a mostrar

    
    import 'package:flutter/material.dart';
    import 'package:cinemapedia/config/router/app_router.dart';
    import 'package:cinemapedia/config/theme/app_theme.dart';

    void main() {
        runApp(const MyApp());
        }

        class MyApp extends StatelessWidget {
        const MyApp({super.key});
        @override
        Widget build(BuildContext context) {
            return MaterialApp.router(
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
            title: 'Cinemapedia',
            theme: AppTheme().getTheme(),
            );
        }
    }
    
## Implementando Datasources & Repositories

- Creamos una carpeta llamada /domain
- Creamos la carpeta /domain/entities
- Creamos la carpeta /domain/datasources
- Creamos la carpeta /domain/repositories

### Creamos la clase entity Movie

Creamos el archivo /domain/entities/movie.dart

    class Movie {
        final bool adult;
        final String backdropPath;
        final List<String> genreIds;
        final int id;
        final String originalLanguage;
        final String originalTitle;
        final String overview;
        final double popularity;
        final String posterPath;
        final DateTime releaseDate;
        final String title;
        final bool video;
        final double voteAverage;
        final int voteCount;

        Movie({
            required this.adult,
            required this.backdropPath,
            required this.genreIds,
            required this.id,
            required this.originalLanguage,
            required this.originalTitle,
            required this.overview,
            required this.popularity,
            required this.posterPath,
            required this.releaseDate,
            required this.title,
            required this.video,
            required this.voteAverage,
            required this.voteCount
        });
        }

Esta clase es la que nos permite crear la instancia de lo que va a utilizar nuestra aplicación (al igual que otras clases entities), es decir esto es lo que utilizamos no lo que venga de la API porque eso puede cambiar.

### Creamos la clase MoviesDatasource

Creamos /domain/datasources/movies_datasource.dart

    import 'package:cinemapedia/domain/entities/movie.dart';

    abstract class MoviesDatasource {
        Future<List<Movie>> getNowPlayingMovies({int page = 1});
    }

Esta es una clase abstracta que no tiene implementación


### Creamos la clase MoviesRepository

Creamos /domain/repositories/movies_repository.dart

    import 'package:cinemapedia/domain/entities/movie.dart';

    abstract class MoviesRepository {
        Future<List<Movie>> getNowPlayingMovies({int page = 1});
    }

Esta es una clase abstracta que no tiene implementación. Si nos fijamos esta clase se ve igual a la de datasource. Pero la de datasource es la que definirá los origenes de datos mientras que los repositorios son los que llaman al datasouce. Es decir el datasource no lo llamaremos de manera directa, sinó a través de los repositorios.

Es decir los repositorios permitirá cambiar facilmente cual es la fuente de datos que vamos a utilizar, cambiano un datasource por otro, sin tener que hacer cambios en otras partes del código.
