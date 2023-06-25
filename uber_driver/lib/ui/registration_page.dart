import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uber_driver/ui/upload_photo.dart';
import 'package:uber_driver/utils/app_info.dart';
import 'package:uber_driver/widgets/default_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:uber_driver/widgets/default_text_field.dart';

import '../widgets/registration_input.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    //Registration Page covers the users' personal information input
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text("Registration"),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
              flex: 1,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Center(
                    child: Image.asset(
                      "lib/assets/hero.png",
                      scale: 10,
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  Center(
                    child: Text(
                      "Welcome to Para",
                      style: defaultStyle.copyWith(
                          color: Color.fromARGB(255, 104, 147, 221),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      "The best transportation app in the city.",
                      textAlign: TextAlign.center,
                      style: defaultStyle.copyWith(
                          color: Color.fromARGB(255, 104, 147, 221),
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Center(
                    child: Text(
                      "To get started, please fill in the fields below.",
                      textAlign: TextAlign.center,
                      style: defaultStyle.copyWith(
                          color: Color.fromARGB(255, 73, 107, 164),
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  RegistrationInput(
                    hintText: "First Name:",
                  ),
                  RegistrationInput(
                    hintText: "Last Name:",
                  ),
                  RegistrationInput(
                    hintText: "Barangay:",
                  ),
                  RegistrationInput(
                    hintText: "Purok:",
                  ),
                  RegistrationInput(
                    hintText: "House number\n(optional):",
                  ),
                  RegistrationInput(
                    hintText: "Contact Person:",
                  ),
                  RegistrationInput(
                    hintText: "Contact Person\nNumber:",
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: ShapeDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color.fromARGB(255, 162, 247, 226),
                                  Color.fromARGB(255, 162, 175, 247)
                                ]),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        child: IconButton(
                          onPressed: () async {
                            PickedFile file = await ImagePickerAndroid()
                                .pickImage(source: ImageSource.gallery);
                            setState(() {});
                            if (file == null) {
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  UploadPhoto(
                                        photo_name: "Valid ID",
                                        photo_file: file),
                                  ));
                            }
                          },
                          tooltip: "Valid ID",
                          icon: Icon(
                            Icons.picture_in_picture_outlined,
                          ),
                          color: Colors.black45,
                          enableFeedback: true,
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: ShapeDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color.fromARGB(255, 162, 247, 226),
                                  Color.fromARGB(255, 162, 175, 247)
                                ]),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        child: IconButton(
                          tooltip: "Selfie",
                          onPressed: () {},
                          icon: Icon(
                            Icons.camera,
                          ),
                          color: Colors.black45,
                          enableFeedback: true,
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: ShapeDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color.fromARGB(255, 162, 247, 226),
                                  Color.fromARGB(255, 162, 175, 247)
                                ]),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        child: IconButton(
                          tooltip: "Franchise",
                          onPressed: () {},
                          icon: Icon(
                            Icons.verified_outlined,
                          ),
                          color: Colors.black45,
                          enableFeedback: true,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                ],
              ))
        ],
      ),
    );
  }
}
