import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _webViewController;
  List<String> _visitedUrls = [];
  bool _isMinimized = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_visitedUrls.isNotEmpty) {
          if (_webViewController != null && await _webViewController.canGoBack()) {
            _webViewController.goBack();
            _visitedUrls.removeLast();
            return false; // Prevent default back behavior
          }
        }
        if (!_isMinimized) {
          SystemNavigator.pop(); // Minimize the app if no route is available
          _isMinimized = true;
          return false; // Prevent default back behavior
        }
        return false; // Let the default back behavior execute
      },
      child: Scaffold(
        backgroundColor: Colors.transparent, // Set Scaffold background to transparent
        body: SafeArea(
          child: WebView(
            initialUrl: 'https://zanechat.vercel.app', // Replace with your Next.js app URL
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
            onPageFinished: (String url) {
              setState(() {
                _visitedUrls.add(url);
                _isMinimized = false;
              });
            },
          ),
        ),
      ),
    );
  }
}
