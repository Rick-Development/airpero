import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebsiteViewer extends StatefulWidget {
  final String url;
  final String title;

  WebsiteViewer({required this.url, required this.title});

  @override
  _WebsiteViewerState createState() => _WebsiteViewerState();
}

class _WebsiteViewerState extends State<WebsiteViewer> {
  late WebViewController _controller;
  bool _isLoading = true; // To track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 15),),
      ),
      body: Stack(
        children: [
          // WebView(
          //   initialUrl: widget.url,
          //   javascriptMode: JavascriptMode.unrestricted,
          //   onWebViewCreated: (WebViewController controller) {
          //     _controller = controller;
          //   },
          //   onPageStarted: (String url) {
          //     setState(() {
          //       _isLoading = true; // Show loading indicator
          //     });
          //   },
          //   onPageFinished: (String url) {
          //     setState(() {
          //       _isLoading = false; // Hide loading indicator
          //     });
          //   },
          // ),
          _isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : const SizedBox.shrink(), // Hide indicator when not loading
        ],
      ),
    );
  }
}
