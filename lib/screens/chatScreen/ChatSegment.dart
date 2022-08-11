import 'dart:async';
import 'dart:io';

import 'package:HFM/Consts.dart';
import 'package:HFM/models/user.dart';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/chatScreen/DeleteMessageDialog.dart';
import 'package:HFM/screens/chatScreen/ShowImage.dart';
import 'package:HFM/themes/colors.dart';
import 'package:HFM/utils/Communication.dart';
import 'package:HFM/utils/Utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatSegment extends StatefulWidget {
  final String id;
  final String groupId;
  final String friendId;

  const ChatSegment(
      {Key? key,
      required this.groupId,
      required this.id,
      required this.friendId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatSegmentState();
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;
var _repository = Repository();
late User _user;

class ChatSegmentState extends State<ChatSegment> {
  // dash chat variables
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  late ChatUser user;

  // final ChatUser otherUser = ChatUser(
  //   name: "Mrfatty",
  //   uid: "25649654",
  // );

  List<ChatMessage> messages = [];
  var m = [];

  var i = 0;

  @override
  void initState() {
    _retrieve();
    super.initState();
  }

  _retrieve() async {
    auth.User currentUser = await _repository.getCurrentUser();
    User user_ = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      _user = user_;
      user = ChatUser(
        name: _user.name,
        uid: _user.uid,
        avatar: _user.profileImage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/images/adinkra_pattern.png'),
          //     fit: BoxFit.cover,
          //   )
          // ),
          height: MediaQuery.of(context).size.height / 1.1,
          child: StreamBuilder(
            stream: _firestore
                .collection(MESSAGES_COLLECTION) //Messages
                .doc(widget.groupId) //this groupId
                .collection(widget.groupId) //their collection of messages
                .orderBy(MESSAGE_TIMESTAMP,
                    descending: false) // order messages by time
                .snapshots(),
            // stream: Firestore.instance.collection('messages').snapshots(),
            builder: (BuildContext buildContext,
                AsyncSnapshot<QuerySnapshot> snapshots) {
              //show error if there is any
              if (snapshots.hasError) return Text(snapshots.error.toString());
              //if connecting show progressIndicator
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                List<DocumentSnapshot> items = snapshots.data!.docs;
                var messages = items
                    .map((i) => ChatMessage.fromJson(i["content"]))
                    .toList();
                // return ListView.builder(
                //   reverse: true,
                //   itemCount: snapshots.data.documents.length,
                //   itemBuilder: (context, index) {
                //     return _buildMessage(
                //         snapshots.data.documents[index], id, widget.groupId);
                //   },
                // );

                /// dash chat
                return DashChat(
                    key: _chatViewKey,
                    inverted: false,
                    onSend: onSend,
                    sendOnEnter: true,
                    textInputAction: TextInputAction.send,
                    user: user,
                    inputDecoration: const InputDecoration.collapsed(
                        hintText: "Type a message",
                        hintStyle: TextStyle(color: Colors.white54)),
                    // dateFormat: DateFormat('yyyy-MMM-dd'),
                    dateFormat: DateFormat.yMMMMd(),
                    timeFormat: DateFormat('HH:mm'),
                    messages: messages,
                    showUserAvatar: false,
                    showAvatarForEveryMessage: false,
                    scrollToBottom: true,
                    onPressAvatar: (ChatUser user) {
                      print("OnPressAvatar: ${user.name}");
                    },
                    onLongPressAvatar: (ChatUser user) {
                      print("OnLongPressAvatar: ${user.name}");
                    },
                    inputMaxLines: 5,
                    messageContainerPadding:
                        const EdgeInsets.only(left: 5.0, right: 5.0),
                    alwaysShowSend: false,
                    inputTextStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    inputContainerStyle: BoxDecoration(
                      border: Border.all(width: 0.0),
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: Colors.grey[800],
                    ),
                    onQuickReply: (Reply reply) {
                      setState(() {
                        messages.add(ChatMessage(
                            text: reply.value,
                            createdAt: DateTime.now(),
                            user: user));

                        messages = [...messages];
                      });

                      Timer(const Duration(milliseconds: 300), () {
                        _chatViewKey.currentState!.scrollController.animateTo(
                          _chatViewKey.currentState!.scrollController.position
                              .maxScrollExtent,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );

                        if (i == 0) {
                          systemMessage();
                          Timer(const Duration(milliseconds: 600), () {
                            systemMessage();
                          });
                        } else {
                          systemMessage();
                        }
                      });
                    },
                    onLoadEarlier: () {
                      print("loading...");
                    },
                    shouldShowLoadEarlier: false,
                    showTraillingBeforeSend: true,
                    trailing: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.photo,
                          color: colorTheme.primaryColor,
                        ),
                        onPressed: () async {
                          File result = (await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                            maxHeight: 400,
                            maxWidth: 400,
                          )) as File;

                          if (result != null) {
                            final Reference storageRef = FirebaseStorage
                                .instance
                                .ref()
                                .child("chat_images");

                            UploadTask uploadTask = storageRef.putFile(
                              result,
                              SettableMetadata(
                                contentType: 'image/jpg',
                              ),
                            );
                            TaskSnapshot download = await uploadTask;

                            String url = await download.ref.getDownloadURL();

                            ChatMessage message =
                                ChatMessage(text: "", user: user, image: url);

                            var documentReference = FirebaseFirestore.instance
                                .collection('messages')
                                .doc(DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString());

                            FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                              await transaction.set(
                                documentReference,
                                message.toJson(),
                              );
                            });
                          }
                        },
                      )
                    ],
                    textCapitalization: TextCapitalization.sentences,
                    sendButtonBuilder: (function) {
                      return _sendButtonBuilder(function);
                    });
              }
            },
          )),
    );
  }

  _sendButtonBuilder(Function onSend) {
    return IconButton(
        icon: Icon(
          Icons.send,
          color: colorTheme.primaryColorDark,
        ),
        onPressed: () => onSend);
  }

  Widget _buildMessage(DocumentSnapshot snapshot, String id, String groupId) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: snapshot[MESSAGE_ID_FROM] == id
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7, //MESSAGE_WIDTH,
                height: snapshot[MESSAGE_TYPE] == MESSAGE_TYPE_PHOTO
                    ? MediaQuery.of(context).size.width * 0.7
                    : null,
                padding: const EdgeInsets.all(MESSAGE_PADDING),
                margin: const EdgeInsets.only(
                    right: MESSAGE_MARGIN,
                    top: 5,
                    bottom: 3,
                    left: MESSAGE_MARGIN),
                decoration: BoxDecoration(
                    color: snapshot[MESSAGE_ID_FROM] == id
                        ? colorTheme.accentColor
                        : Colors.black45,
                    borderRadius: BorderRadius.circular(MESSAGE_RADIUS)),
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: snapshot[MESSAGE_TYPE] == MESSAGE_TYPE_PHOTO
                            ? AspectRatio(
                                aspectRatio: 1.1,
                                child: Hero(
                                  tag: snapshot[MESSAGE_TIMESTAMP],
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      alignment: FractionalOffset.center,
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        snapshot[MESSAGE_CONTENT],
                                      ),
                                    )),
                                  ),
                                ),
                              )
                            : snapshot[MESSAGE_TYPE] == MESSAGE_TYPE_TEXT
                                ? AutoSizeText(
                                    snapshot[MESSAGE_CONTENT],
                                    style: const TextStyle(
                                        fontSize: MESSAGE_FONT_SIZE,
                                        color: MESSAGE_FONT_COLOR),
                                  )
                                : const Text('sticker')),
                    Container(
                      margin: const EdgeInsets.all(4.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          timeConverter(int.parse(snapshot[MESSAGE_TIMESTAMP])),
                          style: const TextStyle(
                              fontSize: MESSAGE_DATE_FONT_SIZE,
                              color: MESSAGE_FONT_COLOR),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
      onLongPress: () => _showDeleteMessageDialog(snapshot),
      onTap: () => snapshot[MESSAGE_TYPE] == MESSAGE_TYPE_PHOTO
          ? _showImage(snapshot[MESSAGE_CONTENT], snapshot[MESSAGE_TIMESTAMP])
          : null,
    );
  }

  _showDeleteMessageDialog(DocumentSnapshot snapshot) {
    if (snapshot[MESSAGE_ID_FROM] == widget.id) {
      showDialog(
          context: context,
          builder: (context) {
            return DeleteMessageDialog(
                groupId: widget.groupId,
                timestamp: snapshot[MESSAGE_TIMESTAMP]);
          });
    }
  }

  _showImage(String imageUrl, String tag) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ShowImage(
              imageUrl: imageUrl,
              tag: tag,
            )));
  }

  // _sendMessage() {
  //   sendMessage(_textEditingController.value.text, groupId, id, friendId);
  //   _textEditingController.clear();
  // }

  void onSend(ChatMessage message) {
    print(message.toJson());

    sendMessage(message, widget.groupId, widget.id, widget.friendId, context);

    // var documentReference = Firestore.instance
    //     .collection('messages')
    //     .document(DateTime.now().millisecondsSinceEpoch.toString());

    // Firestore.instance.runTransaction((transaction) async {
    //   await transaction.set(
    //     documentReference,
    //     message.toJson(),
    //   );
    // });
  }

  void systemMessage() {
    Timer(const Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(const Duration(milliseconds: 300), () {
        _chatViewKey.currentState!.scrollController
          ..animateTo(
            _chatViewKey
                .currentState!.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }
}

// @widget
// Widget buildSendButton(BuildContext context) {
//   return Icon(Icons.send);
// }
