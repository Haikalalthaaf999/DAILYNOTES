
import 'package:flutter/material.dart';
import 'package:dailynotes/experiment/login.dart';
import 'package:dailynotes/experiment/register.dart';
import 'package:dailynotes/experiment/note_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('name');
  final email = prefs.getString('email');
  final phone = prefs.getString('phone');
  runApp( MyApp(
    isLoggedIn: name != null && email != null && phone != null,
      name: name,
      email: email,
      phone: phone,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? name;
  final String? email;
  final String? phone;
   MyApp({super.key,
    required this.isLoggedIn,
    this.name,
    this.email,
    this.phone,
  });

  // Deklarasi GlobalKey untuk Navigator
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Notes',
      //  navigatorKey untuk mengelola Navigator secara global
      navigatorKey: navigatorKey,
      initialRoute: '/login',
      routes: {
        '/login': (context) =>  LoginScreen(),
        '/register': (context) =>  RegisterScreen(),
        '/home': (context) =>  NotesScreen(),
      },
    );
  }
}
