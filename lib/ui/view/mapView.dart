import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyMapView extends StatefulWidget {
  const MyMapView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<MyMapView> createState() => _MyMapViewState();
}

class _MyMapViewState extends State<MyMapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("위치 보기"),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
