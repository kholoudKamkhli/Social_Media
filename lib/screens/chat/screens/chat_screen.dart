import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../main.dart';
import '../api/apis.dart';
import '../helper/my_date_util.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all messages
  List<Message> _list = [];

  //for handling message text changes
  final _textController = TextEditingController();

  //showEmoji -- for storing value of showing or hiding emoji
  //isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    print('000000000000000000000');
    print(widget.user.id);
    print(widget.user.email);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if emojis are shown & back button is pressed then hide emojis
          //or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() => _showEmoji = !_showEmoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xfffe92f30),
            //app bar
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xfffe92f30),
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
              actions: [
                IconButton(
                    onPressed: () {
                      showDialog(
                        barrierColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xfffe92f30),
                            title: Image.asset(
                              'assets/images/logo_text.png',
                              height: 50,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Are You Sure to Block This User'),
                                const SizedBox(
                                  height: 16,
                                ),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.user.id)
                                        .snapshots(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        Map userData =
                                            snapshot.data.data() as Map;
                                        print(
                                            ';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
                                        print(userData['blocked'].contains(
                                            FirebaseAuth
                                                .instance.currentUser!.uid));
                                        if (userData['blocked'].contains(
                                            FirebaseAuth
                                                .instance.currentUser!.uid)) {
                                          return InkWell(
                                            onTap: () async {
                                              List usersBloced =
                                                  userData['blocked'];
                                              usersBloced.remove(FirebaseAuth
                                                  .instance.currentUser!.uid);
                                              Navigator.pop(context);
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(widget.user.id)
                                                  .set(
                                                {'blocked': usersBloced},
                                                SetOptions(merge: true),
                                              );
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                decoration:
                                                    const ShapeDecoration(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Color(0xffE4B16C),
                                                    Color(0xffDE5D76),
                                                  ]),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'UnBlock',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 20),
                                                )),
                                          );
                                        } else {
                                          return InkWell(
                                            onTap: () async {
                                              Navigator.pop(context);
                                              String? currentUser = FirebaseAuth
                                                  .instance.currentUser?.uid;
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(widget.user.id)
                                                  .set(
                                                {
                                                  'blocked': [currentUser]
                                                },
                                                SetOptions(merge: true),
                                              );
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                decoration:
                                                    const ShapeDecoration(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Color(0xffE4B16C),
                                                    Color(0xffDE5D76),
                                                  ]),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Block',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 20),
                                                )),
                                          );
                                        }
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    })
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.more_vert_sharp,
                      color: Colors.white,
                    ))
              ],
            ),

            //body
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: APIs.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();

                          //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _list = data
                                    ?.map((e) => Message.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  reverse: true,
                                  itemCount: _list.length,
                                  padding:
                                      EdgeInsets.only(top: mq.height * .01),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return MessageCard(message: _list[index]);
                                  });
                            } else {
                              return const Center(
                                child: Text('Say Hii! 👋',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black)),
                              );
                            }
                        }
                      },
                    ),
                  ),

                  //progress indicator for showing uploading
                  if (_isUploading)
                    const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: CircularProgressIndicator(strokeWidth: 2))),

                  //chat input filed
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          Map data = snapshot.data.data() as Map;
                          print('.....................................');
                          print(data['blocked'].contains(widget.user.id));
                          if (data['blocked'].contains(widget.user.id)) {
                            return const Text(
                              'You Are Blocked By This User',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800),
                            );
                          } else {
                            return _chatInput();
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),

                  //show emojis on keyboard emoji button click & vice versa
                  if (_showEmoji)
                    SizedBox(
                      height: mq.height * .35,
                      child: EmojiPicker(
                        textEditingController: _textController,
                        config: Config(

                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return InkWell(
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              return Row(
                children: [
                  //back button
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          const Icon(Icons.arrow_back, color: Colors.black54)),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .03),
                    child: CachedNetworkImage(
                      width: mq.height * .05,
                      height: mq.height * .05,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  //for adding some space
                  const SizedBox(width: 10),

                  //user name & last seen time
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //user name
                      Text(list.isNotEmpty ? list[0].name : widget.user.name,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500)),

                      //for adding some space
                      const SizedBox(height: 2),

                      //last seen time of user
                      Text(
                          list.isNotEmpty
                              ? list[0].isOnline
                                  ? 'Online'
                                  : MyDateUtil.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].lastActive)
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: widget.user.lastActive),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                ],
              );
            }));
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Color(0xfffe92f30), size: 30)),

                  Expanded(
                      child: TextFormField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: Colors.black),
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Picking multiple images
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);

                        // uploading & sending image one by one
                        for (var i in images) {
                          log('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.image,
                          color: Color(0xfffe92f30), size: 30)),

                  //take image from camera button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);

                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Color(0xfffe92f30), size: 30)),

                  //adding some space
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  //simply send message
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.white,
            child: Icon(Icons.send,
                color: Theme.of(context).primaryColor, size: 28),
          )
        ],
      ),
    );
  }
}
