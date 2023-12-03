import 'package:flutter/material.dart';
import 'package:uber_driver/functions/firestore.dart';

import '../utils/app_info.dart';
import '../widgets/default_text.dart';
import '../widgets/default_text_field.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController username_controller = new TextEditingController();
TextEditingController password_controller = new TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(), color: Colors.black),
        width: 400,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(vertical: 50)),
                Image.asset(
                  "lib/assets/hero.png",
                  scale: 10,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Container(
                  width: 340,
                  padding: EdgeInsets.all(20),
                  height: 360,
                  decoration: defaultDecoration,
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      DefaultText(
                        text: "Username",
                        width: double.infinity,
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      DefaultTextField(
                          hint: "Username",
                          color: Colors.white,
                          controller: username_controller,
                          obscure: false),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      DefaultText(text: "Password", width: double.infinity),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      DefaultTextField(
                          hint: "Password",
                          color: Colors.white,
                          controller: password_controller,
                          obscure: true),
                      Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/registration");
                            },
                            child: Text(
                              "Need an account?\nSign up here!",
                              style: defaultStyle.copyWith(fontSize: 10),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                          Container(
                            decoration: ShapeDecoration(
                                color: Color.fromARGB(255, 46, 75, 202),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60))),
                            width: 100,
                            padding: EdgeInsets.all(2),
                            child: TextButton(
                                onPressed: () {
                                  FirestoreMethods()
                                      .login(
                                          username: username_controller.text,
                                          password: password_controller.text)
                                      .then((value) {
                                    if (value["username"] != null) {
                                      Navigator.pushNamed(
                                          context, "/view_ride_requests");
                                    } else {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title:
                                                    const Text('Login Failed'),
                                                content: const Text(
                                                    'Your account does not exist yet.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              )).then((value) {
                                        print(value);
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  width: 300,
                                  child: Text(
                                    "Log in",
                                    textAlign: TextAlign.center,
                                    style: defaultStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
