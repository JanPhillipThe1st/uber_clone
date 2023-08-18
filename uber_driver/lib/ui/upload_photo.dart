import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_photo_editor/flutter_photo_editor.dart';
import 'package:image_picker_android/image_picker_android.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({key, required this.photo_name, required this.photo_file});
  final String photo_name;
  final PickedFile photo_file;
  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  Image? imageWidget;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageAsWidget();
  }

  Future<void> getImageAsWidget() async {
    Uint8List fileAsList = await widget.photo_file.readAsBytes();
    imageWidget = Image.memory(fileAsList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload ${widget.photo_name}"),
      ),
      body: Container(
        width: double.maxFinite,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Color.fromARGB(95, 199, 199, 199)),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Positioned(
                      child: imageWidget == null
                          ? Text("Loading Image...")
                          : imageWidget!,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        decoration: ShapeDecoration(
                            shadows: [
                              BoxShadow(
                                  color: Color.fromARGB(197, 211, 86, 211),
                                  offset: Offset(0, 3),
                                  blurRadius: 5),
                              BoxShadow(
                                  color: Color.fromARGB(197, 118, 144, 247),
                                  offset: Offset(0, -3),
                                  blurRadius: 5),
                            ],
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color.fromARGB(255, 197, 141, 228),
                                  Color.fromARGB(255, 147, 174, 255)
                                ]),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        child: IconButton(
                            color: Color.fromARGB(198, 23, 69, 97),
                            onPressed: () async {
                              FlutterPhotoEditor editor = FlutterPhotoEditor();
                              await editor.editImage(widget.photo_file.path);
                              getImageAsWidget();
                            },
                            icon: Icon(Icons.edit)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: ShapeDecoration(
                        shadows: [
                          BoxShadow(
                              color: Color.fromARGB(197, 211, 86, 86),
                              offset: Offset(0, 3),
                              blurRadius: 5),
                          BoxShadow(
                              color: Color.fromARGB(197, 247, 118, 193),
                              offset: Offset(0, -3),
                              blurRadius: 5),
                        ],
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color.fromARGB(255, 248, 130, 130),
                              Color.fromARGB(255, 228, 141, 152),
                            ]),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: IconButton(
                        splashRadius: 200,
                        color: Color.fromARGB(198, 23, 69, 97),
                        onPressed: () async {},
                        icon: Icon(Icons.delete)),
                  ),
                  Container(
                    height: 70,
                    width: 70,
                    decoration: ShapeDecoration(
                        shadows: [
                          BoxShadow(
                              color: Color.fromARGB(197, 94, 211, 86),
                              offset: Offset(0, 3),
                              blurRadius: 5),
                          BoxShadow(
                              color: Color.fromARGB(197, 213, 247, 118),
                              offset: Offset(0, -3),
                              blurRadius: 5),
                        ],
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color.fromARGB(255, 152, 215, 127),
                              Color.fromARGB(255, 177, 228, 141),
                            ]),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: IconButton(
                        splashRadius: 200,
                        color: Color.fromARGB(198, 23, 69, 97),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.check)),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
