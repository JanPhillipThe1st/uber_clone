import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uber_driver/ui/pick_up.dart';
import 'package:uber_driver/utils/app_info.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';

class ChatUser extends StatefulWidget {
  const ChatUser({Key? key, required this.tripID, required this.tripDetails})
      : super(key: key);
  final String tripID;
  final Map<String, dynamic> tripDetails;
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatUser> {
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> requestListener =
      Stream.empty();
  void _addMessage(types.Message message) {
    db.collection("messages").add(message.toJson());
    // setState(() {
    //   _messages.add(message);
    // });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      Reference ref = _storage.ref("chat_images/" + Uuid().v4());
      UploadTask task = ref.putData(
          bytes,
          SettableMetadata(
            contentType: "image/jpeg",
          ));
      task.then((p0) async {
        final message = types.ImageMessage(
          author: _user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: const Uuid().v4(),
          name: result.name,
          size: bytes.length,
          uri: await ref.getDownloadURL(),
          width: image.width.toDouble(),
        );

        _addMessage(message);
      });
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);
  }

  void _loadMessages() async {
    List<types.Message> messages = [];
    db.collection("messages").snapshots().listen((event) {
      messages = [];
      event.docs.forEach((doc) {
        messages.add(types.Message.fromJson(doc.data()));
      });
      setState(() {
        _messages = messages;
      });
    });
  }

  List<types.Message> _messages = [];
  var _user;
  @override
  Widget build(BuildContext context) {
    _user = types.User(
      firstName: widget.tripDetails["name"],
      id: '82091008-a484-4a89-ae75-a22bf8d6f3de',
    );

    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Chat(
              messages: _messages,
              onAttachmentPressed: _handleAttachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              user: _user,
            ),
            flex: 14,
          ),
          Expanded(
            child: TextButton(
                onPressed: () async {
                  await db
                      .collection("requests")
                      .doc(widget.tripID)
                      .update({"date_confirmed": DateTime.now()});
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PickUp(
                          tripID: widget.tripID,
                          tripDetails: widget.tripDetails)));
                },
                child: Container(
                  decoration: ShapeDecoration(
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                  width: double.maxFinite,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "Accept",
                    textAlign: TextAlign.center,
                    style: defaultStyle.copyWith(color: Colors.white),
                  ),
                )),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
