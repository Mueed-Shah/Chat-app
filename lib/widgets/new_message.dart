import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final messageController = TextEditingController();


  @override
  void dispose() {
    messageController;
    super.dispose();
  }
  void sendMessage() async{
    final enteredMessage = messageController.text;
    if(enteredMessage.isEmpty){
      return ;
    }

    // create a method to send message to the firebase

    final user = FirebaseAuth.instance.currentUser!;

    final userData =await FirebaseFirestore.instance.
    collection('users').doc(user.uid).get();

     await FirebaseFirestore.instance.collection('chat').add({
      'text' : enteredMessage,
      'createdAt' : Timestamp.now(),
      'userId' : user.uid,
      'username' : userData.data()!['user_name'],
       'userImage' : userData.data()!['image_url']
    });

    messageController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 15 , right: 1, bottom: 14),
    child:Row(
      children: [
        Expanded(child: TextField(
          controller: messageController,
          decoration: const InputDecoration(
            labelText: 'New message',
          ),
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          enableSuggestions: true,
          
        )),
        IconButton(onPressed: sendMessage, icon:const Icon(Icons.send))
      ],
    ) 
      ,);
  }
}
