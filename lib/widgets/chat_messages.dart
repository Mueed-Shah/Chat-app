import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 class Message extends StatelessWidget {
   const Message({super.key});

   @override
   Widget build(BuildContext context) {
     final authenticatedUser = FirebaseAuth.instance.currentUser!;

     return  StreamBuilder(stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt').snapshots(),
         builder: (context, chatSnapshot) {
           if(chatSnapshot.connectionState == ConnectionState.waiting){

             return const Center(
               child: CircularProgressIndicator(),
             );
           }
           if(chatSnapshot.hasError){

             return const Center(
               child: Text('An error occurred'),
             );
           }
           final enteredMessages = chatSnapshot.data!.docs;

           return ListView.builder(
               itemCount: enteredMessages.length,
               itemBuilder: (context, index) {
                 final chatMessage = enteredMessages[index].data();
                 final nextChatMessage = index + 2 < enteredMessages.length ?
                 enteredMessages[index+1].data() : null;
                 final currentMessageUserId = chatMessage['userId'];
                 final nextMessageUserId = nextChatMessage != null ? nextChatMessage['userId'] : null;
                 final nextUserIsSame = currentMessageUserId == nextMessageUserId ;

                  if(nextUserIsSame){
                    return MessageBubble.next(message: chatMessage['text'],
                        isMe:  currentMessageUserId == authenticatedUser.uid);
                  }else{

                    return MessageBubble.first(userImage: chatMessage['userImage'],
                        username: chatMessage['username'],
                        message: chatMessage['text'],
                        isMe: authenticatedUser.uid == currentMessageUserId ,);
                  }

               }

           );
         });
   }
 }
