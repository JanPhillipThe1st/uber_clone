import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uber_driver/functions/firestore.dart';
import 'package:uber_driver/functions/storage_methods.dart';
import 'package:uber_driver/utils/text_utilities.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:uber_driver/widgets/text_field_widget.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<RegistrationPage> {
  bool _completelyFilled = false;
  Map<String, dynamic> user_data = {};
  bool isComplete(
      {List<TextEditingController>? controllers, List<Image?>? images}) {
    for (TextEditingController controller in controllers!) {
      if (controller!.text.length < 1) {
        return false;
      }
    }
    for (Image? image in images!) {
      if (image == null) {
        return false;
      }
    }

    setState(() {
      if (checkPassword()) {
        _completelyFilled = true;
      } else {
        _completelyFilled = false;
      }
    });
    return true;
  }

  bool checkPassword() {
    if (_passwordController.text != _confirmPasswordController.text) {
      return false;
    }
    return true;
  }

  TextEditingController _usernameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmPasswordController = TextEditingController();
  TextEditingController _purokController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _barangayController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  Image? _profileImage;
  Image? _IDImage;
  Image? _licenseImage;
  PickedFile? _pickedImageFile, _pickedIDFile, _pickedLicenseFile;
  final passNotifier = ValueNotifier<PasswordStrength?>(null);
  String signupMessage = "All fields must be filled.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.blueAccent,
        child: ListView(
          scrollDirection: Axis.vertical,
          clipBehavior: Clip.hardEdge,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Container(
              height: 200,
              child: _profileImage ??
                  Image.asset(
                    "assets/icons/man.png",
                    scale: 4,
                  ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            TextButton(
                onPressed: () async {
                  _pickedImageFile = await ImagePickerAndroid()
                      .pickImage(source: ImageSource.gallery);
                  _profileImage =
                      Image.memory(await _pickedImageFile!.readAsBytes());
                  user_data["profile_picture_image"] = await StorageMethods()
                      .uploadProfilePic(await _pickedImageFile!.readAsBytes());
                  isComplete(controllers: [
                    _usernameController,
                    _passwordController,
                    _confirmPasswordController,
                    _purokController,
                    _nameController,
                    _barangayController,
                    _emailController,
                  ], images: [
                    _profileImage,
                    _IDImage,
                    _licenseImage,
                  ]);
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(
                            style: BorderStyle.solid, color: Colors.white)),
                    color: Colors.transparent,
                  ),
                  child: Text(
                    "Choose Profile Picture",
                    style: defaultTextStyle,
                  ),
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Container(
                child: TextFieldWidget(
              controller: _nameController,
              onchange: (value) {
                isComplete(controllers: [
                  _usernameController,
                  _nameController,
                  _passwordController,
                  _confirmPasswordController,
                  _purokController,
                  _barangayController,
                  _emailController,
                ], images: [
                  _profileImage,
                  _IDImage,
                  _licenseImage,
                ]);
              },
              hinttext: "Full Name (First name, M.I., Last name)",
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Container(
                child: TextFieldWidget(
              controller: _usernameController,
              onchange: (value) {
                isComplete(controllers: [
                  _usernameController,
                  _passwordController,
                  _nameController,
                  _confirmPasswordController,
                  _purokController,
                  _barangayController,
                  _emailController,
                ], images: [
                  _profileImage,
                  _IDImage,
                  _licenseImage,
                ]);
              },
              hinttext: "Username",
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Container(
                child: TextFieldWidget(
              controller: _emailController,
              onchange: (value) {
                isComplete(controllers: [
                  _usernameController,
                  _passwordController,
                  _nameController,
                  _confirmPasswordController,
                  _purokController,
                  _barangayController,
                  _emailController,
                ], images: [
                  _profileImage,
                  _IDImage,
                  _licenseImage,
                ]);
              },
              hinttext: "Email",
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Container(
                child: TextFieldWidget(
              controller: _purokController,
              onchange: (value) {
                isComplete(controllers: [
                  _usernameController,
                  _passwordController,
                  _nameController,
                  _confirmPasswordController,
                  _purokController,
                  _barangayController,
                  _emailController,
                ], images: [
                  _profileImage,
                  _IDImage,
                  _licenseImage,
                ]);
              },
              hinttext: "Purok/Street",
            )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Container(
                child: TextFieldWidget(
              controller: _barangayController,
              onchange: (value) {
                isComplete(controllers: [
                  _usernameController,
                  _nameController,
                  _passwordController,
                  _confirmPasswordController,
                  _purokController,
                  _barangayController,
                  _emailController,
                ], images: [
                  _profileImage,
                  _IDImage,
                  _licenseImage,
                ]);
              },
              hinttext: "Barangay/District",
            )),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Container(
                child: TextFieldWidget(
              controller: _passwordController,
              onchange: (value) {
                passNotifier.value = PasswordStrength.calculate(text: value);
                isComplete(controllers: [
                  _usernameController,
                  _passwordController,
                  _nameController,
                  _confirmPasswordController,
                  _purokController,
                  _barangayController,
                  _emailController,
                ], images: [
                  _profileImage,
                  _IDImage,
                  _licenseImage,
                ]);
              },
              hinttext: "Password",
              obscured: true,
            )),
            const SizedBox(height: 20),
            PasswordStrengthChecker(
              strength: passNotifier,
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Container(
                child: TextFieldWidget(
              controller: _confirmPasswordController,
              onchange: (value) {
                isComplete(controllers: [
                  _usernameController,
                  _passwordController,
                  _nameController,
                  _confirmPasswordController,
                  _purokController,
                  _barangayController,
                  _emailController,
                ], images: [
                  _profileImage,
                  _IDImage,
                  _licenseImage,
                ]);
              },
              hinttext: "Confirm Password",
              obscured: true,
            )),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  child: IconButton(
                    icon: _licenseImage ??
                        Image.asset('assets/icons/drivers_license.jpg'),
                    iconSize: 50,
                    onPressed: () async {
                      _pickedLicenseFile = await ImagePickerAndroid()
                          .pickImage(source: ImageSource.gallery);
                      _licenseImage =
                          Image.memory(await _pickedLicenseFile!.readAsBytes());
                      user_data["drivers_license_image"] =
                          await StorageMethods().uploadLicensePic(
                              await _pickedLicenseFile!.readAsBytes());
                      print(_profileImage);
                      isComplete(controllers: [
                        _usernameController,
                        _passwordController,
                        _nameController,
                        _confirmPasswordController,
                        _purokController,
                        _barangayController,
                        _emailController,
                      ], images: [
                        _profileImage,
                        _IDImage,
                        _licenseImage,
                      ]);
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                ),
                Container(
                  height: 100,
                  child: IconButton(
                    icon: _IDImage ?? Image.asset('assets/icons/id.png'),
                    iconSize: 50,
                    onPressed: () async {
                      _pickedIDFile = await ImagePickerAndroid()
                          .pickImage(source: ImageSource.gallery);
                      _IDImage =
                          Image.memory(await _pickedIDFile!.readAsBytes());

                      user_data["valid_id_image"] = await StorageMethods()
                          .uploadIDPic(await _pickedIDFile!.readAsBytes());
                      isComplete(controllers: [
                        _usernameController,
                        _nameController,
                        _passwordController,
                        _confirmPasswordController,
                        _purokController,
                        _barangayController,
                        _emailController,
                      ], images: [
                        _profileImage,
                        _IDImage,
                        _licenseImage,
                      ]);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            TextButton(
                onPressed: () async {
                  if (checkPassword()) {
                    //Sign up details are complete.

                    user_data["name"] = _nameController.text;
                    user_data["username"] = _usernameController.text;
                    user_data["password"] = _passwordController.text;
                    user_data["purok"] = _purokController.text;
                    user_data["email"] = _emailController.text;
                    user_data["barangay"] = _barangayController.text;
                    user_data["status"] = "pending";
                    FirestoreMethods().addSignup(user_data);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Success'),
                        content: const Text(
                            'Your application is under review. Please wait for the confirmation. It will be sent to your email within 2 business days.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              return Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ).then((value) {
                      Navigator.of(context).pop();
                    });
                  } else {
                    signupMessage = "Passwords do not match!";
                    setState(() {});
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(
                            style: BorderStyle.solid, color: Colors.white)),
                    color:
                        !_completelyFilled ? Colors.transparent : Colors.white,
                  ),
                  child: Text(
                    !_completelyFilled
                        ? signupMessage
                        : "All set! you're ready to register!",
                    style: !_completelyFilled
                        ? defaultTextStyle.copyWith(fontSize: 18)
                        : defaultTextStyle.copyWith(
                            color: Colors.green, fontSize: 18),
                  ),
                )),
            Padding(padding: EdgeInsets.symmetric(vertical: 10))
          ],
        ),
      ),
    );
  }
}
