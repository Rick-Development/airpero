import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes/routes.dart';
import '../views/website_viewer.dart';

class FloatingChatWidget extends StatefulWidget {
  @override
  _FloatingChatWidgetState createState() => _FloatingChatWidgetState();
}

class _FloatingChatWidgetState extends State<FloatingChatWidget> {
  // Initial position of the floating widget
  double xPosition = 20;
  double yPosition = 100;

  // Tawk.to chat URL
  final String tawkToChatUrl = 'https://tawk.to/chat/66e7f17b50c10f7a00aab067/1i7t0ejf3';

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width ,
          child: WebsiteViewer(url: WebRoutes.tawktoLink,title: "",)
      );
  }

  // Build the chat widget
  Widget chatWidget() {
    return GestureDetector(
      onTap: _openTawkToChat,  // Open the Tawk.to chat on tap
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
        ),
        child: Icon(
          Icons.chat,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  // Method to open the Tawk.to chat URL
  Future<void> _openTawkToChat() async {
    if (await canLaunch(tawkToChatUrl)) {
      await launch(tawkToChatUrl);
    } else {
      throw 'Could not launch $tawkToChatUrl';
    }
  }
}
