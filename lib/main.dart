import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      home: WebViewWithFooter(), // Loads the main screen
    );
  }
}

// Main screen that contains the WebView and footer navigation
class WebViewWithFooter extends StatefulWidget {
  const WebViewWithFooter({super.key});

  @override
  State<WebViewWithFooter> createState() => _WebViewWithFooterState();
}

class _WebViewWithFooterState extends State<WebViewWithFooter> {
  late final WebViewController _controller;

  // External URLs
  final String projectUrl = "https://codexplo.it";
  final String githubUrl = "https://github.com/cod3xpl0it";
  final String googlePlayUrl = "https://play.google.com/store/apps/dev?id=7721607189557653684";

  @override
  void initState() {
    super.initState();
    // Initialize WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Allow JavaScript
      ..loadRequest(Uri.parse(projectUrl)); // Load initial URL
  }

  // Function to open an external URL in the system browser
  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // If the link cannot be opened, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open the link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body of the page with safe area to avoid system UI overlaps
      body: SafeArea(
        child: WebViewWidget(controller: _controller), // Display the WebView
      ),
      // Bottom navigation bar with buttons
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // GitHub button (loads inside the app WebView)
            IconButton(
              icon: const Icon(Icons.web, color: Colors.black),
              tooltip: "GitHub",
              onPressed: () {
                _controller.loadRequest(Uri.parse(projectUrl));
              },
            ),
            // Project website button (loads inside the app WebView)
            IconButton(
              icon: const Icon(Icons.code, color: Colors.black),
              tooltip: "Codexplo.it",
              onPressed: () {
                _controller.loadRequest(Uri.parse(githubUrl));
              },
            ),
            // Google Play button (opens outside the app in browser/Play Store)
            IconButton(
              icon: const Icon(Icons.shop, color: Colors.black),
              tooltip: "Google Play",
              onPressed: () {
                _openExternalUrl(googlePlayUrl);
              },
            ),
          ],
        ),
      ),
    );
  }
}
