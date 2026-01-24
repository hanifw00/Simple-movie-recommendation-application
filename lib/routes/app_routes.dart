import 'package:amflix/pages/detail_home.dart';
import 'package:amflix/pages/home.dart';
import 'package:amflix/pages/first.dart';
import 'package:amflix/pages/login.dart';
import 'package:amflix/pages/registration.dart';

import 'package:amflix/pages/splash.dart';
import 'package:flutter/material.dart';
import '../models/movie_model.dart';



class AppRoutes {
  // Nama route (biar konsisten & aman typo)
  static const String splash = '/';
  static const String pageLogin = '/first';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String movieDetail = '/movie-detail';

 

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

       case pageLogin:
        return MaterialPageRoute(
          builder: (_) => const First(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const Registration(),
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );

      case AppRoutes.movieDetail:
      final movie = settings.arguments as Movie;
        return MaterialPageRoute(
    builder: (_) => DetailMovie(movie: movie),
  );


      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route tidak ditemukan'),
            ),
          ),
        );
    }
  }
}