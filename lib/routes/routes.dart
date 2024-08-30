import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/screens/home_screen.dart';
import 'package:zero_waste/screens/login_screen.dart';
import 'package:zero_waste/screens/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    ],
  );
}
