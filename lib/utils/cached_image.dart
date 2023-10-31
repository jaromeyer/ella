import 'dart:typed_data';

import 'package:flutter/material.dart';

class CachedMemoryImage extends StatelessWidget {
  static final Map<Key, Widget> _cache = {};
  final Uint8List bytes;
  final Key identifier;
  final double? width;
  final double? height;

  const CachedMemoryImage({
    super.key,
    required this.bytes,
    required this.identifier,
    this.height,
    this.width,
  });

  static void clearCache() {
    _cache.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cache.containsKey(identifier)) {
      _cache[identifier] = Image.memory(bytes);
    }
    return SizedBox(height: height, width: width, child: _cache[identifier]!);
  }
}
