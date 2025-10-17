<<<<<<< HEAD
import 'package:citiguide_app/pages/admin/add_attraction_page.dart';
import 'package:citiguide_app/pages/admin/add_city_page.dart';
import 'package:citiguide_app/pages/admin/city_list_page.dart';
import 'package:citiguide_app/pages/admin/manage_attraction_page.dart';
import 'package:citiguide_app/pages/admin/manage_review_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'splash_screen.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/auth/forgot_password_page.dart';
import 'pages/admin/admin_dashboard.dart';
import 'pages/users/user_dashboard.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const ProviderScope(child: MyApp()));
=======
import 'package:citiguide_app/BlankPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
>>>>>>> e46c2c8e915aa3ee1bd1a4dd908420d437ab7e4a
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

<<<<<<< HEAD
  Future<Widget> _getInitialPage() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const LoginPage();

    final authService = AuthService();
    final userModel = await authService.getUserData(user.uid);

    if (userModel == null) return const LoginPage();

    return userModel.role == 'admin'
        ? const AdminDashboard()
        : const UserDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Guide App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            return snapshot.data ?? const LoginPage();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/adminDashboard': (context) => const AdminDashboard(),
        '/userDashboard': (context) => const UserDashboard(),
        '/addCity': (context) => const AddCityPage(),
        '/cityList': (context) => const CityListPage(),
        '/addAttraction': (context) => const AddAttractionPage(),
        '/manageAttractions': (context) => const ManageAttractionsPage(),
        '/manageReviews': (context) => const ManageReviewsPage(),

      },
=======
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CitiGuide',
      home: BlankPage(),
>>>>>>> e46c2c8e915aa3ee1bd1a4dd908420d437ab7e4a
    );
  }
}
