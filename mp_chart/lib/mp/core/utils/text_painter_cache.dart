import 'package:flutter/material.dart';

class TextPainterCache {
  Map<String, TextPainter> textPainterCache = {};
  TextStyle textStyle = const TextStyle();

  TextPainterCache();

  void _resetCache() {
    textPainterCache = {};
  }

  void resetStyle(TextStyle ts) {
    if (ts != textStyle) {
      textStyle = ts;
      _resetCache();
    }
  }

  TextPainter get(String content) {
    return textPainterCache.putIfAbsent(content, () {
      TextPainter tpi = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(text: content, style: textStyle),
          textAlign: TextAlign.left);
      tpi.layout();
      return tpi;
    });
  }
}
