import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:uber_driver/ui/view_ride_requests.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyD3AFEl6TfjeVffU456i1IAxmYehNcUgL8',
      appId: "1:402617973882:android:c8f1d93110f19f5344cfc3",
      messagingSenderId: '402617973882',
      projectId: 'para-transportation',
      storageBucket: 'para-transportation.appspot.com',
    ),
    // options: const FirebaseOptions(
    //   apiKey: 'AIzaSyC1otrAffpEES7P5rWZW7BFAivT6PpZjb4',
    //   appId: "1:322172466330:android:b679d43a17a1ba84a1db23",
    //   messagingSenderId: '322172466330',
    //   projectId: 'para-transportation-5dbce',
    //   storageBucket: 'para-transportation-5dbce.appspot.com',
    // ),
  );

  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        '/view_ride_requests': (context) => ViewRideRequests(),
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
