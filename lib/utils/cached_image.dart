import 'dart:typed_data';

import 'package:flutter/material.dart';

class CachedMemoryImage extends StatelessWidget {
  static final Map<Key, Image> _cache = {};
  final Uint8List bytes;
  final Key identifier;

  const CachedMemoryImage({
    Key? key,
    required this.bytes,
    required this.identifier,
  }) : super(key: key);

  static void clearCache() {
    _cache.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_cache.containsKey(identifier)) {
      return _cache[identifier]!;
    } else {
      return _cache[identifier] = Image.memory(bytes);
    }
  }
}
