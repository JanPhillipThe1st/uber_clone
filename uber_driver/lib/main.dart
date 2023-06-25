import 'package:flutter/material.dart';
import 'package:uber_driver/ui/account.dart';
import 'package:uber_driver/ui/earnings.dart';
import 'package:uber_driver/ui/earnings_details.dart';
import 'package:uber_driver/ui/home.dart';
import 'package:uber_driver/ui/login.dart';
import 'package:uber_driver/ui/notifications.dart';
import 'package:uber_driver/ui/profile.dart';
import 'package:uber_driver/ui/promotions.dart';
import 'package:uber_driver/ui/recent_transactions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uber_driver/ui/registration_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyD3AFEl6TfjeVffU456i1IAxmYehNcUgL8",
            appId: "1:402617973882:android:1c83108363b23b8244cfc3",
            projectId: "para-transportation",
            messagingSenderId: '402617973882'));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Para Transportation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/registration': (context) => RegistrationPage(),
        '/search_passengers': (context) =>
            MyHomePage(title: 'Para Transportation'),
        '/notifications': (context) => NotificationsPage(),
        '/earnings': (context) => EarningsPage(),
        '/profile': (context) => ProfilePage(),
        '/earnings_details': (context) => EarningsDetailsPage(),
        '/recent_transations': (context) => RecentTransactionsPage(),
        '/promotions': (context) => PromotionsPage(),
        '/account': (context) => AccountPage(),
      },
    );
  }
}
