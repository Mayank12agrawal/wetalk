import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:provider/provider.dart";
// import "package:firebase_auth/firebase_auth.dart";
import '../../provider/user_provider.dart';
import "message_bubble.dart";

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<String> userId = Provider.of<UserProvider>(context).getUserId();

    return FutureBuilder(
      future: userId,
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, chatSnapShot) {
              if (chatSnapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                reverse: true,
                itemBuilder: (ctx, index) {
                  return MessageBubble(
                    chatSnapShot.data.documents[index]['text'],
                    chatSnapShot.data.documents[index]['userId'] ==
                        snapShot.data,
                    chatSnapShot.data.documents[index]['userName'],
                    chatSnapShot.data.documents[index]['userimage'],
                    key:
                        ValueKey(chatSnapShot.data.documents[index].documentID),
                  );
                },
                itemCount: chatSnapShot.data.documents.length,
              );
            });
      },
    );
  }
}
