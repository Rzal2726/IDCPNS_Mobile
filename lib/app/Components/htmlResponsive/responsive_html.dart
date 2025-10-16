import 'dart:convert';
import 'dart:math' as math;

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'scrollable_webview_renderer.dart';

Widget buildResponsiveHtml(
  String data, {
  Map<String, Style>? style,
}) {
  if (data.trim().isEmpty) {
    return const SizedBox.shrink();
  }

  final combinedStyle = <String, Style>{
    'body': Style(
      margin: Margins.zero,
      padding: HtmlPaddings.zero,
    ),
    'img': Style(
      display: Display.block,
      margin: Margins.only(bottom: 12),
    ),
  };

  if (style != null) {
    combinedStyle.addAll(style);
  }

  final processedHtml = _sanitizeNegativePadding(_unwrapFigureTags(data));

  return Html(
    data: processedHtml,
    style: combinedStyle,
    extensions: [
      _buildResponsiveImageExtension(),
    ],
    onCssParseError: (css, messages) {
      debugPrint('CSS Parse Error: $messages in "$css"');
      return null; // Abaikan CSS yang salah (termasuk padding negatif)
    },
  );
}

String _sanitizeNegativePadding(String html) {
  // Hapus semua padding/margin negatif seperti -99px atau -12.5pt
  return html.replaceAllMapped(
    RegExp(r'(padding|margin)[^:]*:\s*-\d+(\.\d+)?[a-z%]*;?'),
    (match) => '',
  );
}

TagExtension _buildResponsiveImageExtension() {
  return TagExtension.inline(
    tagsToExtend: {'img'},
    builder: (extensionContext) {
      final rawSrc = _resolveImageSource(extensionContext.attributes);
      final styleAttr = extensionContext.attributes['style'];
      final widthRaw = extensionContext.attributes['width'] ??
          _extractStyleValue(styleAttr, 'width');
      final heightRaw = extensionContext.attributes['height'] ??
          _extractStyleValue(styleAttr, 'height');
      final alignAttr = extensionContext.attributes['data-figure-align'] ??
          extensionContext.attributes['align'] ??
          _extractStyleValue(styleAttr, 'text-align');

      final width = _parsePixelValue(widthRaw);
      final height = _parsePixelValue(heightRaw);
      final alignment = _parseAlignment(alignAttr);
      final isFigureWrapped =
          extensionContext.attributes['data-figure-wrapper'] == 'true';
      final bool treatAsInline =
          !isFigureWrapped && alignment == Alignment.centerLeft;

      final imageWidget = _buildResponsiveImage(
        rawSrc,
        width: width,
        height: height,
        alignment: alignment,
        enforceMinWidth: !treatAsInline,
      );

      final EdgeInsets padding = treatAsInline
          ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2)
          : const EdgeInsets.symmetric(vertical: 6);

      return WidgetSpan(
        alignment: treatAsInline
            ? PlaceholderAlignment.middle
            : PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: Padding(
          padding: padding,
          child: imageWidget,
        ),
      );
    },
  );
}

Widget _buildResponsiveImage(
  String src, {
  double? width,
  double? height,
  AlignmentGeometry alignment = Alignment.centerLeft,
  bool enforceMinWidth = false,
}) {
  final cleanedSrc = src.trim();
  if (cleanedSrc.isEmpty) {
    return const SizedBox.shrink();
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      final maxWidth = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : MediaQuery.of(context).size.width;

      double targetWidth = width != null && width > 0
          ? (width > maxWidth ? maxWidth : width)
          : maxWidth;
      double? targetHeight = height;

      const double minBlockWidth = 180.0;
      // Only apply minimum width if image has no explicit width
      if (enforceMinWidth &&
          (width == null || width <= 0) &&
          targetWidth < minBlockWidth) {
        final adjustedWidth = math.min(minBlockWidth, maxWidth);
        if (targetHeight != null && targetWidth > 0) {
          final scale = adjustedWidth / targetWidth;
          targetHeight = targetHeight * scale;
        }
        targetWidth = adjustedWidth;
      }

      Uint8List? cachedBytes;
      final bool isDataImage = cleanedSrc.startsWith('data:image');
      final String networkSrc = !isDataImage && cleanedSrc.startsWith('//')
          ? 'https:' + cleanedSrc
          : cleanedSrc;

      Uint8List? decodeBase64() {
        if (!isDataImage) {
          return null;
        }
        if (cachedBytes != null) {
          return cachedBytes;
        }

        final separatorIndex = cleanedSrc.indexOf(',');
        final base64Data = separatorIndex != -1
            ? cleanedSrc.substring(separatorIndex + 1)
            : cleanedSrc;
        try {
          cachedBytes = base64Decode(base64Data);
          return cachedBytes;
        } catch (_) {
          cachedBytes = null;
          return null;
        }
      }

      Widget buildImage({
        double? renderWidth,
        double? renderHeight,
        BoxFit fit = BoxFit.contain,
        bool allowRetry = true,
      }) {
        if (isDataImage) {
          final bytes = decodeBase64();
          if (bytes == null) {
            return const Icon(Icons.broken_image, size: 24);
          }

          return Image.memory(
            bytes,
            width: renderWidth,
            height: renderHeight,
            fit: fit,
          );
        }

        if (allowRetry) {
          return _RetryableNetworkImage(
            src: networkSrc,
            width: renderWidth,
            height: renderHeight,
            fit: fit,
          );
        }

        return Image.network(
          networkSrc,
          width: renderWidth,
          height: renderHeight,
          fit: fit,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 24),
        );
      }

      Widget finalChild = ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: maxWidth,
            minHeight: enforceMinWidth ? 40 : 0,
            maxHeight: maxWidth),
        child: buildImage(
          renderWidth: targetWidth,
          renderHeight: targetHeight,
        ),
      );

      if (alignment != Alignment.centerLeft) {
        finalChild = Align(
          alignment: alignment,
          child: finalChild,
        );
      }

      final bool canPreview =
          isDataImage ? decodeBase64() != null : cleanedSrc.isNotEmpty;

      if (canPreview) {
        final screenWidth = MediaQuery.of(context).size.width;
        final previewWidth = math.min(screenWidth * 0.9, 600.0);
        double? previewHeight;
        if (targetHeight != null && targetWidth > 0) {
          final scale = previewWidth / targetWidth;
          previewHeight = targetHeight * scale;
        }

        finalChild = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showImagePreview(
            context,
            buildImage(
              renderWidth: previewWidth,
              renderHeight: previewHeight,
              allowRetry: false,
            ),
          ),
          child: finalChild,
        );
      }

      return finalChild;
    },
  );
}

void _showImagePreview(BuildContext context, Widget image) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: const Color.fromARGB(217, 255, 255, 255),
        child: Stack(
          children: [
            InteractiveViewer(
              maxScale: 5,
              minScale: 0.8,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: image,
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                tooltip: 'Tutup',
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

String _resolveImageSource(Map<String, String> attributes) {
  const candidateKeys = [
    'src',
    'data-src',
    'data-original',
    'data-lazy-src',
    'data-image',
    'data-url',
  ];

  for (final key in candidateKeys) {
    final value = attributes[key];
    if (value != null && value.trim().isNotEmpty) {
      return value;
    }
  }

  return '';
}

AlignmentGeometry _parseAlignment(String? align) {
  if (align == null) {
    return Alignment.centerLeft;
  }

  switch (align.trim().toLowerCase()) {
    case 'center':
    case 'centre':
    case 'middle':
      return Alignment.center;
    case 'right':
    case 'end':
      return Alignment.centerRight;
    case 'left':
    case 'start':
      return Alignment.centerLeft;
    default:
      return Alignment.centerLeft;
  }
}

String _unwrapFigureTags(String html) {
  if (!html.contains('<figure')) {
    return html;
  }

  try {
    final document = parse('<div id="__figure_wrapper__">' + html + '</div>');
    final wrapper = document.getElementById('__figure_wrapper__');
    if (wrapper == null) {
      return html;
    }

    final figures = List<dom.Element>.from(
      wrapper.getElementsByTagName('figure'),
    );

    for (final figure in figures) {
      final parent = figure.parent;
      if (parent == null) {
        continue;
      }

      final widthAttr = figure.attributes['width'] ??
          _extractStyleValue(figure.attributes['style'], 'width');
      final heightAttr = figure.attributes['height'] ??
          _extractStyleValue(figure.attributes['style'], 'height');
      final alignAttr = figure.attributes['align'] ??
          _extractStyleValue(figure.attributes['style'], 'text-align');

      final children = figure.nodes.toList();
      dom.Element? imageElement;
      for (final node in children) {
        if (node is dom.Element && node.localName == 'img') {
          imageElement = node;
          break;
        }
      }

      if (imageElement != null) {
        imageElement.attributes['data-figure-wrapper'] = 'true';
        if (widthAttr != null &&
            widthAttr.trim().isNotEmpty &&
            (imageElement.attributes['width'] == null ||
                imageElement.attributes['width']!.trim().isEmpty)) {
          imageElement.attributes['width'] = widthAttr;
        }

        if (heightAttr != null &&
            heightAttr.trim().isNotEmpty &&
            (imageElement.attributes['height'] == null ||
                imageElement.attributes['height']!.trim().isEmpty)) {
          imageElement.attributes['height'] = heightAttr;
        }

        if (alignAttr != null && alignAttr.trim().isNotEmpty) {
          imageElement.attributes['data-figure-align'] = alignAttr;
        }
      }

      final insertIndex = parent.nodes.indexOf(figure);
      if (insertIndex == -1) {
        figure.remove();
        continue;
      }

      parent.nodes.insertAll(insertIndex, children);
      figure.remove();
    }

    return wrapper.innerHtml;
  } catch (_) {
    return html;
  }
}

String? _extractStyleValue(String? style, String property) {
  if (style == null) return null;
  final match = RegExp('$property\\s*:\\s*([^;]+)').firstMatch(style);
  return match?.group(1);
}

double? _parsePixelValue(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed.endsWith('%')) {
    return null;
  }

  final match = RegExp(r'([0-9]+(?:\\.[0-9]+)?)').firstMatch(trimmed);
  if (match == null) return null;
  return double.tryParse(match.group(1)!);
}

class _RetryableNetworkImage extends StatefulWidget {
  const _RetryableNetworkImage({
    required this.src,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  State<_RetryableNetworkImage> createState() => _RetryableNetworkImageState();
}

class _RetryableNetworkImageState extends State<_RetryableNetworkImage> {
  int _reloadToken = 0;

  void _handleRetry() {
    setState(() {
      _reloadToken++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.src,
      key: ValueKey<int>(_reloadToken),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (_, __, ___) => _ImageErrorPlaceholder(
        width: widget.width,
        height: widget.height,
        onRetry: _handleRetry,
      ),
    );
  }
}

class _ImageErrorPlaceholder extends StatelessWidget {
  const _ImageErrorPlaceholder({
    required this.onRetry,
    this.width,
    this.height,
  });

  final VoidCallback onRetry;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasExplicitSize = width != null || height != null;

    return Container(
      width: width,
      height: height,
      constraints: hasExplicitSize
          ? null
          : const BoxConstraints(minWidth: 120, minHeight: 96),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 28, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            'Gambar gagal dimuat',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Muat ulang'),
          ),
        ],
      ),
    );
  }
}

/// Smart HTML renderer that automatically chooses between flutter_html and WebView
/// based on content complexity
Widget buildSmartHtml(
  String data, {
  Map<String, Style>? style,
  bool forceWebView = false,
  double? webViewHeight,
}) {
  if (data.trim().isEmpty) {
    return const SizedBox.shrink();
  }

  debugPrint('SmartHTML: Analyzing content...');
  debugPrint('SmartHTML: Content length: ${data.length}');
  debugPrint(
      'SmartHTML: Contains figure.table: ${data.contains('<figure class="table">')}');
  debugPrint('SmartHTML: Contains rowspan: ${data.contains('rowspan')}');
  debugPrint('SmartHTML: Contains colspan: ${data.contains('colspan')}');

  // Force WebView if requested
  if (forceWebView) {
    debugPrint('SmartHTML: Force WebView requested - using Scrollable WebView');
    return buildScrollableWebViewHtml(data, height: webViewHeight);
  }

  // Check if content has complex structures that need WebView
  if (_hasComplexContent(data)) {
    debugPrint(
        'SmartHTML: Complex content detected - using Scrollable WebView');
    return buildScrollableWebViewHtml(data, height: webViewHeight);
  }

  // Use regular flutter_html for simple content
  debugPrint('SmartHTML: Simple content - using flutter_html');
  return buildResponsiveHtml(data, style: style);
}

/// Check if HTML content contains complex structures that need WebView rendering
bool _hasComplexContent(String html) {
  final document = parse(html);

  // Check for figure.table tags (indicates complex table)
  if (_hasFigureTable(document)) {
    debugPrint('SmartHTML: Detected figure.table - using WebView');
    return true;
  }

  // Check for complex tables
  if (_hasComplexTables(document)) {
    debugPrint('SmartHTML: Detected complex table - using WebView');
    return true;
  }

  // Check for complex CSS styling
  if (_hasComplexStyling(document)) {
    debugPrint('SmartHTML: Detected complex CSS - using WebView');
    return true;
  }

  // Check for nested structures
  if (_hasNestedStructures(document)) {
    debugPrint('SmartHTML: Detected nested structures - using WebView');
    return true;
  }
  if (_hasOrderedList(document)) {
    debugPrint('SmartHTML: Detected unsupported ordered list - using WebView');
    return true;
  }

  debugPrint('SmartHTML: Simple content detected - using flutter_html');
  return false;
}

/// Check for figure.table tags which indicate complex tables
bool _hasFigureTable(dom.Document document) {
  final figures = document.querySelectorAll('figure.table');
  return figures.isNotEmpty;
}

bool _hasOrderedList(dom.Document document) {
  final list = document.getElementsByTagName('ol');
  final hasOlWithStart = list.any((ol) => ol.attributes.containsKey('start'));
  return hasOlWithStart;
}

/// Check for complex table structures
bool _hasComplexTables(dom.Document document) {
  final tables = document.getElementsByTagName('table');

  for (final table in tables) {
    // Check for rowspan or colspan
    final cellsWithSpan = table
        .querySelectorAll('td[rowspan], th[rowspan], td[colspan], th[colspan]');
    if (cellsWithSpan.isNotEmpty) {
      return true;
    }

    // Check for complex table styling
    final style = table.attributes['style'] ?? '';
    if (style.contains('border-collapse') ||
        style.contains('table-layout') ||
        style.contains('width:') ||
        style.contains('min-width:') ||
        style.contains('border-style:')) {
      return true;
    }

    // Check for cells with complex styling
    final cellsWithStyle = table.querySelectorAll('td[style], th[style]');
    for (final cell in cellsWithStyle) {
      final cellStyle = cell.attributes['style'] ?? '';
      if (cellStyle.contains('background-color') ||
          cellStyle.contains('border') ||
          cellStyle.contains('padding') ||
          cellStyle.contains('text-align') ||
          cellStyle.contains('vertical-align') ||
          cellStyle.contains('width:') ||
          cellStyle.contains('colspan') ||
          cellStyle.contains('rowspan') ||
          cellStyle.contains('border-bottom') ||
          cellStyle.contains('border-left') ||
          cellStyle.contains('border-right') ||
          cellStyle.contains('border-top')) {
        return true;
      }
    }

    // Check for nested tables
    final nestedTables = table.querySelectorAll('table');
    if (nestedTables.length > 1) {
      return true;
    }

    // Check for complex cell content (nested elements)
    final cellsWithComplexContent =
        table.querySelectorAll('td p, th p, td span, th span');
    if (cellsWithComplexContent.length > 5) {
      return true;
    }
  }

  return false;
}

/// Check for complex CSS styling
bool _hasComplexStyling(dom.Document document) {
  // Check for elements with complex inline styles
  final styledElements = document.querySelectorAll('[style]');

  for (final element in styledElements) {
    final style = element.attributes['style'] ?? '';

    // Check for complex CSS properties
    if (style.contains('position:') ||
        style.contains('float:') ||
        style.contains('display:') ||
        style.contains('flex') ||
        style.contains('grid') ||
        style.contains('transform:') ||
        style.contains('animation:') ||
        style.contains('transition:') ||
        style.contains('box-shadow:') ||
        style.contains('border-radius:') ||
        style.contains('gradient') ||
        style.contains('rgba(') ||
        style.contains('hsla(')) {
      return true;
    }
  }

  return false;
}

/// Check for nested structures that might be complex
bool _hasNestedStructures(dom.Document document) {
  // Check for deeply nested divs or spans
  final divs = document.getElementsByTagName('div');
  final spans = document.getElementsByTagName('span');

  // If there are many nested elements, it might be complex
  if (divs.length > 10 || spans.length > 20) {
    return true;
  }

  // Check for complex nested structures
  for (final div in divs) {
    final nestedDivs = div.querySelectorAll('div');
    if (nestedDivs.length > 5) {
      return true;
    }
  }

  return false;
}

/// Build HTML using scrollable WebView that prevents parent scroll interference
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
    key: ValueKey(data.hashCode),
    htmlContent: data,
    height: height,
    padding: padding,
  );
}
