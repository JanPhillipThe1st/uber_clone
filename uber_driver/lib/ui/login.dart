import 'package:flutter/material.dart';

import '../utils/app_info.dart';
import '../widgets/default_text.dart';
import '../widgets/default_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key});

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
                          obscure: false),
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
                                  Navigator.pushNamed(
                                      context, "/search_passengers");
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
