import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:HFM/models/message.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/themes/colors.dart';
import 'package:image/image.dart' as Im;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String photoUrl;
  final String name;
  final String receiverUid;

  const ChatDetailScreen(
      {Key? key,
      required this.photoUrl,
      required this.name,
      required this.receiverUid})
      : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String senderUid;
  final TextEditingController _messageController = TextEditingController();
  final _repository = Repository();
  late String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
  late StreamSubscription<DocumentSnapshot> subscription;
  late File imageFile;

  @override
  void initState() {
    super.initState();
    print("RCID : ${widget.receiverUid}");
    _repository.getCurrentUser().then((user) {
      setState(() {
        senderUid = user.uid;
      });
      _repository.fetchUserDetailsById(senderUid).then((user) {
        setState(() {
          senderPhotoUrl = user.profileImage!;
          senderName = user.name!;
        });
      });
      _repository.fetchUserDetailsById(widget.receiverUid).then((user) {
        setState(() {
          receiverPhotoUrl = user.profileImage!;
          receiverName = user.name!;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: colorTheme.primaryColor,
          elevation: 1,
          title: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(widget.photoUrl),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.name,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Form(
          key: _formKey,
          child: senderUid.isEmpty
              ? const CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    chatMessagesListWidget(),
                    chatInputWidget(),
                    const SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
        ));
  }

  Widget chatInputWidget() {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        validator: (String? input) {
          if (input!.isEmpty) {
            return "Please enter message";
          }
        },
        controller: _messageController,
        decoration: InputDecoration(
            hintText: "Enter message...",
            labelText: "Message",
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.gradient),
                    color: Colors.black,
                    onPressed: () {
                      pickImage(source: 'Gallery');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: InkWell(
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: colorTheme.primaryColorDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        sendMessage();
                      }
                    },
                  ),
                ),
              ],
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                pickImage(source: 'Camera');
              },
              color: Colors.black,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
        onFieldSubmitted: (value) {
          _messageController.text = value;
        },
      ),
    );
  }

  Future<void> pickImage({String? source}) async {
    var selectedImage = await ImagePicker().pickImage(
        source: source == 'Gallery' ? ImageSource.gallery : ImageSource.camera);

    setState(() {
      imageFile = selectedImage as File;
    });
    compressImage();
    _repository.uploadImageToStorage(imageFile).then((url) {
      print("URL: $url");
      _repository.uploadImageMsgToDb(url, widget.receiverUid, senderUid);
    });
    return;
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image? image = Im.decodeImage(imageFile.readAsBytesSync());
    Im.copyResize(image!);

    var newim2 = File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }

  void sendMessage() {
    print("Inside send message");
    var text = _messageController.text;
    print(text);
    Message message = Message(
        receiverUid: widget.receiverUid,
        senderUid: senderUid,
        message: text,
        timestamp: FieldValue.serverTimestamp(),
        type: 'text');
    print(
        "receiverUid: ${widget.receiverUid} , senderUid : $senderUid , message: $text");
    print("timestamp: ${DateTime.now().millisecond}, type: $text");
    _repository.addMessageToDb(message, widget.receiverUid).then((v) {
      _messageController.text = "";
      print("Message added to db");
    });
  }

  Widget chatMessagesListWidget() {
    print("SENDER_UID : $senderUid");
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(senderUid)
            .collection(widget.receiverUid)
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //listItem = snapshot.data.documents;
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (context, index) => chatMessageItem(snapshot),
              // itemCount: snapshot.data[],
              itemCount: 10,
            );
          }
        },
      ),
    );
  }

  Widget chatMessageItem(AsyncSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: snapshot.data['senderUid'] == senderUid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              snapshot.data['senderUid'] == senderUid
                  ? senderLayout(snapshot)
                  : receiverLayout(snapshot)
            ],
          ),
        )
      ],
    );
  }

  Widget senderLayout(AsyncSnapshot snapshot) {
    return snapshot.data['type'] == 'text'
        ? Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(snapshot.data['message'],
                    style:
                        const TextStyle(color: Colors.black, fontSize: 16.0))),
          )
        : FadeInImage(
            fit: BoxFit.cover,
            image: NetworkImage(snapshot.data['photoUrl']),
            placeholder: const AssetImage('assets/blankimage.png'),
            width: 250.0,
            height: 300.0,
          );
  }

  Widget receiverLayout(AsyncSnapshot snapshot) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: snapshot.data['type'] == 'text'
            ? Text(snapshot.data['message'],
                style: const TextStyle(color: Colors.black, fontSize: 16.0))
            : FadeInImage(
                fit: BoxFit.cover,
                image: NetworkImage(snapshot.data['photoUrl']),
                placeholder: const AssetImage('assets/blankimage.png'),
                width: 200.0,
                height: 200.0,
              ),
      ),
    );
  }
}
