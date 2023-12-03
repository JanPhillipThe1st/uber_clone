import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  FirebaseStorage storage = FirebaseStorage.instance;
  StorageMethods() {
    storage = FirebaseStorage.instance;
  }
  Future<String> uploadProfilePic(Uint8List file) async {
    UploadTask task = storage
        .ref()
        .child("profile_pictures/" + Uuid().v1())
        .putData(file, SettableMetadata(contentType: "image/jpeg"));
    String downloadURL =
        await (await task.whenComplete(() => null)).ref.getDownloadURL();
    print(downloadURL);
    return downloadURL;
  }

  Future<String> uploadIDPic(Uint8List file) async {
    UploadTask task = storage
        .ref()
        .child("ids/" + Uuid().v1())
        .putData(file, SettableMetadata(contentType: "image/jpeg"));
    String downloadURL =
        await (await task.whenComplete(() => null)).ref.getDownloadURL();
    print(downloadURL);
    return downloadURL;
  }

  Future<String> uploadLicensePic(Uint8List file) async {
    UploadTask task = storage
        .ref()
        .child("licenses/" + Uuid().v1())
        .putData(file, SettableMetadata(contentType: "image/jpeg"));
    String downloadURL =
        await (await task.whenComplete(() => null)).ref.getDownloadURL();
    print(downloadURL);
    return downloadURL;
  }
}
