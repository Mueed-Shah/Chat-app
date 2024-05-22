import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void getAppAddress() async{
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    print('hello');
    print(token);

  }

  @override
  void initState() {
    getAppAddress();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Flutter ChatScreen'),
      actions: [IconButton(onPressed: (){
        FirebaseAuth.instance.signOut();
      }, icon: const Icon(Icons.logout))],
      ),
      body:const Column(
        children: [
          Expanded(child: Message())
          ,
          NewMessage()
        ],
      ),
    );
  }
}