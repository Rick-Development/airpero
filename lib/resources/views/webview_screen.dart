import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String redirectUrl;

  const WebViewScreen({Key? key, required this.redirectUrl}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    // WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Redirect Page"),
      ),
      body: Stack(
        children: [
          // WebView(
          //   initialUrl: widget.redirectUrl,
          //   javascriptMode: JavascriptMode.unrestricted,
          //   onPageStarted: (String url) {
          //     setState(() {
          //       isLoading = true;
          //     });
          //   },
          //   onPageFinished: (String url) {
          //     setState(() {
          //       isLoading = false;
          //     });
          //   },
          // ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(),
        ],
      ),
    );
  }
}
