import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

/// A WebView HTML renderer that properly handles scrolling within scrollable containers.
/// This widget prevents the parent scroll from interfering with WebView scrolling.
class ScrollableWebViewRenderer extends StatefulWidget {
  final String htmlContent;
  final double? height;
  final EdgeInsets? padding;

  const ScrollableWebViewRenderer({
    Key? key,
    required this.htmlContent,
    this.height,
    this.padding,
  }) : super(key: key);

  @override
  State<ScrollableWebViewRenderer> createState() =>
      _ScrollableWebViewRendererState();
}

class _ScrollableWebViewRendererState extends State<ScrollableWebViewRenderer> {
  bool _isLoading = true;
  Timer? _loadingTimer;
  double _contentHeight = 300; // Default height, will be calculated dynamically

  @override
  void initState() {
    super.initState();
    // Set a timeout to prevent infinite loading
    _loadingTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? _contentHeight, // Auto height based on content
      padding: widget.padding,
      child: Stack(
        children: [
          InAppWebView(
            initialData: InAppWebViewInitialData(
              data: _buildHtml(),
              mimeType: 'text/html',
              encoding: 'utf8',
            ),
            initialSettings: InAppWebViewSettings(
              // Basic settings
              supportZoom: false,
              displayZoomControls: false,

              // Enable scrollbars and scrolling - prioritize horizontal scrolling
              horizontalScrollBarEnabled: true,
              verticalScrollBarEnabled: true,

              // Disable context menu
              disableContextMenu: true,
              disableHorizontalScroll:
                  false, // Ensure horizontal scroll is enabled
              disableVerticalScroll: false,

              // Performance settings
              cacheEnabled: true,
              clearCache: false,
              hardwareAcceleration: true,

              // Disable unnecessary features
              useOnDownloadStart: false,
              useOnLoadResource: false,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: false,
              allowsBackForwardNavigationGestures: false,
              allowsLinkPreview: false,

              // Enable JS for height calculation
              javaScriptEnabled: true,
              domStorageEnabled: false,
              databaseEnabled: false,
              geolocationEnabled: false,

              // Scroll settings - make scrollbars visible and improve touch handling
              scrollBarStyle: ScrollBarStyle.SCROLLBARS_OUTSIDE_OVERLAY,

              // Improve touch handling for better scrolling
              useWideViewPort: true,
              loadWithOverviewMode: true,
            ),
            onLoadStart: (controller, url) {
              debugPrint('ScrollableWebView loading started');
            },
            onLoadStop: (controller, url) async {
              debugPrint('ScrollableWebView loading stopped');
              _loadingTimer?.cancel();

              // Wait a bit for content to fully render
              await Future.delayed(const Duration(milliseconds: 500));

              // Try to calculate content height
              for (int attempt = 0; attempt < 3; attempt++) {
                try {
                  await Future.delayed(
                    Duration(milliseconds: 200 * (attempt + 1)),
                  );

                  final height = await controller.evaluateJavascript(
                    source: """
                      Math.max(
                        document.body.scrollHeight,
                        document.body.offsetHeight,
                        document.documentElement.scrollHeight,
                        document.documentElement.offsetHeight
                      );
                    """,
                  );

                  if (height != null && mounted) {
                    final calculatedHeight = (height as num).toDouble();
                    if (calculatedHeight > 0) {
                      setState(() {
                        _contentHeight =
                            calculatedHeight + 50; // Add some padding
                        _isLoading = false;
                      });
                      debugPrint(
                        'ScrollableWebView: Using calculated height: ${calculatedHeight + 50}',
                      );
                      return;
                    }
                  }
                } catch (e) {
                  debugPrint(
                    'Error calculating height (attempt ${attempt + 1}): $e',
                  );
                }
              }

              // Fallback: Use a reasonable default height
              if (mounted) {
                setState(() {
                  _contentHeight = 400; // Fallback height
                  _isLoading = false;
                });
                debugPrint('ScrollableWebView: Using fallback height: 400');
              }
            },
            onReceivedError: (controller, request, error) {
              debugPrint('ScrollableWebView Error: $error');
              _loadingTimer?.cancel();
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading content...'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _buildHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
    <style>
        html, body {
            margin: 0;
            padding: 16px;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            font-size: 14px;
            line-height: 1.5;
            color: #333;
            background-color: #fff;
            overflow-x: auto; /* Enable horizontal scrolling */
            overflow-y: auto; /* Enable vertical scrolling */
            height: 100%;
            min-height: 100%;
            box-sizing: border-box;
            /* Improve touch scrolling */
            -webkit-overflow-scrolling: touch;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
            font-size: 12px;
            min-width: 100%;
            table-layout: auto;
        }
        td, th {
            border: 1px solid #ddd;
            padding: 6px 8px;
            text-align: left;
            vertical-align: top;
            word-wrap: break-word;
        }
        th {
            background-color: #f5f5f5;
            font-weight: bold;
            text-align: center;
        }
        img {
            max-width: 100%;
            height: auto;
            display: block;
            margin: 8px 0;
        }
        p {
            margin: 2px 0;
            line-height: 1.3;
        }
        * {
            box-sizing: border-box;
        }
    </style>
</head>
<body>
    ${widget.htmlContent}
</body>
</html>
''';
  }
}

/// Helper function to create a scrollable WebView HTML renderer
Widget buildScrollableWebViewHtml(
  String data, {
  Map<String, String>? customStyles,
  double? height,
  EdgeInsets? padding,
}) {
  if (data.trim().isEmpty) {
    return const SizedBox.shrink();
  }

  return ScrollableWebViewRenderer(
    htmlContent: data,
    height: height,
    padding: padding,
  );
}
