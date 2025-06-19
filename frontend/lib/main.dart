import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodecommerce/controller/firebase_auth_controller.dart';
import 'package:foodecommerce/controller/category_controller.dart';
import 'package:foodecommerce/controller/food_controller.dart';
import 'package:foodecommerce/controller/seller_controller.dart';
import 'package:foodecommerce/controller/test_fire_auth_controller.dart';
import 'package:foodecommerce/view/auth/login.dart';
import 'package:foodecommerce/view/auth/register.dart';
import 'package:foodecommerce/view/auth/reset_password.dart';
import 'package:foodecommerce/view/customer/cus_home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize FirebaseAuthController
  final firebaseAuthController = TestFirebaseAuthController();
  await firebaseAuthController.initAuth();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => firebaseAuthController),
        ChangeNotifierProvider(create: (context) => CategoryController()),
        ChangeNotifierProvider(create: (context) => FoodController()),
        ChangeNotifierProvider(create: (context) => ShopController()), // Đảm bảo có ShopController
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ecommerce',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, // Thêm này để ẩn debug banner
      home: Consumer<TestFirebaseAuthController>(
        builder: (context, auth, child) {
          if (auth.isLoggedIn) {
            return const CusHomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/cushome': (context) => const CusHomeScreen(),
      },
    );
  }
}