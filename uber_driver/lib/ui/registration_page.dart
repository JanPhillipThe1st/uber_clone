import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uber_driver/ui/upload_photo.dart';
import 'package:uber_driver/utils/app_info.dart';
import 'package:uber_driver/widgets/default_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:uber_driver/widgets/default_text_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/registration_input.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

Map<String, PickedFile> photos = new Map<String, PickedFile>();
Map<String, dynamic> photoURLs = new Map<String, dynamic>();
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseStorage _storageBucket =
    FirebaseStorage.instanceFor(bucket: "gs://para-transportation.appspot.com");
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController barangayController = TextEditingController();
TextEditingController purokController = TextEditingController();
TextEditingController houseNumberController = TextEditingController();
TextEditingController contactPersonController = TextEditingController();
TextEditingController contactPersonNumberController = TextEditingController();
bool _isLoading = false;

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
                    controller: firstNameController,
                  ),
                  RegistrationInput(
                    hintText: "Last Name:",
                    controller: lastNameController,
                  ),
                  RegistrationInput(
                    hintText: "Barangay:",
                    controller: barangayController,
                  ),
                  RegistrationInput(
                    hintText: "Purok:",
                    controller: purokController,
                  ),
                  RegistrationInput(
                    hintText: "House number\n(optional):",
                    controller: houseNumberController,
                  ),
                  RegistrationInput(
                    hintText: "Contact Person:",
                    controller: contactPersonController,
                  ),
                  RegistrationInput(
                    hintText: "Contact Person\nNumber:",
                    controller: contactPersonNumberController,
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
                            PickedFile? file = await ImagePickerAndroid()
                                .pickImage(source: ImageSource.gallery);
                            photos["valid_id"] = file!;
                            setState(() {});
                            if (file == null) {
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UploadPhoto(
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
                          onPressed: () async {
                            PickedFile? file = await ImagePickerAndroid()
                                .pickImage(source: ImageSource.gallery);
                            photos["selfie"] = file!;
                            setState(() {});
                            if (file == null) {
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UploadPhoto(
                                        photo_name: "Selfie", photo_file: file),
                                  ));
                            }
                          },
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
                          onPressed: () async {
                            PickedFile? file = await ImagePickerAndroid()
                                .pickImage(source: ImageSource.gallery);
                            photos["franchise"] = file!;
                            setState(() {});
                            if (file == null) {
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UploadPhoto(
                                        photo_name: "Franchise ID",
                                        photo_file: file),
                                  ));
                            }
                          },
                          icon: Icon(
                            Icons.verified_outlined,
                          ),
                          color: Colors.black45,
                          enableFeedback: true,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Expanded(
                      child: TextButton(
                    onPressed: () async {
                      _isLoading = true;
                      setState(() {});
                      await _storageBucket
                          .ref("User Photos")
                          .child("Valid ID")
                          .putData(await photos["valid_id"]!.readAsBytes());
                      _storageBucket
                          .ref("User Photos")
                          .child("Valid ID")
                          .getDownloadURL()
                          .then((value) {
                        photoURLs["valid_id"] = value;
                      });
                      await _storageBucket
                          .ref("User Photos")
                          .child("Selfie")
                          .putData(await photos["selfie"]!.readAsBytes());
                      _storageBucket
                          .ref("User Photos")
                          .child("Selfie")
                          .getDownloadURL()
                          .then((value) {
                        photoURLs["selfie"] = value;
                      });
                      await _storageBucket
                          .ref("User Photos")
                          .child("Franchise")
                          .putData(await photos["franchise"]!.readAsBytes());
                      _storageBucket
                          .ref("User Photos")
                          .child("Franchise")
                          .getDownloadURL()
                          .then((value) {
                        photoURLs["franchise"] = value;
                      });
                      photoURLs["first_name"] = firstNameController.text;
                      photoURLs["last_name"] = lastNameController.text;
                      photoURLs["barangay"] = barangayController.text;
                      photoURLs["purok"] = purokController.text;
                      photoURLs["house_number"] = houseNumberController.text;
                      photoURLs["contact_person"] =
                          contactPersonController.text;
                      photoURLs["contact_person_number"] =
                          contactPersonNumberController.text;
                      _firestore.collection("Drivers").add(photoURLs);
                      _isLoading = false;
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Photos Successfully Uploaded!")));
                    },
                    child: Container(
                      decoration: ShapeDecoration(
                          color: Color.fromARGB(255, 20, 178, 110),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Done",
                                  style: defaultStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.check,
                                  color: defaultStyle.color,
                                )
                              ],
                            ),
                    ),
                  ))
                ],
              ))
        ],
      ),
    );
  }
}
