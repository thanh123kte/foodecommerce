import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodecommerce/controller/category_controller.dart';
import 'package:foodecommerce/controller/food_controller.dart';
import 'package:foodecommerce/view/auth/login.dart';
import 'package:foodecommerce/view/auth/register.dart';
import 'package:foodecommerce/view/customer/cus_home.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => CategoryController()),
        ChangeNotifierProvider(create: (context) => FoodController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ecommerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/cushome': (context) => const CusHomeScreen(),
      },
    );
  }
}
