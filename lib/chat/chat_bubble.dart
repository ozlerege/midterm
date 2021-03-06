import "package:flutter/material.dart";

class ChatBubble extends StatelessWidget {
  ChatBubble(this.message,this.isCurrentUser,this.key);
  final String message;
  final bool isCurrentUser;
  final Key key;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isCurrentUser? Colors.red : Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: !isCurrentUser ? Radius.circular(0) : Radius.circular(12),
              bottomRight: isCurrentUser ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
