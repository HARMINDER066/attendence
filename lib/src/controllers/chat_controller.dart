import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/chat.dart';
import '../models/conversation.dart';
import '../repository/chat_repository.dart';
import '../repository/notification_repository.dart';
import '../repository/user_repository.dart';

class ChatController extends ControllerMVC {
  Conversation conversation;
  ChatRepository _chatRepository;
  Stream<QuerySnapshot> conversations;
  Stream<QuerySnapshot> chats;
  GlobalKey<ScaffoldState> scaffoldKey;
  File imageFile;
  bool uploading;
  final chatTextController = TextEditingController();

  ChatController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _chatRepository = new ChatRepository();
//    _createConversation();
  }

  signIn() {
    //_chatRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
//    _chatRepository.signInWithToken(currentUser.value.apiToken);
  }

  createConversation(Conversation _conversation) async {
    _conversation.users.insert(0, currentUser.value);
    _conversation.lastMessageTime = DateTime.now().toUtc().millisecondsSinceEpoch;
    _conversation.readByUsers = [currentUser.value.id];
    setState(() {
      conversation = _conversation;
    });
    _chatRepository.createConversation(conversation).then((value) {
      listenForChats(conversation);
    });
  }

  listenForConversations() async {
    _chatRepository.getUserConversations(currentUser.value.id).then((snapshots) {
      setState(() {
        conversations = snapshots;
      });
    });
  }

  listenForChats(Conversation _conversation) async {
    _conversation.readByUsers.add(currentUser.value.id);
    _chatRepository.getChats(_conversation).then((snapshots) {
      setState(() {
        chats = snapshots;
        //chats.
      });
    });
  }

  addMessage(Conversation _conversation, String text) {
    Chat _chat = new Chat(text, DateTime.now().toUtc().millisecondsSinceEpoch, currentUser.value.id);
    if (_conversation.id == null) {
      _conversation.id = UniqueKey().toString();
      createConversation(_conversation);
    }
    _conversation.lastMessage = text;
    _conversation.lastMessageTime = _chat.time;
    _conversation.readByUsers = [currentUser.value.id];
    _chatRepository.addMessage(_conversation, _chat).then((value) {
      _conversation.users.forEach((_user) {
        if (_user.id != currentUser.value.id) {
          sendNotification(text, S.of(state.context).newMessageFrom + " " + currentUser.value.name, _user);
        }
      });
    });
  }

  orderSnapshotByTime(AsyncSnapshot snapshot) {
    final docs = snapshot.data.documents;
    docs.sort((QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
      var time1 = a.get('time');
      var time2 = b.get('time');
      return time2.compareTo(time1) as int;
    });
    return docs;
  }

  Future getImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: source);
    setState(() {
      imageFile = File(pickedFile.path);
    });


    if (imageFile != null) {
      try {
        uploading = true;
        return await _chatRepository.uploadFile(imageFile);

      } catch (e) {

        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    } else {
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).please_select_an_image_file),

      ));


    }
  }
}
