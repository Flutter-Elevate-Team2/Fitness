import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final String title;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..loadRequest(Uri.parse(url));

    return SharedScaffold(
      title: Text(title),
      body: WebViewWidget(controller: controller),
    );
  }
}